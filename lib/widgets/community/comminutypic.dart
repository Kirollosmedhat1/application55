import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityPic extends StatefulWidget {
  final Function(String) onImageSelected;

  const CommunityPic({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  _CommunityPicState createState() => _CommunityPicState();
}

class _CommunityPicState extends State<CommunityPic> {
  List<String> _communityImages = [];

  @override
  void initState() {
    super.initState();
    _fetchCommunityImages();
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
                widget.onImageSelected(_communityImages[i]);
                Get.back();
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showImagePickerBottomSheet,
      child: Container(
        height: 100,
        width: 100,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.image),
      ),
    );
  }
}
