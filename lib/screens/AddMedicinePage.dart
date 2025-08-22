// import 'dart:ffi';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:medi_care3/models/user_model.dart';
// import 'package:medi_care3/screens/home_page.dart';
// import '../models/medicine_model.dart';
// import '../database/database_helper.dart';
// import '../controller/home_controller.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class AddMedicinePage extends StatefulWidget {
//   final int userId;
//   const AddMedicinePage({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   State<AddMedicinePage> createState() => _AddMedicinePageState();
// }
//
// class _AddMedicinePageState extends State<AddMedicinePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _dosageController = TextEditingController();
//   final _frequencyController = TextEditingController();
//   DateTime? _startDate;
//   DateTime? _endDate;
//   TimeOfDay? _timeOfDay;
//   final _notesController = TextEditingController();
//
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   final HomeController _homeController = Get.find<HomeController>();
//
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//     tz.initializeTimeZones();
//     _initNotifications();
//   }
//
//   Future<void> _initNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings settings =
//     InitializationSettings(android: androidSettings);
//
//     await flutterLocalNotificationsPlugin.initialize(settings);
//   }
//
//   Future<void> _scheduleNotification(String title, DateTime time) async {
//     final tz.TZDateTime tzDateTime = tz.TZDateTime.from(time, tz.local);
//     final scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Medicine Reminder',
//       'Time to take your medicine!',
//       tz.TZDateTime.from(scheduledDate, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails('your_channel_id', 'your_channel_name',
//             channelDescription: 'your_channel_description'),
//         iOS: DarwinNotificationDetails(),
//       ),
//       androidScheduleMode: AndroidScheduleMode.inexact,
//       matchDateTimeComponents: DateTimeComponents.time, // ✅ FIXED
//     );
//   }
//
//   // Future<void> _saveMedicine() async {
//   //   if (!_formKey.currentState!.validate() || _startDate == null || _timeOfDay == null) {
//   //     Get.snackbar("Error", "Please fill all required fields!");
//   //     return;
//   //   }
//   //
//   //   DateTime fullDateTime = DateTime(
//   //     _startDate!.year,
//   //     _startDate!.month,
//   //     _startDate!.day,
//   //     _timeOfDay!.hour,
//   //     _timeOfDay!.minute,
//   //   );
//   //
//   //   final newMedicine = MedicineModel(
//   //     userId: widget.userId,
//   //     medicineName: _nameController.text,
//   //     dosage: _dosageController.text,
//   //     frequency: _frequencyController.text,
//   //     startDate: fullDateTime,
//   //     endDate: _endDate,
//   //     notes: _notesController.text,
//   //     createdAt: DateTime.now(),
//   //   );
//   //
//   //   await _dbHelper.addMedicine(newMedicine);
//   //   await _scheduleNotification(newMedicine.medicineName, fullDateTime);
//   //   // Reload medicines
//   //   final homeController = Get.find<HomeController>();
//   //   await homeController.loadAllMedicines();    // Load today's medicines
//   //
//   //   _homeController.loadTodaysMedicines();
//   //
//   //   Get.back();
//   //   Get.snackbar("Success", "Medicine added & daily reminder set!");
//   //
//   // }
//   Future<void> _saveMedicine() async {
//     if (!_formKey.currentState!.validate() || _startDate == null || _timeOfDay == null) {
//       Get.snackbar("Error", "Please fill all required fields!");
//       return;
//     }
//
//     DateTime fullDateTime = DateTime(
//       _startDate!.year,
//       _startDate!.month,
//       _startDate!.day,
//       _timeOfDay!.hour,
//       _timeOfDay!.minute,
//     );
//
//     final newMedicine = MedicineModel(
//       userId: widget.userId,
//       medicineName: _nameController.text,
//       dosage: _dosageController.text,
//       frequency: _frequencyController.text,
//       startDate: fullDateTime,
//       endDate: _endDate,
//       notes: _notesController.text,
//       createdAt: DateTime.now(),
//     );
//
//     await _dbHelper.addMedicine(newMedicine);
//     await _scheduleNotification(newMedicine.medicineName, fullDateTime);
//
//     // Refresh controller
//     final homeController = Get.find<HomeController>();
//     if (homeController.currentUser.value == null) {
//       // Set currentUser if not set
//       homeController.currentUser.value = UserModel(id: widget.userId, fullName: '', username: '', email: '',);
//     }
//     await homeController.loadAllMedicines();
//     await homeController.loadTodaysMedicines();
//
//     Get.back(); // close add medicine page
//     Get.snackbar("Success", "Medicine added & daily reminder set!");
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Medicine")),
//       body: Container(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: "Medicine Name"),
//                 validator: (val) => val!.isEmpty ? "Enter medicine name" : null,
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _dosageController,
//                 decoration: const InputDecoration(labelText: "Dosage"),
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _frequencyController,
//                 decoration:
//                 const InputDecoration(labelText: "Frequency (e.g., 2 times/day)"),
//               ),
//               SizedBox(height: 10),
//               ListTile(
//                 title: Text(_startDate == null
//                     ? "Select Start Date"
//                     : DateFormat.yMMMd().format(_startDate!)),
//                 trailing: const Icon(Icons.calendar_today),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100),
//                   );
//                   if (picked != null) setState(() => _startDate = picked);
//                 },
//               ),
//               SizedBox(height: 10),
//               ListTile(
//                 title: Text(_endDate == null
//                     ? "Select End Date (Optional)"
//                     : DateFormat.yMMMd().format(_endDate!)),
//                 trailing: const Icon(Icons.calendar_today),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100),
//                   );
//                   if (picked != null) setState(() => _endDate = picked);
//                 },
//               ),
//               SizedBox(height: 10),
//               ListTile(
//                 title: Text(_timeOfDay == null
//                     ? "Select Reminder Time"
//                     : _timeOfDay!.format(context)),
//                 trailing: const Icon(Icons.access_time),
//                 onTap: () async {
//                   TimeOfDay? picked = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (picked != null) setState(() => _timeOfDay = picked);
//                 },
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _notesController,
//                 decoration: const InputDecoration(labelText: "Notes"),
//               ),
//               SizedBox(height: 10),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveMedicine,
//                 child: const Text("Save & Set Reminder"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//-----------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// import '../controller/home_controller.dart';
// import '../database/database_helper.dart';
// import '../models/medicine_model.dart';
// import '../models/user_model.dart';
//
// class AddMedicinePage extends StatefulWidget {
//   final int userId;
//   const AddMedicinePage({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   State<AddMedicinePage> createState() => _AddMedicinePageState();
// }
//
// class _AddMedicinePageState extends State<AddMedicinePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _dosageController = TextEditingController();
//   final _frequencyController = TextEditingController();
//   final _notesController = TextEditingController();
//
//   DateTime? _startDate;
//   DateTime? _endDate;
//   TimeOfDay? _timeOfDay;
//
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   final HomeController _homeController = Get.find<HomeController>();
//   late UserModel _currentUser;
//
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//     tz.initializeTimeZones();
//     _initNotifications();
//
//     // Initialize temporary user object if not already set
//     if (_homeController.currentUser.value == null) {
//       _homeController.currentUser.value = UserModel(
//         id: widget.userId,
//         username: '',
//         email: '',
//         fullName: '',
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );
//     }
//
//     _currentUser = _homeController.currentUser.value!;
//   }
//
//   Future<void> _initNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings settings =
//     InitializationSettings(android: androidSettings);
//
//     await flutterLocalNotificationsPlugin.initialize(settings);
//   }
//
//   Future<void> _scheduleNotification(String title, DateTime dateTime) async {
//     final tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, tz.local);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Medicine Reminder',
//       'Time to take $title',
//       tzDateTime,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'medicine_channel',
//           'Medicine Reminders',
//           channelDescription: 'Channel for medicine notifications',
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//       androidScheduleMode: AndroidScheduleMode.inexact,
//       matchDateTimeComponents: DateTimeComponents.time, // daily at time
//     );
//   }
//
//   Future<void> _saveMedicine() async {
//     if (!_formKey.currentState!.validate() ||
//         _startDate == null ||
//         _timeOfDay == null) {
//       Get.snackbar("Error", "Please fill all required fields!");
//       return;
//     }
//
//     final fullDateTime = DateTime(
//       _startDate!.year,
//       _startDate!.month,
//       _startDate!.day,
//       _timeOfDay!.hour,
//       _timeOfDay!.minute,
//     );
//
//     final newMedicine = MedicineModel(
//       userId: _currentUser.id,
//       medicineName: _nameController.text,
//       dosage: _dosageController.text,
//       frequency: _frequencyController.text,
//       startDate: fullDateTime,
//       endDate: _endDate,
//       notes: _notesController.text,
//       createdAt: DateTime.now(),
//     );
//
//     await _dbHelper.addMedicine(newMedicine);
//     await _scheduleNotification(newMedicine.medicineName, fullDateTime);
//
//     // Reload medicines in HomeController
//     await _homeController.loadAllMedicines();
//     await _homeController.loadTodaysMedicines();
//
//     Get.back();
//     Get.snackbar("Success", "Medicine added & daily reminder set!");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Medicine")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: "Medicine Name"),
//                 validator: (val) =>
//                 val!.isEmpty ? "Enter medicine name" : null,
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _dosageController,
//                 decoration: const InputDecoration(labelText: "Dosage"),
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _frequencyController,
//                 decoration: const InputDecoration(
//                     labelText: "Frequency (e.g., 2 times/day)"),
//               ),
//               SizedBox(height: 10),
//               ListTile(
//                 title: Text(_startDate == null
//                     ? "Select Start Date"
//                     : DateFormat.yMMMd().format(_startDate!)),
//                 trailing: const Icon(Icons.calendar_today),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2100));
//                   if (picked != null) setState(() => _startDate = picked);
//                 },
//               ),
//               SizedBox(height: 10),
//               ListTile(
//                 title: Text(_endDate == null
//                     ? "Select End Date (Optional)"
//                     : DateFormat.yMMMd().format(_endDate!)),
//                 trailing: const Icon(Icons.calendar_today),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2100));
//                   if (picked != null) setState(() => _endDate = picked);
//                 },
//               ),
//               SizedBox(height: 10),
//               ListTile(
//                 title: Text(_timeOfDay == null
//                     ? "Select Reminder Time"
//                     : _timeOfDay!.format(context)),
//                 trailing: const Icon(Icons.access_time),
//                 onTap: () async {
//                   TimeOfDay? picked = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (picked != null) setState(() => _timeOfDay = picked);
//                 },
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _notesController,
//                 decoration: const InputDecoration(labelText: "Notes"),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveMedicine,
//                 child: const Text("Save & Set Reminder"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//-------------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../controller/home_controller.dart';
import '../database/database_helper.dart';
import '../models/medicine_model.dart';
import '../models/user_model.dart';

