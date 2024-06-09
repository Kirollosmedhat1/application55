import 'dart:io';

import 'package:application5/pages/community/communityhome.dart';

import 'package:application5/servicre/database_service.dart';

import 'package:application5/widgets/community/comminutypic.dart';
import 'package:application5/widgets/community/screen&snack.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
    final String members;

  const GroupInfo({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.adminName, required this.members,
  }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  File? _imageFile; // Variable to store the selected image file

  // Function to handle image selection
  void _handleImageSelection(String imageUrl) {
    setState(() {
      // Update the selected image URL
      _imageFile = File(imageUrl);
    });

    // Save the selected image URL to Firebase
    DatabaseService().updateGroupIcon(widget.groupId, imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
        title: const Text("Group Info"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Exit"),
                    content: const Text("Are you sure you want to exit the group?"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.cancel, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () async {
                          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                              .toggleGroupJoin(widget.groupId, widget.adminName, widget.groupName)
                              .whenComplete(() {
                            nextScreenReplace(context, CommunityHome(members: widget.members,));
                          });
                        },
                        icon: const Icon(Icons.done, color: Colors.green),
                      )
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.lightGreenAccent,
                    child: _imageFile != null // Display selected image if available
                        ? Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          )
                        : Text(
                            widget.groupName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      const Text("Admin: dsa"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
           
            const SizedBox(height: 20,),
            Align(
              child: Center(
                child: CommunityPic(
                  onImageSelected: _handleImageSelection, // Pass the method to handle image selection
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
