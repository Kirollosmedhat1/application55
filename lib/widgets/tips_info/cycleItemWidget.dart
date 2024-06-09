import 'package:application5/pages/cycle&tips/cycle_Item_Info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CycleItemWidget extends StatelessWidget {
  final String image;
  final String name;
  final String cat;
  final String weather;
  final String afterCaring;
  final String conditions;
  final String harvesting;
  final List<String> steps;
  final String timing;
  final String watering;

  const CycleItemWidget({
    super.key,
    required this.image,
    required this.name,
    required this.cat,
    required this.afterCaring,
    required this.conditions,
    required this.harvesting,
    required this.steps,
    required this.timing,
    required this.watering, required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Stack(
        alignment: const Alignment(0.94, 0.88),
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            // padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xffCAEDCF))),
            height: 120,
            width: 400,
            child: Row(
              children: [
                Container(
                  height: 105,
                  width: 110,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage("images/1.png"), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                  
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            color: Color(0xff1A7431),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: "WorkSans"),
                      ),
                      SizedBox(height: 20,),
                       Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                           

        
                children: [
                  
                  Container(
                     width: 140,
              height: 40,
              decoration: BoxDecoration(
                  // color: Colors.black,
                  color: const Color(0xffF1FCF3),
                  borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      
                      child: TextButton(
                        onPressed: (){Get.to(CycleItem(
                                      afterCaring: afterCaring,
                                      conditions: conditions,
                                      harvesting: harvesting,
                                      weather:weather,
                                      image: image,
                                      watering: watering,
                                      steps: steps,
                                      timing: timing,
                                      name: name,
                                      cat: cat,
                                    ));},
                      child: Text("Add To Your Plants",
                        style: TextStyle(
                            color: Color(0xff1B602D),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: "WorkSans"),)  
                      ),
                    ),
                  ),

                        Container(
                          width: 116,
              height: 40,
              decoration: BoxDecoration(
                  // color: Colors.black,
                  color: const Color(0xffF1FCF3),
                  borderRadius: BorderRadius.circular(30)),
                          child: TextButton(
                                              onPressed: (){Get.to(CycleItem(
                                          afterCaring: afterCaring,
                                          conditions: conditions,
                                          harvesting: harvesting,
                                          weather:weather,
                                          image: image,
                                          watering: watering,
                                          steps: steps,
                                          timing: timing,
                                          name: name,
                                          cat: cat,
                                        ));},
                                            child: Text("Read more",
                                              style: TextStyle(
                          color: Color(0xff1B602D),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "WorkSans"),)  
                                            ),
                        ),

              
                ],
              ),
               ] ),

             ) ],
         )
                    
      )],
                  ),
                );
                
              
            
          

        
          
          
        
    
  }
}
