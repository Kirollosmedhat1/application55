import 'dart:io';

import 'package:application5/pages/modelv/resultpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ModelHome extends StatefulWidget {
  const ModelHome({super.key});

  @override
  State<ModelHome> createState() => _ModelHomeState();
}

class _ModelHomeState extends State<ModelHome> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var v = "";

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt", // If you have a labels file
      );
      print("Model loaded: $res");
    } on PlatformException catch (e) {
      print("Failed to load model: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectImage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> detectImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _recognitions = recognitions;
      v = recognitions.toString();
      // Navigate to the results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(image: file!, results: v),
        ),
      );
    });

    print(_recognitions);
  }

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
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "NPTAH Scan",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "WorkSans",
                          color: Color(0xff1A7431),
                          fontWeight: FontWeight.w500,
                          shadows: <Shadow>[
                            Shadow(
                                // Add shadow if necessary
                                )
                          ],
                        ),
                      ),
                    ),
                  ],
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
                        topRight: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        "    Start Scanning to Detect Your Plant Disease",
                        style: GoogleFonts.workSans(
                          textStyle: TextStyle(
                            color: Color.fromRGBO(26, 116, 49, 1),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 130),
                      Center(
                        child: Image.asset(
                          "images/tree.jpeg",
                          width: 229,
                          height: 235,
                        ),
                      ),
                      SizedBox(height: 70),
                      Column(
                        children: <Widget>[
                          if (_image != null)
                            Image.file(
                              File(_image!.path),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                          else
                            Center(
                              child: Container(
                                child: MaterialButton(
                                  onPressed: () => _pickImage(ImageSource.camera), // Call _pickImage with camera source
                                  height: 45,
                                  minWidth: 274,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: const Color(0xff1b602d),
                                  child: Text(
                                    "Scan your plant",
                                    style: GoogleFonts.workSans(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          child: MaterialButton(
                            onPressed: () => _pickImage(ImageSource.gallery), // Call _pickImage with gallery source
                            height: 45,
                            minWidth: 274,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: const Color(0xff1b602d),
                            child: Text(
                              "Insert From Camera Roll",
                              style: GoogleFonts.workSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(v),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
