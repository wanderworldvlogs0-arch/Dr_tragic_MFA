import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dr_tragic_mfa/core/database/migrations.dart';
import 'package:dr_tragic_mfa/core/database/seed_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dr_tragic_mfa.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create all tables
    for (String query in Migrations.createTables) {
      await db.execute(query);
    }
    
    // Insert seed data
    await SeedData.insertSeedData(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    for (int i = oldVersion + 1; i <= newVersion; i++) {
      if (Migrations.upgrades.containsKey(i)) {
        await db.execute(Migrations.upgrades[i]!);
      }
    }
  }

  static Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
