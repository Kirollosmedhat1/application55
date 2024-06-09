import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsPage extends StatelessWidget {
  final File image;
  final String results;

  ResultsPage({required this.image, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(241, 252, 243, 1),
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromRGBO(241, 252, 252, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 20),
                  child: Text(
                    "NBTAH Scan",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "WorkSans",
                      color: Color(0xff1A7431),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        "    Plant Detection",
                        style: GoogleFonts.workSans(
                          textStyle: TextStyle(
                            color: Color.fromRGBO(26, 116, 49, 1),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Stack(
                        children:<Widget> [
                          Center(
                            child: Container(
                              width: 407,
                              height:350 ,
                            
                              child: Image.asset("images/greenframe.jpeg",  fit: BoxFit.fill),
                            ),
                          ),
                         
                           Padding(
                             padding: const EdgeInsets.all(20.0),
                             child: Center(
                                                     child: Image.file(
                                                       
                                                       image,
                                                       width: 368,
                                                       height: 308,
                                                       fit: BoxFit.fill,
                                                     ),
                                                   ),
                           ),
                          
                         

                      ]  ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          results,
                          style: GoogleFonts.workSans(
                            textStyle: const TextStyle(
                              color: Color.fromRGBO(26, 116, 49, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
