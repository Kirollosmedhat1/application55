import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CycleController extends GetxController {
  late String name;
  var informationList = [].obs;
  var topArticlesList = [].obs;
  List<DocumentSnapshot> myplant = [];

  @override
  void onInit() {
    getTipsAndInformation();
    getTopArticles();
    getMyplant();
    super.onInit();
  }

  void getTipsAndInformation() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("TipsAndInformation").get();
    informationList.addAll(querySnapshot.docs);
  }

  void getTopArticles() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("TopArticles").get();
    topArticlesList.addAll(querySnapshot.docs);
  }

  void getFavoriteTips() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("TipsAndInformation")
        .where("favorite", isEqualTo: true) // Add where condition
        .get();
    informationList.addAll(querySnapshot.docs);
  } catch (e) {
    print("Error getting favorite tips: $e");
  }
}

void getFavoriteArticles() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("TopArticles")
        .where("favorite", isEqualTo: true) // Add where condition
        .get();
    topArticlesList.addAll(querySnapshot.docs);
  } catch (e) {
    print("Error getting favorite articles: $e");
  }
}

  Future<bool> fetchFavoriteState(String articleName) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection("TopArticles");
      QuerySnapshot querySnapshot =
          await collectionReference.where("name", isEqualTo: articleName).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        bool favorite = docSnapshot.get("favorite");
        return favorite;
      } else {
        print("Article not found: $articleName");
        return false;
      }
    } catch (e) {
      print("Error fetching favorite state: $e");
      return false;
    }
  }

  Future<void> toggleFavorite(String articleName, bool currentFavorite) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection("TipsAndInformation");
      QuerySnapshot querySnapshot =
          await collectionReference.where("name", isEqualTo: articleName).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference docRef = querySnapshot.docs.first.reference;
        bool newFavorite = currentFavorite;
        await docRef.update({"favorite": newFavorite});
        print("Favorite toggled successfully: $newFavorite");
      } else {
        print("Article not found: $articleName");
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  Future<bool> fetchPlantFavoriteState(String plantName) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection("TipsAndInformation");
      QuerySnapshot querySnapshot =
          await collectionReference.where("name", isEqualTo: plantName).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        bool favorite = docSnapshot.get("favorite");
        return favorite;
      } else {
        print("Article not found: $plantName");
        return false;
      }
    } catch (e) {
      print("Error fetching favorite state: $e");
      return false;
    }
  }

  Future<void> togglePlantFavorite(String plantName, bool currentFavorite) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection("TipsAndInformation");
      QuerySnapshot querySnapshot =
          await collectionReference.where("name", isEqualTo: plantName).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference docRef = querySnapshot.docs.first.reference;
        bool newFavorite = currentFavorite;
        await docRef.update({"favorite": newFavorite});
        print("Favorite toggled successfully: $newFavorite");
      } else {
        print("Article not found: $plantName");
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  // final myplanet = [].obs;
  // void getMyplant() async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("TipsAndInformation").get();
  //   myplanet.addAll(querySnapshot.docs);
  // }





Future<void> getMyplant() async {
  try {
    // Fetch documents from TipsAndInformation collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("TipsAndInformation").get();
    
    // Add fetched documents to myplant list
    myplant.addAll(querySnapshot.docs);
    
    // Get the current user's ID
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Reference to the user's document in the users collection
    DocumentReference userDocumentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(uid);

    // Create a list to hold the tips data
    List<Map<String, dynamic>> tipsData = [];

    // Extract data from each document and add to the tipsData list
    for (var doc in myplant) {
      tipsData.add(doc.data() as Map<String, dynamic>);
    }

    // Add the tips data to the myplant field in the user's document
    await userDocumentReference.update({
      'myplant': FieldValue.arrayUnion(tipsData),
    });

    print('Tips added to myplant successfully');
  } catch (e) {
    print('Error adding tips to myplant: $e');
  }
}
Stream<List<Map<String, dynamic>>> getPlants() {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.exists && snapshot.data()!.containsKey('myplant')) {
          List<dynamic> myplants = snapshot.data()!['myplant'];
          return myplants.cast<Map<String, dynamic>>().toList();
        } else {
          return [];
        }
      });
}

}
