// ignore_for_file: avoid_print

import 'package:application5/servicre/database_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final int memberCount;
  final String groupIconUrl;
  final String uid;
  final String descripition;

  const GroupTile({
    super.key,
    required this.groupName,
    required this.userName,
    required this.groupId,
    required this.memberCount,
    required this.groupIconUrl,
    required this.uid, required this.descripition,
  });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  final DatabaseService _databaseService = DatabaseService();
  String? groupIconUrl;

  @override
  void initState() {
    super.initState();
    getGroupIcon();
  }

  void getGroupIcon() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupId)
          .get();
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

  void showSnackbar(BuildContext context, Color color, String message) {
    if (!mounted) return; // Check if the widget is still mounted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<void> joinGroup() async {
    try {
      await _databaseService.groupJoin(widget.groupId, widget.userName, widget.groupName, widget.uid);
      if (!mounted) return; // Ensure the widget is still mounted before updating state or navigating
      showSnackbar(context, Colors.green, "Successfully joined the group");
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return; // Ensure the widget is still mounted before updating state or showing SnackBar
      showSnackbar(context, Colors.red, "Failed to join the group");
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          
          height: 452,
      
          width: 430,
          
        padding: const EdgeInsets.fromLTRB(17, 52, 17, 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
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
                const SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.groupName,
                     style: GoogleFonts.workSans(textStyle:
                    const TextStyle(
                        color: Color.fromRGBO(79, 121, 91, 1),
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        ),
                  )),
                    const SizedBox(height: 8,),
                    Row(
                      children: [
                        Image.asset("images/people.png",
                      width: 13,
                      height: 13,
                      color: const Color.fromRGBO(103, 113, 122, 1),),
                     Text(
                        " ${widget.memberCount} Members",
                           style: GoogleFonts.workSans(textStyle:
                    const TextStyle(
                        color: Color.fromRGBO(103, 113, 122, 1),
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.24
                        ),
                  )
                        
                    ,
                      ),
                      ],
                    )
                  ],
                )
                ],
              ),
              
              Container(
                margin: const EdgeInsets.only(top: 27),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 17),
                
                child: Text(widget.descripition,
                 style: GoogleFonts.workSans(textStyle:
                      const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        letterSpacing: -0.24,
                        fontWeight: FontWeight.w400
                      ))
                ),
              ),
    const SizedBox(height: 170,),
              MaterialButton(

                onPressed: () {
                  joinGroup();
                },
                height: 40 ,
                minWidth: 310,
                shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: const Color.fromRGBO(26, 116, 49, 1),
                child: Text('Join Community',
                style: GoogleFonts.workSans(textStyle:
                    const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
          ),),
              )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showBottomSheet(context);
      },
      child: Container(
        width: 160,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xffF1FCF3),
          border: Border.all(color: const Color(0xffB7D7BE)),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(left: 25, top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            groupIconUrl != null
                ? Container(
                    width: 160,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(groupIconUrl!),
                      ),
                    ),
                  )
                : const Icon(Icons.group, size: 100, color: Colors.grey),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.groupName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xff4F795B),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: "WorkSans",
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "images/people.png",
                    width: 13,
                    height: 13,
                    color: const Color.fromRGBO(103, 113, 122, 1),
                  ),
                  // SizedBox(width: 5),
                  Text(
                    " ${widget.memberCount} Members",
                    style: const TextStyle(
                      color: Color(0xff67717A),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: "WorkSans",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up resources here if needed
    super.dispose();
  }
}
