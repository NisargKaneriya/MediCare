import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/medicine_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medicine_reminder.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  // Create tables
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        medicine_name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE medicine_reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicine_id INTEGER NOT NULL,
        reminder_time TEXT NOT NULL,
        is_taken INTEGER DEFAULT 0,
        reminder_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (medicine_id) REFERENCES medicines (id)
      )
    ''');
  }

  // Hash password
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Register user
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    final db = await database;

    // Check if username or email already exists
    final existingUser = await db.query(
      'users',
      where: 'username = ? OR email = ?',
      whereArgs: [username.trim(), email.trim()],
    );

    if (existingUser.isNotEmpty) {
      return {'success': false, 'message': 'Username or email already exists'};
    }

    String hashedPassword = _hashPassword(password);
    String currentTime = DateTime.now().toIso8601String();

    int userId = await db.insert('users', {
      'username': username.trim(),
      'email': email.trim(),
      'password': hashedPassword,
      'full_name': fullName.trim(),
      'created_at': currentTime,
      'updated_at': currentTime,
    });

    // Get the created user data
    final newUser = await getUserById(userId);

    return {
      'success': true,
      'message': 'Account created successfully! Welcome to MediCare.',
      'userId': userId,
      'user': newUser,
    };
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
    String? usernameOrEmail,
  }) async {
    final db = await database;

    // Find user by email or username
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? OR username = ?',
      whereArgs: [email, usernameOrEmail ?? email],
    );

    if (result.isEmpty) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    final user = result.first;

    // Check password
    String hashedPassword = _hashPassword(password);
    if (user['password'] != hashedPassword) {
      return {
        'success': false,
        'message': 'Invalid password',
      };
    }

    // Success → return user details
    return {
      'success': true,
      'message': 'Login successful',
      'user': user, // Direct map return karso
    };
  }


  // Get user by ID
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required int userId,
    String? fullName,
    String? email,
  }) async {
    final db = await database;
    Map<String, dynamic> updates = {
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (fullName != null) updates['full_name'] = fullName;
    if (email != null) updates['email'] = email;

    int result = await db.update(
      'users',
      updates,
      where: 'id = ?',
      whereArgs: [userId],
    );

    return result > 0;
  }

  // Medicine operations

  // Add medicine
  Future<int> addMedicine(MedicineModel medicine) async {
    final db = await database;
    return await db.insert('medicines', medicine.toMap());
  }

  // Get all medicines for a user
  Future<List<MedicineModel>> getMedicinesByUserId(int userId) async {
    final db = await database;
    final result = await db.query(
      'medicines',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return result.map((map) => MedicineModel.fromMap(map)).toList();
  }

  // Get medicine by ID
  Future<MedicineModel?> getMedicineById(int medicineId) async {
    final db = await database;
    final result = await db.query(
      'medicines',
      where: 'id = ?',
      whereArgs: [medicineId],
    );

    return result.isNotEmpty ? MedicineModel.fromMap(result.first) : null;
  }

  // Update medicine
  Future<bool> updateMedicine(MedicineModel medicine) async {
    final db = await database;
    final result = await db.update(
      'medicines',
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );

    return result > 0;
  }

  // Delete medicine
  Future<bool> deleteMedicine(int medicineId) async {
    final db = await database;
    final result = await db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [medicineId],
    );

    return result > 0;
  }

  // Get today's medicines for a user
  // Future<List<MedicineModel>> getTodaysMedicines(int userId) async {
  //   final db = await database;
  //   final today = DateTime.now();
  //   final todayString = today.toIso8601String().substring(0, 10);
  //
  //   final result = await db.query(
  //     'medicines',
  //     where: 'user_id = ? AND start_date <= ? AND (end_date IS NULL OR end_date >= ?)',
  //     whereArgs: [userId, todayString, todayString],
  //     orderBy: 'created_at DESC',
  //   );
  //
  //   return result.map((map) => MedicineModel.fromMap(map)).toList();
  // }
  Future<List<MedicineModel>> getTodaysMedicines(int userId) async {
    final db = await database;

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final result = await db.query(
      'medicines',
      where: 'user_id = ? AND start_date BETWEEN ? AND ?',
      whereArgs: [userId, startOfDay.toIso8601String(), endOfDay.toIso8601String()],
      orderBy: 'start_date ASC',
    );

    return result.map((map) => MedicineModel.fromMap(map)).toList();
  }


  Future<List<MedicineModel>> getAllMedicines(int userId) async {
    final db = await database;
    final res = await db.query('medicines', orderBy: 'start_date ASC');
    return res.map((e) => MedicineModel.fromMap(e)).toList();
  }

  Future<List<MedicineModel>> getMedicinesByDate(DateTime date) async {
    final db = await database;
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final res = await db.query(
      'medicines',
      where: 'start_date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'start_date ASC',
    );
    return res.map((e) => MedicineModel.fromMap(e)).toList();
  }


  // Close database
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
