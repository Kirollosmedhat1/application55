import 'package:application5/Helper/helper_function.dart';
import 'package:application5/pages/community/createcommunity.dart';
import 'package:application5/pages/community/profile.dart';
import 'package:application5/pages/community/searchcommunity.dart';
import 'package:application5/pages/login.dart';
import 'package:application5/servicre/auth_service.dart';
import 'package:application5/servicre/database_service.dart';
import 'package:application5/widgets/community/communityedit.dart';
import 'package:application5/widgets/community/group_tile.dart';
import 'package:application5/widgets/community/screen&snack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityHome extends StatefulWidget {
   final String members;
  const CommunityHome({super.key, required this.members});

  @override
  State<CommunityHome> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHome> {
    DatabaseService _databaseService = DatabaseService();
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  String userName = "";
  String email="";
  AuthService authService =AuthService();
  Stream? groups;
  bool _isLoading =false;
  String groupName = "";
 
    Stream<List<Map<String, dynamic>>>? notJoinedGroups;


@override
void initState(){
  super.initState();
  gettingUserData();
   notJoinedGroups = DatabaseService().getGroupsNotJoined(FirebaseAuth.instance.currentUser!.uid);
}

 
//string manipulation
String getId(String res){
  return res.substring(0, res.indexOf("_"));
}

String getName(String res){
  return res.substring(res.indexOf("_")+1);
}


gettingUserData()async{
await HelperFunction.getUserEmailFromSF().then((value) {
  setState(() {
    email =value!;
  });
});

// await HelperFunction.getUserNameFromSF().then((value) {
//   setState(() {
//     userName =value!;
//   });
// });


// getting list of snapshots in our stream
await DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid)
.getUserGroups().then((snapshot){
  setState(() {
    groups =snapshot;
  });
});
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: const Color.fromRGBO(241, 252, 243, 1),
        toolbarHeight: 70,
    
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            width: 46,
            height: 49,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(241, 252, 243, 1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 146, 158, 147).withOpacity(.4),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: IconButton(
              onPressed: () {
                nextScreenReplace(context, const SearchPage(memberCount: 2));
              },
              icon: const Icon(
                Icons.search,
                size: 35,
                color: Color.fromRGBO(24, 79, 39, 1),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[

           
            Icon(Icons.account_circle,
            size: 150,
            color: Colors.grey[700],),
            const SizedBox(height:15 ,),

            Text(userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),),

            const SizedBox(height: 30,),
            const Divider(height: 2,),

            ListTile(
              onTap: (){},
              selectedColor: Colors.green,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",
              style: TextStyle(color: Colors.black),),
            ),

             ListTile(
              onTap: (){
          nextScreenReplace(context, ProfilePage(email: email, userName: userName));
              },
              selectedColor: Colors.green,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Profile",
              style: TextStyle(color: Colors.black),),
            ),

             ListTile(
              onTap: ()async{
                showDialog(
                  barrierDismissible: false,
                  context: context,
                 builder: (context){
                  return AlertDialog(
                    title:const Text("Logout") ,
                    content: const Text("are you sure you want to LogOut?"),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, 
                      icon: const Icon(Icons.cancel,
                      color: Colors.red,)),

                      IconButton(onPressed: ()async{
                        await authService.signOut();
                        Navigator.of(context).pushAndRemoveUntil (MaterialPageRoute(builder: (context) => const LoginPage()), 
                        (route) =>   true);                 
                      }, 
                      icon: const Icon(Icons.done,
                      color: Colors.green,))
                    ],
                  );
                 }) ;
              
              },
              selectedColor: Colors.green,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text("LogOut",
              style: TextStyle(color: Colors.black),),
            ),
            
          ],
        ),
      ),

      body:
      Column(

        children: [
          Container(
          
            
              // color: Color(0xfff1fcf3),
               color: const Color.fromRGBO(241, 252, 252, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Column(
                 
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "Communities",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "WorkSans",
                          color: Color(0xff1A7431),
                          fontWeight: FontWeight.w500,
                          shadows: <Shadow>[
                            Shadow(
                          
                            )

                          ]
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 5,),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft:  Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   
                    
                      const SizedBox(height: 17,),
                      Container(
                        padding: const EdgeInsets.only(left: 40),
                        child: const Text(
                          "Join Now Your Community",
                          style: TextStyle(
                            color: Color(0xff4f795b),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: "WorkSans",
                            shadows: [
                              Shadow(
                                blurRadius: 14,
                                color: Colors.grey,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                        ),
                      ),
          
            notJoinedGroupList(),
              const SizedBox(height: 36,),
            Row(
                        
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                         
                          const Text("Create Community",
                            style: TextStyle(
                              fontSize:22,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1A7431),
                              shadows: [
                                Shadow(
                                  blurRadius: 14,
                                       color:Colors.grey,
                                              offset: Offset(0, 6),

                                )
                              ]
                              
                            
                            ),),
                            
                            
                          
                          Container(
                            width: 80,
                            height: 31,
                            child: MaterialButton(onPressed: (){
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CreateCommunity(
  groupId: '',
  groupIconUrl:"https://media.architecturaldigest.com/photos/641c9af144453f6645298ec9/16:9/w_2240,c_limit/GettyImages-1379011538%20(1).jpg",
  onImageSelected: (String imageUrl) {
    // This is a dummy function, you can replace it with your actual logic
    print('Selected image URL: $imageUrl');
  }, wallpaperrUrl: "https://media.architecturaldigest.com/photos/641c9af144453f6645298ec9/16:9/w_2240,c_limit/GettyImages-1379011538%20(1).jpg", onWallpaperSelected: (String wallUrl ) {  }, 
  members: widget.members,

)));

                            },
                            color: Colors.green,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: const Text("New",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                                 fontFamily: "WorkSans",
                            ),),
                            ),
                          )
                        ],
                      ),
                  
                
                      const SizedBox(
                        height: 27,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 40),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Communities",
                              style: TextStyle(
                                color: Color(0xff1A7431),
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                fontFamily: "WorkSans",
                                shadows: [
                                  Shadow(
                                    blurRadius: 14,
                                    color: Colors.grey,
                                    offset: Offset(0, 6),
                                  ),

                                ],
                              ),
                            ),
                             SizedBox(
                        height: 10,
                      ),
                    
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
        
          
          Expanded(child:
            groupList(),
          ),
        ],
      )
      
      );
    
  }
  popUpDilog(BuildContext context){

    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context){
        return StatefulBuilder(builder: ((context, setState){
          
 
          return AlertDialog(
            title: const Text("Create A group", textAlign:TextAlign.left,),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true ? const Center(
                  child: CircularProgressIndicator(color: Colors.green,),
                ): TextField(
                  onChanged: (val) {
                    setState(() {
                      groupName =val;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder:OutlineInputBorder( 
                    borderSide: const BorderSide(
                      color: Colors.green,),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red
                      ),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.green
                      ),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    
                  ),
                )
              ],
            ),
            actions: [
              ElevatedButton(onPressed: (){
                Navigator.of(context).pop();
              }, 
          
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink),
                    child: const Text("Cancel"),
                
              ),
          
          
            ],
          );
       }) );
      });
  }
  groupList() {
  return StreamBuilder(
    stream: groups,
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data['groups'] != null) {
          if (snapshot.data['groups'].length != 0) {
            return ListView.builder(
              itemCount: snapshot.data['groups'].length,
              itemBuilder: (context, index) {
                int reverseIndex = snapshot.data['groups'].length - index - 1;
                var groupData = snapshot.data['groups'][reverseIndex];
                return FutureBuilder<int>(
                  future: DatabaseService().getMemberCount(getId(groupData)),
                  builder: (context, memberCountSnapshot) {
                    if (memberCountSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (memberCountSnapshot.hasError) {
                      return Text('Error: ${memberCountSnapshot.error}');
                    } else {
                      int memberCount = memberCountSnapshot.data!;
                      String groupIconUrl = groupData is Map ? groupData['groupIconUrl'] : '';
                      return CoummuntiyEdit(
                        groupName: getName(groupData),
                        userName: snapshot.data['userName'],
                        groupId: getId(groupData),
                        groupIconUrl: groupIconUrl,
                        memberCount: memberCount,
                      );
                    }
                  },
                );
              },
            );
          } else {
            return noGroupsWidget();
          }
        } else {
          return noGroupsWidget();
        }
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        );
      }
    },
  );
}

  noGroupsWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDilog(context);
            },
         child:  Icon(Icons.add_circle, color: Colors.grey[700],size: 75,),
          ),

          const SizedBox(height: 20,),
          const Text("you'venot joinded any groups yet", textAlign: TextAlign.center,)
        ],
      ),
    );
  }
 Widget notJoinedGroupList() {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: notJoinedGroups,
    builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.green),
        );
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return SizedBox(
          height: 200,
          width: 400,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> groupData = snapshot.data![index];
              return FutureBuilder<int>(
                future: DatabaseService().getMemberCount(groupData['groupId']), // Accessing through an instance of DatabaseService
                builder: (context, memberCountSnapshot) {
                  if (memberCountSnapshot.connectionState == ConnectionState.waiting) {
                    // Display a loading indicator while fetching member count
                    return const CircularProgressIndicator();
                  } else if (memberCountSnapshot.hasError) {
                    // Handle error
                    return Text('Error: ${memberCountSnapshot.error}');
                  } else {
                    // Member count is fetched successfully
                    int memberCount = memberCountSnapshot.data!;
                  String groupIconUrl = groupData['groupIconUrl'] ?? '';// Fetch group icon URL from groupData
                    return GroupTile(
                      groupName: groupData['groupName'],
                      userName: '',
                      groupId: groupData['groupId'],
                      memberCount: memberCount, 
                      groupIconUrl: groupIconUrl, 
                      uid: uid,
                       descripition: groupData['descripition'],
                    );
                  }
                },
              );
            },
          ),
        );
      }
    },
  );
}
 Future<void> _getMemberCount(String groupId) async {
    try {
      int memberCount = await _databaseService.getMemberCount(groupId);
      print('Member count: $memberCount');
    } catch (e) {
      print('Failed to get member count: $e');
      // Handle error (e.g., show error message to user)
    }
  }
}

