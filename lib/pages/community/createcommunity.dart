import 'dart:io';
import 'dart:ui';


import 'package:application5/servicre/database_service.dart';

import 'package:application5/widgets/MyTextField.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateCommunity extends StatefulWidget {
  final String groupId;
  final String groupIconUrl;
  final String wallpaperrUrl;
  final String members;
  final Function(String) onImageSelected;
  final Function(String) onWallpaperSelected;

  const CreateCommunity({
    super.key,
    required this.groupId,
    required this.groupIconUrl,
    required this.onImageSelected,
    required this.wallpaperrUrl,
    required this.onWallpaperSelected,
    required this.members,
  });

  @override
  State<CreateCommunity> createState() => _CreateCommunityState(
      groupIconUrl: groupIconUrl,
      groupId: groupId,
      wallpaperrUrl: wallpaperrUrl,
      onWallpaperSelected: (String wallUrl) {});
}

class _CreateCommunityState extends State<CreateCommunity> {
  String groupName = "";
  String descripition= "";
  String userName = "";
  String groupIconUrl;
  String wallpaperrUrl;
  final String groupId;

  _CreateCommunityState(
      {required this.wallpaperrUrl,
      required this.groupIconUrl,
      required this.groupId,
      required this.onWallpaperSelected});
  final Function(String) onWallpaperSelected;

// Variable to store the selected image file
  List<String> _communityImages = [];

  var wallpaperList = [];
  List<String> _wallpaperImages = [];

  void _showWallpaperPickerBottomSheet() {
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
          itemCount: _wallpaperImages.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _handleWallpaperSelection(_wallpaperImages[i]);
                });
              },
              child: Image.network(
                _wallpaperImages[i],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
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
      final ListResult result =
          await FirebaseStorage.instance.ref("communityimages/").listAll();
      List<String> imageUrls = [];
      for (final ref in result.items) {
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
    // Update the groupIconUrl with the selected image URL
    setState(() {
      groupIconUrl = imageUrl;
    });

    // Call onImageSelected with the selected image URL
    widget.onImageSelected(imageUrl);

    // Close the bottom sheet
    Get.back();
  }

  Future<void> _fetchwallpaperImages() async {
    try {
      final ListResult res =
          await FirebaseStorage.instance.ref("wallpaperimages/").listAll();
      List<String> wallUrl = [];
      for (final refe in res.items) {
        final walurl = await refe.getDownloadURL();
        wallUrl.add(walurl);
      }
      setState(() {
        _wallpaperImages = wallUrl;
      });
    } catch (e) {
      print('Error fetching community images: $e');
    }
  }

  void _handleWallpaperSelection(String wallUrl) {
    // Update the groupIconUrl with the selected image URL
    setState(() {
      wallpaperrUrl = wallUrl;
    });

    // Call onImageSelected with the selected image URL
    widget.onWallpaperSelected(wallUrl);

    // Close the bottom sheet
    Get.back();
    Get.snackbar(
      "",
      "",
    );
  }

  void _updateWallpaperIcon(String wallUrls) async {
    try {
      // Update the group icon URL in Firestore
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupId)
          .update({
        'wallpaperIcon': wallUrls,
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

  @override
  void initState() {
    _fetchCommunityImages();
    _fetchwallpaperImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1fcf3),
      appBar: AppBar(
        backgroundColor: const Color(0xfff1fcf3),
        
      leading:     TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(("CommunityHome"), (route) => true);
          },
          child: Text(
            "Cancel",
            style: GoogleFonts.workSans(
           textStyle : const TextStyle(
              color: Color(0xffd82416),
              letterSpacing: -0.24,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                shadows: [
                  Shadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    blurRadius: 4.0,
                    offset: Offset(0, 4.0)
                  )
                ]
           )
              
                 ),
          ),
        ),
      leadingWidth:90 ,
        centerTitle: true,
        title: 
        Text(
          "Create New Community",
          style: GoogleFonts.workSans(textStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 20,
          color: Color.fromRGBO(79, 121, 91, 1),
          letterSpacing: -0.24,
          ),
        ),
       
      ),),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),

              groupIconUrl != null
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(groupIconUrl)
                        )
                      ),
                      height: 150,
                      
                    
                    )
                  : const Icon(Icons.image_not_supported,
                  size: 150,),
                  const SizedBox(height: 15,),

              TextButton(
                onPressed: () {
                  _showImagePickerBottomSheet();
                },
                child: Text(
                  "Add Photo",
                  style: GoogleFonts.workSans(textStyle:
                  const TextStyle(
                      color: Color.fromRGBO(21, 48, 224, 1), fontWeight: FontWeight.w400,
                      fontSize: 20,
                      letterSpacing: -0.24),
                ),
              ),),

           
              TextButton(
                onPressed: () {
                  _showWallpaperPickerBottomSheet();
                },
                child: Text(
                  "Add Wallpaper",
                  style: GoogleFonts.workSans(textStyle:
                  const TextStyle(
                      color: Color.fromRGBO(21, 48, 224, 1), fontWeight: FontWeight.w400
                      ,fontSize: 20,
                      letterSpacing: -0.24),
                      
                ),)
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 51,
                width: 369,
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
                    hintText: "Community Name",
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
              Container(
                height: 51,
                width: 369,
                child: TextFormField(
                  onChanged: (val) {
                    setState(() {
                      descripition = val;
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
                    hintText: "Add Group Description",
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
                height:45,
              ),
              Container(
                child: MaterialButton(
                  onPressed: () async {
                    if (groupName.isNotEmpty && descripition.isNotEmpty) {
                      setState(() {
                      });
                      await DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(
                              userName, // assuming you have this value
                              widget.groupId, // assuming this should be the id
                              groupName, // community name
                              groupIconUrl,
                              wallpaperrUrl,
                              descripition
                              // widget.members

                              )
                          .then((_) {
                        setState(() {
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Group created successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                       Get.off(Page);
                      });
                    }
                  },
                  height: 40,
                  minWidth: 282,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: const Color(0xff1b602d),
                  child: Text(
                    "Create Community",
                    style: GoogleFonts.workSans(textStyle:
                    const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        ),
                  ),)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
