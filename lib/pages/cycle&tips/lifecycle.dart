import 'package:application5/pages/cycle&tips/agri_Tips.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Lifecycle extends StatefulWidget {
  const Lifecycle({super.key});

  @override
  State<Lifecycle> createState() => _LifecycleState();
}

class _LifecycleState extends State<Lifecycle>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            // Image.asset(
                            //   "images/tree.png",
                            //   height: 100,
                            //   width: 100,
                            // ),
                            const Text(
                              'You have no plants',
                              style: TextStyle(
                                fontSize: 26,
                                color: Color(0xff1A7431),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Add Your First Plant and \n carry out its daily \n Reminders.',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1A7431),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                   
                                Get.to(() => AgryCycle());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff1A7431),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                              ),
                              child: const Text(
                                'Add',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        );
  }}