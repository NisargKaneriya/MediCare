// // medicines_page.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/home_controller.dart';
// import '../models/medicine_model.dart';
//
// class MedicinesPage extends StatefulWidget {
//   const MedicinesPage({super.key});
//
//   @override
//   State<MedicinesPage> createState() => _MedicinesPageState();
// }
//
// class _MedicinesPageState extends State<MedicinesPage> {
//   final HomeController controller = Get.find<HomeController>();
//
//   @override
//   void initState() {
//     super.initState();
//     if (controller.currentUser.value != null) {
//       controller.loadAllMedicines(); // load medicines for current user
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.allMedicines.isEmpty) {
//         return const Center(child: Text("No medicines added yet"));
//       }
//
//       return ListView.builder(
//         itemCount: controller.allMedicines.length,
//         itemBuilder: (context, index) {
//           final med = controller.allMedicines[index];
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: ListTile(
//               title: Text(med.medicineName),
//               subtitle: Text(
//                 "${med.dosage} | ${med.frequency}\nStart: ${med.startDate}\nEnd: ${med.endDate ?? 'N/A'}",
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }
// medicines_page.dart
// medicines_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_care3/screens/AddMedicinePage.dart';
import '../controller/home_controller.dart';
import '../models/medicine_model.dart';
import '../database/database_helper.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  final HomeController controller = Get.find<HomeController>();
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (controller.currentUser.value != null) {
      controller.loadAllMedicines(); // load medicines for current user
    }
  }
  //
  // void _deleteMedicine(MedicineModel med) async {
  //   bool success = await dbHelper.deleteMedicine(med.id!);
  //   if (success) {
  //     Get.snackbar("Deleted", "${med.medicineName} deleted successfully");
  //     controller.loadAllMedicines(); // refresh list
  //   } else {
  //     Get.snackbar("Error", "Failed to delete ${med.medicineName}");
  //   }
  // }
  void _deleteMedicine(MedicineModel med) async {
    bool success = await dbHelper.deleteMedicine(med.id!);
    if (success) {
      await controller.loadAllMedicines(); // refresh the main list
      await controller.loadTodaysMedicines(); // refresh today's list
      Get.snackbar("Success", "Medicine deleted successfully!");
    }
  }

  void _editMedicine(MedicineModel med) async {
    // Navigate to your Add/Edit medicine page with existing data
    // Example using Get.to():
    Get.to(() => AddMedicinePage(
      userId: controller.currentUser.value!.id, // pass the userId here
      existingMedicine: med,
    ))?.then((_) {
      controller.loadAllMedicines(); // refresh list after editing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allMedicines.isEmpty) {
        return const Center(child: Text("No medicines added yet"));
      }

      return ListView.builder(
        itemCount: controller.allMedicines.length,
        itemBuilder: (context, index) {
          final med = controller.allMedicines[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(med.medicineName),
              subtitle: Text(
                "${med.dosage} | ${med.frequency}\nStart: ${med.startDate}\nEnd: ${med.endDate ?? 'N/A'}",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editMedicine(med),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteMedicine(med),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
