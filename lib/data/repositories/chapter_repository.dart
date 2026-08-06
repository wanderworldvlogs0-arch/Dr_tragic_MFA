import 'package:dr_tragic_mfa/core/database/database_helper.dart';
import 'package:dr_tragic_mfa/data/models/chapter.dart';

class ChapterRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Chapter>> getChaptersBySubject(int subjectId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'chapters',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'order_index ASC',
    );
    return results.map((map) => Chapter.fromMap(map)).toList();
  }
}
