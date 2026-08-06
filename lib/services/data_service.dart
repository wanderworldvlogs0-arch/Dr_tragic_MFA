import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/subject_model.dart';

class DataService {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/subjects.json');
  }

  static Future<List<Subject>> loadSubjects() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((e) => Subject(
        id: e['id'],
        name: e['name'],
        chapters: (e['chapters'] as List).map((c) => Chapter(
          id: c['id'],
          name: c['name'],
          mcqs: (c['mcqs'] as List).map((m) => MCQ(
            question: m['question'],
            options: List<String>.from(m['options']),
            answer: m['answer'],
          )).toList(),
          flashcards: (c['flashcards'] as List).map((f) => Flashcard(
            front: f['front'],
            back: f['back'],
          )).toList(),
        )).toList(),
      )).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveSubjects(List<Subject> subjects) async {
    final file = await _localFile;
    final jsonData = subjects.map((s) => {
      'id': s.id,
      'name': s.name,
      'chapters': s.chapters.map((c) => {
        'id': c.id,
        'name': c.name,
        'mcqs': c.mcqs.map((m) => {
          'question': m.question,
          'options': m.options,
          'answer': m.answer,
        }).toList(),
        'flashcards': c.flashcards.map((f) => {
          'front': f.front,
          'back': f.back,
        }).toList(),
      }).toList(),
    }).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }
}
