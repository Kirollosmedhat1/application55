import 'package:application5/controller/cont/cycleController.dart';
import 'package:application5/pages/cycle&tips/cycle_Item_Info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CycleItemWidget extends StatefulWidget {
  final String image;
  final String image1;
  final bool favorite;
  final String name;
  final String cat;
  final String weather;
  final String afterCaring;
  final String harvesting;
  final List<String> steps;
  final String timing;
  final String watering;

  const CycleItemWidget({
    super.key,
    required this.image,
    required this.image1,
    required this.name,
    required this.cat,
    required this.afterCaring,
    required this.harvesting,
    required this.steps,
    required this.timing,
    required this.watering,
    required this.weather, required this.favorite,
  });

  @override
  State<CycleItemWidget> createState() => _CycleItemWidgetState();
}

class _CycleItemWidgetState extends State<CycleItemWidget> {
  late bool _isFavorite; // Declare _isFavorite without initialization
  final CycleController _controller = Get.find(); // Get CycleController instance

  @override
  void initState() {
    super.initState();
    // Initialize the initial favorite state
    _isFavorite = widget.favorite; // Initialize _isFavorite with the initial favorite state from the widget
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xffCAEDCF))),
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 105,
              width: 110,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.image), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " ${widget.name}",
                        style: const TextStyle(
                            color: Color(0xff1A7431),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "WorkSans"),
                      ),
                      Container(
                        width: 130,
                        height: 40,
                        decoration: BoxDecoration(
                            // color: Colors.black,
                            color: const Color(0xffF1FCF3),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextButton(
                            onPressed: () {
                              Get.to(CycleItem(
                                afterCaring: widget.afterCaring,
                                harvesting: widget.harvesting,
                                weather: widget.weather,
                                image: widget.image,
                                image1: widget.image1,
                                watering: widget.watering,
                                steps: widget.steps,
                                timing: widget.timing,
                                name: widget.name,
                                cat: widget.cat,
                              ));
                            },
                            child: Text(
                              "Add To Your Plants",
                              style: TextStyle(
                                  color: Color(0xff1B602D),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "WorkSans"),
                            )),
                      ),
                    ]),
                    SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
              onTap: () async {
                setState(() {
                  _isFavorite = !_isFavorite; // Invert the favorite state
                });
                await _controller.togglePlantFavorite(widget.name, _isFavorite);
                // Other navigation or actions
              },
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: _isFavorite
                            ? const AssetImage("images/Heart.png")
                            : const AssetImage("images/HeartSelecteed.png"))),
              ),

            ),
                    Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                          // color: Colors.black,
                          color: const Color(0xffF1FCF3),
                          borderRadius: BorderRadius.circular(30)),
                      child: TextButton(
                          onPressed: () {
                            Get.to(CycleItem(
                              afterCaring: widget.afterCaring,
                              harvesting: widget.harvesting,
                              weather: widget.weather,
                              image: widget.image,
                              image1: widget.image1,
                              watering: widget.watering,
                              steps: widget.steps,
                              timing: widget.timing,
                              name: widget.name,
                              cat: widget.cat,
                            ));
                          },
                          child: Text(
                            "Read more",
                            style: TextStyle(
                                color: Color(0xff1B602D),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                fontFamily: "WorkSans"),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
