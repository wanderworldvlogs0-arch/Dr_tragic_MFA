import 'package:flutter/foundation.dart';
import 'package:dr_tragic_mfa/data/models/chapter.dart';
import 'package:dr_tragic_mfa/data/repositories/chapter_repository.dart';

class ChapterProvider extends ChangeNotifier {
  final ChapterRepository _chapterRepository = ChapterRepository();

  List<Chapter> _chapters = [];
  bool _isLoading = false;
  String? _error;

  List<Chapter> get chapters => _chapters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChapters(int subjectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _chapters = await _chapterRepository.getChaptersBySubject(subjectId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
