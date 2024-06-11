import 'package:application5/controller/cont/cycleController.dart';
import 'package:application5/pages/homepage.dart';
import 'package:application5/pages/account/login.dart';
import 'package:application5/widgets/tips_info/cycleItemWidget.dart';
import 'package:application5/widgets/heading_with_back.dart';
import 'package:application5/widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  int _selectedIndex = 0;
  CategoryPage({required this.category});

  final CycleController controller = Get.find<CycleController>();
  void signOutFromApp() async {
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      Get.off(const LoginPage());
      // Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> categoryList = [];

    if (category == "Vegatables") {
      categoryList = controller.informationList
          .where((product) => product["cat"] == "Vegatables")
          .toList();
    } else if (category == "Legumes") {
      categoryList = controller.informationList
          .where((product) => product["cat"] == "Legumes")
          .toList();
    } else if (category == "Herbs") {
      categoryList = controller.informationList
          .where((product) => product["cat"] == "Herbs")
          .toList();
    } else if (category == "Flowers") {
      categoryList = controller.informationList
          .where((product) => product["cat"] == "Flowers")
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Mydrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xffF1FCF3),
      ),
      body: Container(
        color: const Color(0xffF1FCF3),
        child: Column(
          children: [
            HeadingWithBack(title: category, fontFamily: "WorkSans"),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(top: 40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categoryList.length,
                      itemBuilder: (constex, i) {
                        return Stack(
                          alignment: const Alignment(0.94, 0.88),
                          children: [
                            CycleItemWidget(
                              
                              image: "${categoryList[i]["img0"]}",
                              image1: "${categoryList[i]["img1"]}",
                              name: "${categoryList[i]["name"]}",
                              cat: "${categoryList[i]["cat"]}",
                              afterCaring: "${categoryList[i]["After Caring"]}",
                              harvesting: "${categoryList[i]["Harvesting"]}",
                              steps: (categoryList[i]["Steps"] as List<dynamic>)
                                  .map((step) => step.toString())
                                  .toList(),
                              timing: "${categoryList[i]["Timing"]}",
                              watering: "${categoryList[i]["Watering"]}",
                               weather: "${categoryList[i]["Weather"]}",
                               favorite: (controller.informationList[i]
                                    ["favorite"] as bool),
                            ),
                          ],
                        );
                      })),
            ),
          ],
        ),
      ),
    );
  }
}
