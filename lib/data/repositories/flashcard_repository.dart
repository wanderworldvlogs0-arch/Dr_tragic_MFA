import 'package:sqflite/sqflite.dart';
import 'package:dr_tragic_mfa/core/database/database_helper.dart';
import 'package:dr_tragic_mfa/data/models/flashcard.dart';

class FlashcardRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Flashcard>> getFlashcardsByChapter(int chapterId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'flashcards',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
    );
    return results.map((map) => Flashcard.fromMap(map)).toList();
  }

  Future<void> markKnown(int flashcardId, bool known) async {
    final db = await _dbHelper.database;
    await db.update(
      'flashcards',
      {
        'is_known': known ? 1 : 0,
        'review_count': known ? 1 : 0,
        'last_reviewed': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [flashcardId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
