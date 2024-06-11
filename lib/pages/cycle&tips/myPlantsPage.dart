import 'package:application5/controller/cont/cycleController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 // Ensure you import your CycleController here

class MyPlantsPage extends StatelessWidget {
  final CycleController controller = Get.put(CycleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Plants'),
        backgroundColor: const Color(0xffF1FCF3),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return controller.myplant.isEmpty
                  ? Center(child: Text('No plants found'))
                  : ListView.builder(
                      itemCount: controller.myplant.length,
                      itemBuilder: (context, index) {
                        var plant = controller.myplant[index];
                        var plantData = plant.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(plantData['name'] ?? 'No name'),
                          subtitle: Text(plantData['category'] ?? 'No category'),
                          trailing: Icon(
                            plantData['favorite'] ?? false ? Icons.favorite : Icons.favorite_border,
                            color: plantData['favorite'] ?? false ? Colors.red : null,
                          ),
                        );
                      },
                    );
            }),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: controller.getPlants(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No plants found'));
                }
                var plants = snapshot.data!;
                return ListView.builder(
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    var plant = plants[index];
                    return ListTile(
                      title: Text(plant['name'] ?? 'No name'),
                      subtitle: Text(plant['category'] ?? 'No category'),
                      trailing: Icon(
                        plant['favorite'] ?? false ? Icons.favorite : Icons.favorite_border,
                        color: plant['favorite'] ?? false ? Colors.red : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}