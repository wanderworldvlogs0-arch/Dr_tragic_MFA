import 'package:sqflite/sqflite.dart';
import 'package:dr_tragic_mfa/core/database/database_helper.dart';
import 'package:dr_tragic_mfa/data/models/question.dart';

class StatsCalculator {
  static Future<void> saveTestResult({
    required List<Question> questions,
    required Map<int, String> userAnswers,
    required Map<int, bool> correctnessMap,
    required dynamic quizMode,
  }) async {
    final db = await DatabaseHelper.instance.database;
    
    int correctCount = 0;
    int incorrectCount = 0;
    int skippedCount = questions.length - userAnswers.length;
    double totalTime = 0;

    // Save individual question progress
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final isAnswered = userAnswers.containsKey(i);
      final isCorrect = correctnessMap[i] ?? false;
      
      if (isCorrect) correctCount++;
      if (isAnswered && !isCorrect) incorrectCount++;
      
      // Save to user_progress
      await db.insert(
        'user_progress',
        {
          'question_id': question.id,
          'is_correct': isAnswered && isCorrect ? 1 : 0,
          'is_attempted': isAnswered ? 1 : 0,
          'attempt_count': 1,
          'last_attempted': DateTime.now().toIso8601String(),
          'time_taken_seconds': 30, // Average time per question
          'mode': quizMode.toString(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Save test result
    double accuracy = questions.isNotEmpty
        ? (correctCount / questions.length) * 100
        : 0;

    await db.insert('test_results', {
      'test_type': quizMode.toString().split('.').last,
      'total_questions': questions.length,
      'correct_count': correctCount,
      'incorrect_count': incorrectCount,
      'skipped_count': skippedCount,
      'accuracy': accuracy,
      'time_taken_seconds': totalTime,
      'date_taken': DateTime.now().toIso8601String(),
      'details': '{}',
    });
  }

  static Future<Map<String, dynamic>> getOverallStats() async {
    final db = await DatabaseHelper.instance.database;
    
    // Get overall stats
    final result = await db.rawQuery('''
      SELECT 
        COUNT(DISTINCT question_id) as total_questions,
        SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END) as correct,
        SUM(CASE WHEN is_correct = 0 AND is_attempted = 1 THEN 1 ELSE 0 END) as incorrect,
        AVG(time_taken_seconds) as avg_time
      FROM user_progress
    ''');
    
    if (result.isEmpty) {
      return {
        'total_questions': 0,
        'correct': 0,
        'incorrect': 0,
        'avg_time': 0.0,
        'accuracy': 0.0,
      };
    }
    
    final row = result.first;
    final total = (row['total_questions'] as int?) ?? 0;
    final correct = (row['correct'] as int?) ?? 0;
    
    return {
      'total_questions': total,
      'correct': correct,
      'incorrect': (row['incorrect'] as int?) ?? 0,
      'avg_time': (row['avg_time'] as double?) ?? 0.0,
      'accuracy': total > 0 ? (correct / total) * 100 : 0.0,
    };
  }

  static Future<List<Map<String, dynamic>>> getSubjectProgress() async {
    final db = await DatabaseHelper.instance.database;
    
    return await db.rawQuery('''
      SELECT 
        s.name as subject_name,
        s.id as subject_id,
        COUNT(DISTINCT up.question_id) as attempted,
        s.total_questions as total,
        SUM(CASE WHEN up.is_correct = 1 THEN 1 ELSE 0 END) as correct
      FROM subjects s
      LEFT JOIN questions q ON q.subject_id = s.id
      LEFT JOIN user_progress up ON up.question_id = q.id
      GROUP BY s.id
    ''');
  }
}