class AddMedicinePage extends StatefulWidget {
  final int userId;
  final MedicineModel? existingMedicine; // optional for editing

  const AddMedicinePage({Key? key, required this.userId, this.existingMedicine})
      : super(key: key);

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _timeOfDay;

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final HomeController _homeController = Get.find<HomeController>();
  late UserModel _currentUser;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initNotifications();

    if (_homeController.currentUser.value == null) {
      _homeController.currentUser.value = UserModel(
        id: widget.userId,
        username: '',
        email: '',
        fullName: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    _currentUser = _homeController.currentUser.value!;

    // Prefill fields if editing
    if (widget.existingMedicine != null) {
      final med = widget.existingMedicine!;
      _nameController.text = med.medicineName;
      _dosageController.text = med.dosage;
      _frequencyController.text = med.frequency;
      _notesController.text = med.notes ?? '';
      _startDate = med.startDate;
      _endDate = med.endDate;
      _timeOfDay = TimeOfDay(hour: med.startDate.hour, minute: med.startDate.minute);
    }
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> _scheduleNotification(String title, DateTime dateTime) async {
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Medicine Reminder',
      'Time to take $title',
      tzDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Channel for medicine notifications',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexact,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Future<void> _saveMedicine() async {
  //   if (!_formKey.currentState!.validate() || _startDate == null || _timeOfDay == null) {
  //     Get.snackbar("Error", "Please fill all required fields!");
  //     return;
  //   }
  //
  //   final fullDateTime = DateTime(
  //     _startDate!.year,
  //     _startDate!.month,
  //     _startDate!.day,
  //     _timeOfDay!.hour,
  //     _timeOfDay!.minute,
  //   );
  //
  //   final medicine = MedicineModel(
  //     id: widget.existingMedicine?.id,
  //     userId: _currentUser.id,
  //     medicineName: _nameController.text,
  //     dosage: _dosageController.text,
  //     frequency: _frequencyController.text,
  //     startDate: fullDateTime,
  //     endDate: _endDate,
  //     notes: _notesController.text,
  //     createdAt: widget.existingMedicine?.createdAt ?? DateTime.now(),
  //   );
  //
  //   if (widget.existingMedicine != null) {
  //     await _dbHelper.updateMedicine(medicine);
  //     Get.snackbar("Success", "Medicine updated!");
  //   } else {
  //     await _dbHelper.addMedicine(medicine);
  //     await _scheduleNotification(medicine.medicineName, fullDateTime);
  //     Get.snackbar("Success", "Medicine added & daily reminder set!");
  //   }
  //
  //   await _homeController.loadAllMedicines();
  //   await _homeController.loadTodaysMedicines();
  //   Get.back();
  // }
  // Future<void> _saveMedicine() async {
  //   if (!_formKey.currentState!.validate() || _startDate == null || _timeOfDay == null) {
  //     Get.snackbar("Error", "Please fill all required fields!");
  //     return;
  //   }
  //
  //   final fullDateTime = DateTime(
  //     _startDate!.year,
  //     _startDate!.month,
  //     _startDate!.day,
  //     _timeOfDay!.hour,
  //     _timeOfDay!.minute,
  //   );
  //
  //   final dbHelper = DatabaseHelper();
  //
  //   if (widget.existingMedicine != null) {
  //     // Update existing medicine
  //     final updatedMedicine = widget.existingMedicine!.copyWith(
  //       medicineName: _nameController.text,
  //       dosage: _dosageController.text,
  //       frequency: _frequencyController.text,
  //       startDate: fullDateTime,
  //       endDate: _endDate,
  //       notes: _notesController.text,
  //     );
  //     await dbHelper.updateMedicine(updatedMedicine);
  //     Get.snackbar("Success", "Medicine updated successfully!");
  //   } else {
  //     // Add new medicine
  //     final newMedicine = MedicineModel(
  //       userId: _currentUser.id,
  //       medicineName: _nameController.text,
  //       dosage: _dosageController.text,
  //       frequency: _frequencyController.text,
  //       startDate: fullDateTime,
  //       endDate: _endDate,
  //       notes: _notesController.text,
  //       createdAt: DateTime.now(),
  //     );
  //     await dbHelper.addMedicine(newMedicine);
  //     Get.snackbar("Success", "Medicine added successfully!");
  //   }
  //
  //   // Refresh controller
  //   await Get.find<HomeController>().loadAllMedicines();
  //   Get.back();
  // }
  Future<void> _saveMedicine() async {
    if (!_formKey.currentState!.validate() || _startDate == null || _timeOfDay == null) {
      Get.snackbar("Error", "Please fill all required fields!");
      return;
    }

    final fullDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _timeOfDay!.hour,
      _timeOfDay!.minute,
    );

    final dbHelper = DatabaseHelper();
    final homeController = Get.find<HomeController>();

    try {
      if (widget.existingMedicine != null) {
        // Update existing medicine
        final updatedMedicine = widget.existingMedicine!.copyWith(
          medicineName: _nameController.text,
          dosage: _dosageController.text,
          frequency: _frequencyController.text,
          startDate: fullDateTime,
          endDate: _endDate,
          notes: _notesController.text,
        );

        await dbHelper.updateMedicine(updatedMedicine);
      } else {
        // Add new medicine
        final newMedicine = MedicineModel(
          userId: _currentUser.id,
          medicineName: _nameController.text,
          dosage: _dosageController.text,
          frequency: _frequencyController.text,
          startDate: fullDateTime,
          endDate: _endDate,
          notes: _notesController.text,
          createdAt: DateTime.now(),
        );

        await dbHelper.addMedicine(newMedicine);
      }

      // Refresh medicine list in controller
      await homeController.loadAllMedicines();
      await homeController.loadTodaysMedicines();

      // Go back first
      Get.back();

      // Show success snackbar after returning
      Get.snackbar(
        "Success",
        widget.existingMedicine != null
            ? "Medicine updated successfully!"
            : "Medicine added successfully!",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Handle error
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 3));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.existingMedicine != null ? "Edit Medicine" : "Add Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Medicine Name"),
                validator: (val) => val!.isEmpty ? "Enter medicine name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(labelText: "Dosage"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _frequencyController,
                decoration:
                const InputDecoration(labelText: "Frequency (e.g., 2 times/day)"),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_startDate == null
                    ? "Select Start Date"
                    : DateFormat.yMMMd().format(_startDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_endDate == null
                    ? "Select End Date (Optional)"
                    : DateFormat.yMMMd().format(_endDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (picked != null) setState(() => _endDate = picked);
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_timeOfDay == null
                    ? "Select Reminder Time"
                    : _timeOfDay!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _timeOfDay ?? TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _timeOfDay = picked);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: "Notes"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMedicine,
                child: Text(widget.existingMedicine != null ? "Update" : "Save & Set Reminder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

