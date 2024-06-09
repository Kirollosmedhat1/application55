

// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
final CollectionReference TipsAndInformationCollection = 
FirebaseFirestore.instance.collection("TipsAndInformation");
  // saving the userdata
  Future savingUserData(String userName, String email) async {
   try {
      await userCollection.doc(uid).set({
        "userName": userName,
        "email": email,
        "groups": [], // Initialize with an empty array
        "profilePic": "",
        "uid": uid,
        "myplant": [],
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName, String groupIconUrl, String wallpaperrUrl,String descripition) async {
    try{DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": groupIconUrl,
      "admin": "${id}_$userName",
      "members": [uid],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "wallpaperIcon":wallpaperrUrl,
      "descripition": descripition,
      
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }catch (e) {
      print('Error creating group and adding user: $e');
    }
  }


 
  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }


 



 Future getGroupAdmin(String groupId)async{
  DocumentReference d = groupCollection.doc(groupId);
  DocumentSnapshot documentSnapshot = await d.get();
  return documentSnapshot['admin'];


}
//get group members
getGroupMembers(groupId) async{
  return groupCollection.doc(groupId).snapshots();
}

//search
 searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }


//function -> bool
Future<bool> isUserJoined(String groupName, String groupId, String userName )async{
DocumentReference userDocumentReference = userCollection.doc(uid);
DocumentSnapshot documentSnapshot = await userDocumentReference.get();


List <dynamic> groups = await documentSnapshot['groups'];
if(groups.contains("${groupId}_$groupName")){
  return true;
}else{
  return false;
}
}

//toggling the group join/exit
Future toggleGroupJoin(String groupId, String userName, String groupName)async{
  //doc reference
  DocumentReference userDocumentReference = userCollection.doc(uid);
  DocumentReference groupDocumentReference = groupCollection.doc(groupId);

  DocumentSnapshot documentSnapshot = await userDocumentReference.get();
  List<dynamic> groups = await documentSnapshot['groups'];

  //if user has our groups -> then remove then or also in other part re join
  if(groups.contains("${groupId}_$groupName")){
    await userDocumentReference.update({
      "groups" : FieldValue.arrayRemove(["${groupId}_$groupName"])
    });

     await groupDocumentReference.update({
      "members" : FieldValue.arrayRemove(["$uid"])
    });
  }else{

    
    await userDocumentReference.update({
      "groups" : FieldValue.arrayUnion(["${groupId}_$groupName"])
    });

     await groupDocumentReference.update({
      "members" : FieldValue.arrayUnion(["$uid"])
    });

  
}
}

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
      "audio" : chatMessageData['audio'].toString(),
      "image" : chatMessageData['image'].toString()
    });
  }

Stream<List<Map<String, dynamic>>> getGroupsNotJoined(String uid) {
  return FirebaseFirestore.instance
      .collection('groups')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .where((doc) => !(doc['members'] as List<dynamic>).contains(uid))
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList());
}
 Future<int> getMemberCount(String groupId) async {
    DocumentSnapshot snapshot = await groupCollection.doc(groupId).get();
    List<dynamic> members = snapshot['members'] ?? [];
    return members.length;
  }

 Future<void> updateGroupName(String groupId, String groupName) async {
    try {
      final groupDoc = FirebaseFirestore.instance.collection('groups').doc(groupId);
      await groupDoc.update({'groupName': groupName});
    } catch (e) {
      print('Error updating group name: $e');
    }
  }


  Future<void> updateGroupIcon(String groupId, String imageUrl) async {
    try {
      final groupDoc = FirebaseFirestore.instance.collection('groups').doc(groupId);
      await groupDoc.update({'groupIcon': imageUrl});
    } catch (e) {
      print('Error updating group icon: $e');
    }
  }

   Future<void> updateWallpaperIcon(String groupId, String wallUrl) async {
    try {
      final groupDoc = FirebaseFirestore.instance.collection('groups').doc(groupId);
      await groupDoc.update({'wallpaperIcon': wallUrl});
    } catch (e) {
      print('Error updating group icon: $e');
    }
  }
  Future<List<String>> fetchCommunityImages() async {
  List<String> imageUrls = [];
  try {
    // Change 'images' to the path where your images are stored in Firebase Storage
    final ListResult result = await FirebaseStorage.instance.ref("communityimages/").listAll();
    for (final ref in result.items) {
      final url = await ref.getDownloadURL();
      imageUrls.add(url);
    }
  } catch (e) {
    print('Error fetching community images: $e');
  }
  return imageUrls;
}




  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkIfUserJoinedGroup(String groupId, String userName) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("members")
          .doc(userName)
          .get();

      return snapshot.exists;
    } catch (e) {
      print("Error checking if user joined group: $e");
      return false;
    }
  }

Future<void> groupJoin(String groupId, String userName, String groupName, String uid) async {
  try {
    DocumentReference userDocumentReference = FirebaseFirestore.instance.collection("users").doc(uid);
    DocumentReference groupDocumentReference = FirebaseFirestore.instance.collection("groups").doc(groupId);

    DocumentSnapshot userSnapshot = await userDocumentReference.get();
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

    // Check if user document exists and create if it doesn't
    if (!userSnapshot.exists) {
      await userDocumentReference.set({
        "groups": [], // Initialize with an empty list or any default value
      });
      userData = {"groups": []}; // Update the userData variable
    }

    List<dynamic> groups = userData?['groups'] ?? [];

    // Check if user is already in the group
    if (!groups.contains("${groupId}_$groupName")) {
      // Update user's groups
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });

      // Update group members
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion([uid])
      });

      print("Successfully joined the group");
    } else {
      print("User is already a member of this group");
    }
  } catch (e) {
    print("Error joining group: $e");
    throw e; // Rethrow the error to handle it in the UI
  }
}







  Future<void> clearChat(String groupId) async {
    try {
      QuerySnapshot messagesSnapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .get();

      for (DocumentSnapshot doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print("Error clearing chat: $e");
      throw e;
    }
  }
Future<Map<String, dynamic>> getGroupDetails(String groupId) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("groups").doc(groupId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return {
          'groupName': snapshot['groupName'],
          'descripition': snapshot['descripition'],
        };
      }
    } catch (e) {
      print("Error fetching group details: $e");
    }
    return {
      'groupName': null,
      'descripition': null,
    };
  }


}


