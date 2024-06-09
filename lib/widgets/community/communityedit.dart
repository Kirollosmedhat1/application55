import 'dart:io';


import 'package:application5/pages/community/chatpage.dart';
import 'package:application5/servicre/database_service.dart';
import 'package:application5/widgets/community/screen&snack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CoummuntiyEdit extends StatefulWidget {
  final int memberCount;
  final String groupName;
  final String userName;
  final String groupId;
  final String groupIconUrl;

   CoummuntiyEdit({
    Key? key,
    required this.groupName,
    required this.userName,
    required this.groupId,
    required this.groupIconUrl, 
    required this.memberCount,

  }) : super(key: key);
   

  @override
  State<CoummuntiyEdit> createState() => _CoummuntiyEditState();
}

class _CoummuntiyEditState extends State<CoummuntiyEdit> {
  late Future<int> _memberCountFuture;
  late String _selectedImage = widget.groupIconUrl;
    late String _selectedName= widget.groupName;



   File? _imageFile; // Variable to store the selected image file
  List<String> _communityImages = [];

    
    String? groupIconUrl ;
     String? groupName ;
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
void getGroupName() async {
  try {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("groups").doc(widget.groupId).get();
    if (snapshot.exists && snapshot.data() != null) {
      // Cast snapshot.data() to Map<String, dynamic>
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // Check if 'groupIcon' exists in the data map
      if (data.containsKey('groupName')) {
        setState(() {
          groupName = data['groupName'];
        });
      }
    }
  } catch (e) {
    print("Error fetching group icon: $e");
  }
}

  @override
  void initState() {
    getGroupIcon();
    getGroupName();
    super.initState();

  }

  void _updateGroupIcon(String imageUrl) async {
    await DatabaseService().updateGroupIcon(widget.groupId, imageUrl);
    setState(() {
      _selectedImage = imageUrl;
    });
  }
void _updateGroupName(String groupName) async {
    await DatabaseService().updateGroupIcon(widget.groupId, groupName);
    setState(() {
      _selectedName = groupName;
    });
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        nextScreen(
          context,
          ChatPage(
            groupId: widget.groupId,
            groupName: widget.groupName,
            userName: widget.userName, memberCount: widget.memberCount, adminName: '', wallpaperrUrl: 'https://media.architecturaldigest.com/photos/641c9af144453f6645298ec9/16:9/w_2240,c_limit/GettyImages-1379011538%20(1).jpg', imag: '', members: '', descripition: '',
   

          ),
        );
      },
      child: Container(
        width: 376,
        height: 96,
     
        margin: const EdgeInsets.all(20),
        // padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   fit: BoxFit.fitWidth,
          //   image: AssetImage("assets/arrow.png"),
          // ),
          color: const Color(0xffF1FCF3),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(10),
            right: Radius.circular(10),
          ),
          border: Border.all(color: const Color(0xffB7D7BE)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             groupIconUrl != null
                ? Container(
                  width: 92,
                  height:84 ,
                
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(groupIconUrl!))
                  ),
                  
                )
                : const Icon(Icons.abc),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                 "$groupName",
                  style: const TextStyle(fontSize: 20, color: Color(0xff1A7431)),
                ),
                const SizedBox(height: 5),
                
                  Row(
                    children: [
                      Image.asset("images/people.png",
                      width: 13,
                      height: 13,
                      color: const Color.fromRGBO(103, 113, 122, 1),),
                      Text(
                        " ${widget.memberCount} Members",
                        style: const TextStyle(
                          color: Color.fromRGBO(103, 113, 122, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: "WorkSans",
                        ),
                      ),
                      const SizedBox(width: 130,),
                      const Icon(Icons.arrow_forward_ios_outlined,
                      size: 20,
                      color: Color.fromRGBO(79, 121, 91, 1),)
                    ],
                  ),
               
              ],
            ),
          ],
        ),
      ),
    );
  }
}
