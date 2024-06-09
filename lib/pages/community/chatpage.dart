import 'dart:io';
import 'package:application5/Helper/helper_function.dart';
import 'package:application5/pages/community/communityhome.dart';

import 'package:application5/servicre/database_service.dart';
import 'package:application5/widgets/community/message_tile.dart';
import 'package:application5/widgets/community/screen&snack.dart';

import 'package:application5/widgets/community/wallpaperGroup.dart';
import 'package:flutter/widgets.dart'; // Importing BuildContext from the correct package

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
    
  final String adminName;
   String descripition;
  final String members;
  final int memberCount;
  final String groupId;
  final String groupName;
  final String userName;
  String imag;
  late File chosenImage;
  bool isMessageSend = false;
  // final record = AudioRecorder();
  bool is_recording = false;
  String path = '';
  String Url = '';
  String sendImageUrl = '';
  final String wallpaperrUrl;
    bool isJoined = false; 
  User? user;
  ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    required this.memberCount,
    required this.adminName,
    required this.wallpaperrUrl,
    required this.imag, required this.members, required this.descripition,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
    final DatabaseService _databaseService = DatabaseService();

  String? groupIconUrl;
  String? wallpaperrUrl;
   bool isJoined = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

void clearChat(context) async {
  try {
    // Show confirmation dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: const Text("Clear all messages from ")),
          content: const Text("Are you sure you want to clear the chat?"),
          actions: [
            Container(
              width: 392,
              height:81,
              child: InkWell(
                onTap: () async {
                // Delete all messages from Firestore
                await DatabaseService().clearChat(widget.groupId);
                Navigator.of(context).pop();
              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Clear All Message",
                    ),
                    Image.asset("images/clear.png")
                
                  ],
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            
          ],
        );
      },
    );
  } catch (e) {
    print("Error clearing chat: $e");
  }
}




  // final record = AudioRecorder();
  //  getCurrentUserIdandName(String userName, User? user ) async {
  //   await HelperFunction.getUserNameFromSF().then((value) {
  //     setState(() {
  //       userName = value!;
  //     });
  //   });
  //   user = FirebaseAuth.instance.currentUser;
  // }
  //  joinedOrNot(String userName, String groupId, String groupname,String admin, User? user, bool isJoined ) async{
  //   await DatabaseService(uid:  user!. uid)
  //   .isUserJoined(groupname, groupId, userName)
  //   .then((value) {
  //     setState(() {
  //       isJoined = value;
  //     });
  //   });
  // }

  String getName(String r) {
    return r.substring(r.indexOf("") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf(""));
  }
  @override
  void initState() {
      // getCurrentUserIdandName( widget.userName, widget.user);
    getWallpaperIcon();
    getChatAndAdmin();
    getGroupIcon();
    getDescripition();
    messageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void getWallpaperIcon() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("groups").doc(widget.groupId).get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('wallpaperIcon')) {
          setState(() {
            wallpaperrUrl = data['wallpaperIcon'];
          });
        }
      }
    } catch (e) {
      print("Error fetching wallpaper icon: $e");
    }
  }
  void getDescripition() async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("groups").doc(widget.groupId).get();
    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey('descripition')) {
        setState(() {
          widget.descripition = data['descripition']; // Ensure 'description' matches your Firestore field name
        });
      }
    }
  } catch (e) {
    print("Error fetching wallpaper icon: $e");
  }
}


  void getGroupIcon() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("groups").doc(widget.groupId).get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('groupIcon')) {
          setState(() {
            groupIconUrl = data['groupIcon'];
          });
        }
      }
    } catch (e) {
      print("Error fetching group icon: $e");
    }
  }

  getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    key: _scaffoldKey, // Ensure that the key is set here
    appBar: AppBar(
      elevation: 0,
      title: Text(
        widget.groupName,
        style: const TextStyle(
          fontFamily: "WorkSans",
          fontSize: 19,
          color: Color.fromRGBO(79, 121, 91, 1),
        ),
      ),
      leading: Icon(Icons.arrow_back_ios,
      color: Color.fromRGBO(26, 116, 49, 1),
      size: 19,),
      actions: [
  
        InkWell(
          onTap: () {
            if (_scaffoldKey.currentState != null) {
              _scaffoldKey.currentState!.openEndDrawer();
            }
          },
          child: Image.asset("images/info.png",
          width: 25,
          height: 25,)),
          SizedBox(width: 16,)
        
      ],
    ),
    endDrawer: Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          const SizedBox(height: 17,),
          Column(
            children: [
              Row(
                      
                children: [
                  const SizedBox(width: 14,),
                  const Icon(Icons.arrow_back_ios,
                  size: 20,
                  
                  color: Color.fromRGBO(26, 116, 49, 1),),
                  const SizedBox(width: 88,),
                  Text(
                    widget.groupName,
                    style: const TextStyle(color: Color.fromRGBO(79, 121, 91, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                  ),
                  
                ],
              ),
            ],
          ),
          const SizedBox(height: 34,),
          groupIconUrl != null
              ? Container(
                width: 145,
                height: 145,
                child: CircleAvatar(
                  
                    backgroundImage: NetworkImage(
                      groupIconUrl!,
                    ),
                  ),
              )
              : const Icon(
                  Icons.person,
                  size: 90,
                ),
          const SizedBox(
            height: 17,
          ),
         
          Column(
            children: [
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Image.asset("images/people.png",
                   width: 16,
                   height: 16,),
                    const SizedBox(width: 8,),
                    Text( "${widget.memberCount} Members",
                    style: GoogleFonts.workSans(
               textStyle : const TextStyle(
                  color: Color.fromRGBO(103, 113, 122, 1),
                  letterSpacing: -0.24,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                   
               )
                  
                     ),)
              
                  ],
                ),
            ],
          ),

    SizedBox(height: 10,),
 Center(
   child: Text(
      widget.descripition ?? 'Description Not Available',
     style: GoogleFonts.workSans(
                  textStyle:  TextStyle(color: Color.fromRGBO(153, 157, 163, 1),
                fontSize: 16,
                 letterSpacing: -0.24,
                fontWeight: FontWeight.w400),
                ),
    ),
 ),

