import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupEdit extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;

  const GroupEdit({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminName,
    required this.onImageSelected,
  });

  final Function(String) onImageSelected;

  @override
  State<GroupEdit> createState() => _GroupEditState();
}

class _GroupEditState extends State<GroupEdit> {
  File? _imageFile; // Variable to store the selected image file
  List<String> _communityImages = [];

    var imageList =[];
    String? groupIconUrl ;



    void _updateGroupIcon(String imageUrl) async {
  try {
    // Update the group icon URL in Firestore
    await FirebaseFirestore.instance.collection("groups").doc(widget.groupId).update({
      'groupIcon': imageUrl,
    });
    // Show a snackbar indicating that the group icon was updated successfully
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Group icon updated successfully"),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    print("Error updating group icon: $e");
    // Show a snackbar indicating that an error occurred while updating the group icon
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error updating group icon"),
        backgroundColor: Colors.red,
      ),
    );
  }
}



// Function to get the group icon URL from Firestore
 void getGroupIcon() async {
  try {
    
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("groups").doc(widget.groupId).get();
    if (snapshot.exists && snapshot.data() != null) {

      // Cast snapshot.data() to Map<String, dynamic>
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // Check if 'groupIcon' exists in the data map
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


  void _showImagePickerBottomSheet() {
    Get.bottomSheet(
      Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
          ),
          itemCount: _communityImages.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _handleImageSelection(_communityImages[i]);
                });
              },
              child: Image.network(
                _communityImages[i],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _fetchCommunityImages() async {
    try {
      final ListResult res =
          await FirebaseStorage.instance.ref("communityimages/").listAll();
      List<String> imageUrls = [];
      for (final ref in res.items) {
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
      setState(() {
        _communityImages = imageUrls;
      });
    } catch (e) {
      print('Error fetching community images: $e');
    }
  }
void _handleImageSelection(String imageUrl) {
  _updateGroupIcon(imageUrl);
  if (widget.groupId.isNotEmpty && imageUrl.isNotEmpty) {
    // Update the groupIconUrl with the selected image URL
    setState(() {
      groupIconUrl = imageUrl;
    });

    // Call onImageSelected with the selected image URL
    widget.onImageSelected(imageUrl);

    // Close the bottom sheet
    Get.back();
  } else {
    // Handle the case where groupId or imageUrl is empty or null
    print('Error: Empty groupId or imageUrl');
    // Optionally, display a message to the user indicating that the image selection failed
  }
}






  String groupName = "";
  String groupDesc = "";
  String userName = "";

  @override
  void initState() {
    _fetchCommunityImages();
    
    getGroupIcon();
    super.initState();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      leadingWidth:90,
      leading: Padding(
        padding:  const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(("CommunityHome"), (route) => true);
          },
          child: Text(
            "Cancel",
            style: GoogleFonts.workSans(textStyle:const TextStyle( 
          letterSpacing: -0.24,
           shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4),
                              ),
                            ],
          color: Color(0xffd82416),
          fontSize: 18,
          fontWeight: FontWeight.w400,)),
              
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        "Edit Group",
        style: GoogleFonts.workSans(textStyle:const TextStyle( 
          letterSpacing: -0.24,
           shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4),
                              ),
                            ],
          color: Color.fromRGBO(21, 46, 224, 1),
          fontSize: 18,
          fontWeight: FontWeight.w400,)),
      ),
      titleTextStyle: const TextStyle(color: Color.fromRGBO(21, 46, 224, 1)),
      actions: [
        TextButton(onPressed: () {}, 
        child: Text("Done",
        style: GoogleFonts.workSans(textStyle:const TextStyle( 
          letterSpacing: -0.24,
           shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4),
                              ),
                            ],
          color: Color.fromRGBO(21, 46, 224, 1),
          fontSize: 18,
          fontWeight: FontWeight.w400,)),
       
         

    ))],
    ),
    body: Container(
    
  
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
            // Display the group icon from Firestore if available
            groupIconUrl != null
                ? Container(
                 
                  
                 
                   height: 145,
                    width: 145,
                  child: ClipOval(
                    child: Image.network(
                      fit: BoxFit.fill,
                     
                      
                        groupIconUrl!,
                        // You can specify width, height, fit, etc., as needed
                      ),
                  ),
                )
                : const Icon(Icons.abc),
                const SizedBox(height: 20,),
          TextButton(
            onPressed: () {
              _showImagePickerBottomSheet();
            },
            child: const Text(
              "Add Photo",
              style: TextStyle(
                letterSpacing: -0.24,
                fontSize: 20,
                color: Color(0xff152ee0), fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 51,
            child: TextFormField(
              onChanged: (val) {
                setState(() {
                  groupName = val;
                });
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xfff2f2f2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)),
                fillColor: const Color(0xfff2f2f2),
                hintText: widget.groupName,
                hintStyle: const TextStyle(
                  fontSize: 17,
                  color: Color(0xff928FA6),
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
              ),
            ),
          ),
          const SizedBox(
            height: 14,
          ),
        ],
      ),
    ),
  );
  }}