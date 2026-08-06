import 'package:dr_tragic_mfa/core/database/database_helper.dart';
import 'package:dr_tragic_mfa/data/models/question.dart';

class QuestionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Question>> getQuestionsByChapter(int chapterId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'questions',
      where: 'chapter_id = ? AND is_active = 1',
      whereArgs: [chapterId],
    );
    return results.map((map) => Question.fromMap(map)).toList();
  }

  Future<List<Question>> getQuestionsBySubject(int subjectId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'questions',
      where: 'subject_id = ? AND is_active = 1',
      whereArgs: [subjectId],
    );
    return results.map((map) => Question.fromMap(map)).toList();
  }

  Future<List<Question>> getRandomQuestions({
    int count = 10,
    List<int>? chapterIds,
  }) async {
    final db = await _dbHelper.database;
    
    String? whereClause;
    List<dynamic>? whereArgs;
    
    if (chapterIds != null && chapterIds.isNotEmpty) {
      final placeholders = List.filled(chapterIds.length, '?').join(',');
      whereClause = 'chapter_id IN ($placeholders) AND is_active = 1';
      whereArgs = chapterIds;
    } else {
      whereClause = 'is_active = 1';
    }

    final results = await db.query(
      'questions',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'RANDOM()',
      limit: count,
    );
    
    return results.map((map) => Question.fromMap(map)).toList();
  }

  Future<List<Question>> getWeakQuestions() async {
    final db = await _dbHelper.database;
    
    // Get questions that were answered incorrectly multiple times
    final results = await db.rawQuery('''
      SELECT q.* FROM questions q
      INNER JOIN user_progress up ON q.id = up.question_id
      WHERE up.is_correct = 0 
      AND up.attempt_count >= 2
      ORDER BY RANDOM()
      LIMIT 20
    ''');
    
    return results.map((map) => Question.fromMap(map)).toList();
  }

  Future<List<Question>> getBookmarkedQuestions() async {
    final db = await _dbHelper.database;
    
    final results = await db.rawQuery('''
      SELECT q.* FROM questions q
      INNER JOIN bookmarks b ON q.id = b.question_id
      WHERE b.type = 'question'
      ORDER BY b.created_at DESC
    ''');
    
    return results.map((map) => Question.fromMap(map)).toList();
  }

  Future<Set<int>> getBookmarkIds() async {
    final db = await _dbHelper.database;
    final results = await db.query('bookmarks', columns: ['question_id']);
    return results.map((row) => row['question_id'] as int).toSet();
  }

  Future<void> addBookmark(int questionId) async {
    final db = await _dbHelper.database;
    await db.insert('bookmarks', {
      'question_id': questionId,
      'type': 'question',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeBookmark(int questionId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'bookmarks',
      where: 'question_id = ? AND type = ?',
      whereArgs: [questionId, 'question'],
    );
  }

  Future<void> saveProgress({
    required int questionId,
    required bool isCorrect,
    required double timeTaken,
    required String mode,
  }) async {
    final db = await _dbHelper.database;
    
    // Check if progress exists
    final existing = await db.query(
      'user_progress',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
    
    if (existing.isEmpty) {
      await db.insert('user_progress', {
        'question_id': questionId,
        'is_correct': isCorrect ? 1 : 0,
        'is_attempted': 1,
        'is_bookmarked': 0,
        'attempt_count': 1,
        'last_attempted': DateTime.now().toIso8601String(),
        'time_taken_seconds': timeTaken,
        'mode': mode,
      });
    } else {
      await db.update(
        'user_progress',
        {
          'is_correct': isCorrect ? 1 : 0,
          'attempt_count': (existing.first['attempt_count'] as int) + 1,
          'last_attempted': DateTime.now().toIso8601String(),
          'time_taken_seconds': timeTaken,
          'mode': mode,
        },
        where: 'question_id = ?',
        whereArgs: [questionId],
      );
    }
  }
}