SizedBox(height: 53,),

InkWell(
  onTap: (){
       Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => WallpaperGroup(
                    groupId: widget.groupId,
                    groupName: '',
                    adminName: '',
                    onWallpaperSelected: (p0) {}, descripition: '', groupIconUrl: '', onImageSelected: (p0) {}, onGroupNameChanged: (p0) {}, onDeschanged: (p0) {},
                  ),
                ),
                (route) => true,
              );
  },
  child: Padding(
    padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 5),

    child: Row(
      
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset("images/settings.png",
            width: 25,
            height: 25,),
            SizedBox(width: 30,),
             Text(
                "Edit Chat Settings",
                style: GoogleFonts.workSans(
                  textStyle:  TextStyle(color: Color.fromRGBO(79, 121, 91, 1),
                fontSize: 15,
                 letterSpacing: -0.24,
                fontWeight: FontWeight.w400),
                ),
             
              ),
          ],
             
    
        ),
        Icon(Icons.arrow_forward_ios,
        color:Color.fromRGBO(79, 121, 91, 1))
            
      ],
    ),
  ),

),
SizedBox(height: 20,),

InkWell(
  onTap: (){ },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Row(
      
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset("images/notf.png",
            width: 25,
            height: 25,),
            SizedBox(width: 30,),
             Text(
                "Notifications & Sounds",
                style: GoogleFonts.workSans(
                  textStyle:  TextStyle(color: Color.fromRGBO(79, 121, 91, 1),
                fontSize: 15,
                 letterSpacing: -0.24,
                fontWeight: FontWeight.w400),
                ),
             
              ),
          ],
        ),
        Icon(Icons.arrow_forward_ios,
        color:Color.fromRGBO(79, 121, 91, 1),)
            
      ],
    ),
  ),

),

       SizedBox(height: 20,),   
  InkWell(
   onTap: () => clearChat(context),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Row(
      
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset("images/trash.png",
            width: 25,
            height: 25,),
            SizedBox(width: 30,),
             Text(
                "Clear chat",
                style: GoogleFonts.workSans(
                  textStyle:  TextStyle(color: Color.fromRGBO(79, 121, 91, 1),
                fontSize: 15,
                 letterSpacing: -0.24,
                fontWeight: FontWeight.w400),
                ),
             
              ),
          ],
             
    
        ),
        Icon(Icons.arrow_forward_ios,
        color:Color.fromRGBO(79, 121, 91, 1))
            
      ],
    ),
  ),

),


          const SizedBox(
            height: 260,
          ),
          InkWell(
            
            onTap: () {
             Get.defaultDialog(
              contentPadding: EdgeInsets.only(bottom: 26,top: 26),
              titlePadding: EdgeInsets.only(top: 30,bottom: 1),
           
              content: Text(""),
             title:"Are you sure\n want to exit the \n community?".toString(),
             titleStyle: GoogleFonts.workSans(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5
            )
           ),
           
          
          cancel: Padding(
            padding: const EdgeInsets.only(right: 110),
            child: Text("Cancel", style: GoogleFonts.workSans(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(21, 46, 224, 1)
              )
             ),),
          ),
            //  contentPadding: EdgeInsets.fromLTRB(1, 20, 1, 20),
             
           confirm: Text("Exit",
           style: GoogleFonts.workSans(
            textStyle: TextStyle(  fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(229, 38, 24, 1)

            )
           ),),
            

             onCancel: (){
              Get.back();
             },

             onConfirm: 
               () async {
                              DatabaseService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .toggleGroupJoin(
                                      widget.groupId,
                                      getName(widget.adminName),
                                      widget.groupName)
                                  .whenComplete(() {
                                nextScreenReplace(context, CommunityHome(members: '',));
                              });
                            
             },
             
             );
            },
            child:  Row(
              children: [
                SizedBox(
                  width: 30,
                ),
            Image.asset("images/exit.png",
            width: 26.55,
            height: 28,),
                SizedBox(
                  width: 15,
                ),
                Text("Exit Community",
                style: GoogleFonts.workSans(
                textStyle:  TextStyle(color: Color.fromRGBO(24, 79, 39, 1),
              fontSize: 20,
               letterSpacing: -0.24,
              fontWeight: FontWeight.w500),
              ),
                ),
             
              ],
            ),
          ),
         
        ],
      ),
    ),
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: wallpaperrUrl != null
              ? NetworkImage(wallpaperrUrl!)
              : const NetworkImage("https://media.architecturaldigest.com/photos/641c9af144453f6645298ec9/16:9/w_2240,c_limit/GettyImages-1379011538%20(1).jpg"),
        ),
      ),
      child: Stack(
        children: <Widget>[
          chatMessages(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              color: Colors.white,
              child: Row(
                children: [
                   IconButton(
                    onPressed: () {
                      showSendImageBottomSheet(context);
                    },
                    icon:  Icon(Icons.add,
                   fill: CircularProgressIndicator.strokeAlignOutside,
                 
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      keyboardType: TextInputType.text,
                      controller: messageController,
                      decoration: InputDecoration(
                        
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(199, 201, 198, 1),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Type your message....",
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(104, 106, 138, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "WorkSans",
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  messageController.text.isEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.green,
                          child: IconButton(
                            onPressed: () {
                              if (!widget.is_recording) {
                                // startRecording();
                              } else {
                                // stopRecording();
                              }
                            },
                            icon: widget.is_recording ? const Icon(Icons.stop) : const Icon(Icons.mic),
                          ),
                        )
                      : CircleAvatar(
                        backgroundColor: Colors.green,
                        child: IconButton(
                          onPressed: () {
                            sendMessage();
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                 
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}



  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe: widget.userName == snapshot.data.docs[index]['sender'],
                    audio: "",image: "",
                    // snapshot.data.docs[index]['audio'], image: '',
                  );
                },
              )
            : Container();
      },
    );
  }

//  void startRecording() async {
//     final location = await getApplicationDocumentsDirectory();
//     String name = const Uuid().v1();

//     if (await record.hasPermission()) {
//       await record.start(const RecordConfig(), path: location.path + name + '.m4a');
//       setState(() {
//         widget.is_recording = true;
//       });

      // Call uploadFile after recording is complete
  //     await uploadFile(location.path + name + '.m4a');
  //   }
  //   print('start recording');
  // }


  Future<void> uploadFile(String filePath) async {
    try {
      File file = File(filePath);

      if (!file.existsSync()) {
        throw Exception('File does not exist at path: $filePath');
      }

      String name = basename(filePath);
      Reference ref = FirebaseStorage.instance.ref('voices/' + name);

      // Upload file to Firebase Storage
      await ref.putFile(file);

      // Get download URL
      String downloadUrl = await ref.getDownloadURL();

      setState(() {
        widget.Url = downloadUrl;
      });

      print('File uploaded successfully');
    } catch (e) {
      print('Error uploading file: $e');
      // Handle error
    }
  }



  // void stopRecording() async {
  //   if (widget.is_recording) {
  //     String? finalPath = await record.stop();
  //     setState(() {
  //       widget.path = finalPath ?? '';
  //       widget.is_recording = false;
  //     });
  //     print('stop recording');
  //   }
  // }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
        // "audio": widget.Url,
        // "image" : widget
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
        // widget.Url = '';
      });
    }
  }

  void showSendImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => IntrinsicHeight(
        child: Container(
          child: Column(
            children: [
              Card(
                child: ListTile(
                  onTap: () {
                    openImageCamera(context);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    openImageGallery(context);
                  },
                  leading: const Icon(Icons.photo),
                  title: const Text("Gallery"),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void openImageGallery(BuildContext context) async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.chosenImage = File(image.path);
      });
      showAndSend(context, widget.chosenImage);
    }
  }

  void openImageCamera(BuildContext context) async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        widget.chosenImage = File(image.path);
      });
      showAndSend(context, widget.chosenImage);
    }
  }

  Future<String> uploadImage(File chosenImage) async {
    try {
      String fileName = basename(chosenImage.path);
      Reference ref = FirebaseStorage.instance.ref('images/$fileName');
      await ref.putFile(chosenImage);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      print("Error uploading image: $error");
      return '';
    }
  }

  void showAndSend(BuildContext context, File chosenImage) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        color: Colors.black,
        child: Column(
          children: [
           
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                String imageUrl = await uploadImage(chosenImage);
                // sendMessage(imageUrl);
                if (context != null) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Send",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                alignment: Alignment.center,
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}