

import 'package:application5/pages/community/communityhome.dart';
import 'package:application5/pages/login.dart';
import 'package:application5/servicre/auth_service.dart';
import 'package:application5/widgets/community/screen&snack.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
   ProfilePage({Key?key, required this.email, required this.userName}):super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService =AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: const Color.fromRGBO(241, 252, 243, 1),
        toolbarHeight: 70,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.menu,
        //     color: Color.fromRGBO(24, 79, 39, 1),
        //     size: 34,
        //     shadows: [Shadow(color: Color.fromRGBO(217, 217, 217, 1))],
        //   ),
        // ),
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
              onPressed: () {},
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

            Text(
              widget.userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),),

            const SizedBox(height: 30,),
            const Divider(height: 2,),

            ListTile(
              onTap: (){
                nextScreen(context,  CommunityHome(members: '',));
              },
              selectedColor: Colors.green,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",
              style: TextStyle(color: Colors.black),),
            ),

             ListTile(
              onTap: (){
              },
             selected: true,
              selectedColor: Colors.green,

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
                        (route) =>   false);                 
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical:170 ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
              
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("user name:", style:TextStyle(fontSize: 17),),
                  Text(widget.userName, style:const TextStyle(fontSize: 17),),
              ],
            ),
            const Divider(height: 20,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email:", style:TextStyle(fontSize: 17),),
                  Text(widget.email, style:const TextStyle(fontSize: 17),),
              ],
            ),
          ],
        ),
      )
    );
  }
}