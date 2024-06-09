// ignore_for_file: unused_element, avoid_print, use_build_context_synchronously, unnecessary_this

import 'dart:io';

import 'package:application5/servicre/database_service.dart';
import 'package:application5/widgets/MyTextField.dart';

import 'package:application5/widgets/myTextFieldLable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WallpaperGroup extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String descripition;
  final String adminName;
  final String groupIconUrl;
  final Function(String) onImageSelected;
  final Function(String) onGroupNameChanged;
  final Function(String) onDeschanged;

  const WallpaperGroup({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminName,
    required this.onWallpaperSelected,
    required this.groupIconUrl,
    required this.onImageSelected,
    required this.descripition,
    required this.onGroupNameChanged,
    required this.onDeschanged,
  });

  final Function(String) onWallpaperSelected;

  @override
  State<WallpaperGroup> createState() => _WallpaperGroupState();
}

class _WallpaperGroupState extends State<WallpaperGroup> {
  final DatabaseService _databaseService = DatabaseService();
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _DescController = TextEditingController();

  // Variable to store the selected image file
  List<String> _wallpaperImages = [];
  late String _selectedImage = widget.groupIconUrl;
  var wallpaperList = [];
  String? wallpaperrUrl;
  File? _imageFile; // Variable to store the selected image file
  List<String> _communityImages = [];

  String? groupIconUrl;
  // Function to get the group icon URL from Firestore
  void getGroupIcon() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupId)
          .get();
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

  void _updateGroupName(String groupName) async {
    try {
      // Update the group name in Firestore
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupId)
          .update({
        'groupName': groupName,
      });
      // Show a snackbar indicating that the group name was updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Group name updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error updating group name: $e");
      // Show a snackbar indicating that an error occurred while updating the group name
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error updating group name"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateDesc(String descripition) async {
    try {
      // Update the group name in Firestore
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupId)
          .update({
        'descripition': descripition,
      });
      // Show a snackbar indicating that the group name was updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Group descripition updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error updating descripition name: $e");
      // Show a snackbar indicating that an error occurred while updating the group name
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error updating descripition name"),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  void _handleDonePressed() {
    bool groupNameChanged = _groupNameController.text != widget.groupName;
    bool descriptionChanged = _DescController.text != widget.descripition;

    if (groupNameChanged) {
      _updateGroupName(_groupNameController.text);
    }

    if (descriptionChanged) {
      _updateDesc(_DescController.text);
    }
  }

  // Function to get the group icon URL from Firestore
  void getWallpaperIcon() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupId)
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        // Cast snapshot.data() to Map<String, dynamic>
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        // Check if 'groupIcon' exists in the data map
        if (data.containsKey('wallpaperIcon')) {
          setState(() {
            wallpaperrUrl = data['wallpaperIcon'];
          });
        }
      }
    } catch (e) {
      print("Error fetching group icon: $e");
    }
  }

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

  void _handleGroupNameSelection(String groupName) {
    setState(() {
      this.groupName = groupName;
    });

    widget.onGroupNameChanged(groupName);

    // Clear the hint text when user starts typing
    if (_groupNameController.text == widget.groupName) {
      _groupNameController.clear();
    }
  }

  void _handleDescSelection(String description) {
    setState(() {
      _DescController.text = description; // Update the text controller
      this.descripition = description; // Update the local variable (optional)
    });

    widget.onDeschanged(description);
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
    _updateWallpaperIcon(wallUrl);
    if (widget.groupId.isNotEmpty && wallUrl.isNotEmpty) {
      // Update the groupIconUrl with the selected image URL
      setState(() {
        wallpaperrUrl = wallUrl;
      });

      // Call onImageSelected with the selected image URL
      widget.onWallpaperSelected(wallUrl);

      // Close the bottom sheet
      Get.back();
    } else {
      // Handle the case where groupId or imageUrl is empty or null
      print('Error: Empty groupId or wallUrl');
      // Optionally, display a message to the user indicating that the image selection failed
    }
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

  String groupName = "";
  String descripition = "";
  String userName = "";

  Future<void> _fetchGroupDetails() async {
    try {
      final groupDetails =
          await _databaseService.getGroupDetails(widget.groupId);
      setState(() {
        groupName = groupDetails['groupName'];
        descripition = groupDetails['descripition'];
      });
    } catch (e) {
      print("Error fetching group details: $e");
    }
  }

  @override
  void initState() {
    _fetchwallpaperImages();
    getGroupIcon();
    getWallpaperIcon();
    _fetchGroupDetails();
    _fetchCommunityImages();
    _groupNameController.text = widget.groupName; // Set initial group name
    _DescController.text = widget.descripition; // Set initial description
    super.initState();
  }

  void _updateGroupIcon(String imageUrl) async {
    await DatabaseService().updateGroupIcon(widget.groupId, imageUrl);
    setState(() {
      _selectedImage = imageUrl;
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 90,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.workSans(
                textStyle: const TextStyle(
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
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Edit Chat Settings",
          style: GoogleFonts.workSans(
            textStyle: const TextStyle(
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
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        titleTextStyle: const TextStyle(color: Color.fromRGBO(21, 46, 224, 1)),
        actions: [
          TextButton(
            onPressed: () {
              _handleDonePressed();
            },
            child: Text(
              "Done",
              style: GoogleFonts.workSans(
                textStyle: const TextStyle(
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
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: groupIconUrl != null
                    ? SizedBox(
                        height: 145,
                        width: 145,
                        child: ClipOval(
                          child: Image.network(
                            fit: BoxFit.fill,
                            groupIconUrl!,
                          ),
                        ),
                      )
                    : const Icon(Icons.abc),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    _showImagePickerBottomSheet();
                  },
                  child: const Text(
                    "Add Photo",
                    style: TextStyle(
                      letterSpacing: -0.24,
                      fontSize: 20,
                      color: Color(0xff152ee0),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    _showWallpaperPickerBottomSheet();
                  },
                  child: const Text(
                    "Add New wallpaper",
                    style: TextStyle(
                      letterSpacing: -0.24,
                      fontSize: 20,
                      color: Color(0xff152ee0),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: MyTextFieldLable(lable: "Change Group Name"),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 51,
                child: TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: _groupNameController,
                  onChanged: (val) {
                    _handleGroupNameSelection(val);
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xfff2f2f2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: const Color(0xfff2f2f2),
                    hintText: groupName,
                    hintStyle: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(153, 157, 163, 1),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    filled: true,
                    suffixIcon: GestureDetector(
                        onTap: () {
                          _groupNameController.clear();
                          _handleGroupNameSelection('');
                        },
                        child: Image.asset("images/del.png")),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: MyTextFieldLable(lable: "Change Group Descripiton")),
              const SizedBox(height: 10),
              SizedBox(
                height: 51,
                child: TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: _DescController,
                  onChanged: (val) {
                    _handleDescSelection(val);
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xfff2f2f2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: const Color(0xfff2f2f2),
                    hintText: descripition,
                    hintStyle: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(153, 157, 163, 1),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    filled: true,
                    suffixIcon: GestureDetector(
                        onTap: () {
                          _DescController.clear();
                          _handleDescSelection('');
                        },
                        child: Image.asset("images/del.png")),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
