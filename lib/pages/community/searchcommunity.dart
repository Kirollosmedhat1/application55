import 'package:application5/Helper/helper_function.dart';
import 'package:application5/pages/community/chatpage.dart';
import 'package:application5/servicre/database_service.dart';
import 'package:application5/widgets/community/screen&snack.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class SearchPage extends StatefulWidget {
    final int memberCount;
  const SearchPage({Key? key, required this.memberCount}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState(memberCount: 1);
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
final int memberCount ;
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false; 
  User? user;


  _SearchPageState({required this.memberCount});

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r) {
    return r.substring(r.indexOf("") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf(""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(241, 252, 243, 1),
      title: const Text("Search", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold,color: Colors.white),),
      ),
    
       
      body: Column(
        children: [
          Container(
            color: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups......",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(Icons.search, color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
            .searchByName(searchController.text)
            .then((snapshot) {
          setState(() {
            searchSnapshot = snapshot;
            isLoading = false;
            hasUserSearched = true;
          });
        });
      }
      } 
   groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
                
              );
            },
          )
        : Container();
  }
  joinedOrNot(String userName, String groupId, String groupname,String admin) async{
    await DatabaseService(uid:  user!. uid)
    .isUserJoined(groupname, groupId, userName)
    .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
        joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.green,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap :() async{
          await DatabaseService(uid:  user!.uid)
          .toggleGroupJoin(groupId, userName, groupName);
          if(isJoined){
            setState(() {
              isJoined = !isJoined;
            });
            showSnackbar(context, Colors.green, "successfully joined the group");
            Future.delayed(const Duration(seconds: 2), (){
       
              nextScreen(context, ChatPage(
                groupId: groupId,
                 groupName: groupName,
                  userName: userName ,memberCount: widget.memberCount, adminName: '', wallpaperrUrl: 'https://media.architecturaldigest.com/photos/641c9af144453f6645298ec9/16:9/w_2240,c_limit/GettyImages-1379011538%20(1).jpg', imag: '',
                   members: '', descripition: '',));
            });
          }else{
            setState(() {
              isJoined =!isJoined;
              showSnackbar(context, Colors.red, "left the group $groupName");
            });
          }
          
        },
        child: isJoined
          ? Container(
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text(
                "Joined",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text("Join Now", style: TextStyle(color: Colors.white),)

              ),
            ),
    );
  }
}
