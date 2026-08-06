import 'package:dr_tragic_mfa/core/database/database_helper.dart';
import 'package:dr_tragic_mfa/data/models/subject.dart';

class SubjectRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Subject>> getAllSubjects() async {
    final db = await _dbHelper.database;
    final results = await db.query('subjects', orderBy: 'order_index ASC');
    return results.map((map) => Subject.fromMap(map)).toList();
  }

  Future<Subject?> getSubjectById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'subjects',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return Subject.fromMap(results.first);
  }
}
