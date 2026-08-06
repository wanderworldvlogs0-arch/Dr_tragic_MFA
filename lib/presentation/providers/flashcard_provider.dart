import 'package:flutter/foundation.dart';
import 'package:dr_tragic_mfa/data/models/flashcard.dart';
import 'package:dr_tragic_mfa/data/repositories/flashcard_repository.dart';

class FlashcardProvider extends ChangeNotifier {
  final FlashcardRepository _flashcardRepository = FlashcardRepository();

  List<Flashcard> _flashcards = [];
  bool _isLoading = false;
  String? _error;

  List<Flashcard> get flashcards => _flashcards;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFlashcards(int chapterId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _flashcards = await _flashcardRepository.getFlashcardsByChapter(chapterId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsKnown(int flashcardId) async {
    await _flashcardRepository.markKnown(flashcardId, true);
    _updateLocal(flashcardId, true);
  }

  Future<void> markAsUnknown(int flashcardId) async {
    await _flashcardRepository.markKnown(flashcardId, false);
    _updateLocal(flashcardId, false);
  }

  void _updateLocal(int flashcardId, bool known) {
    final index = _flashcards.indexWhere((f) => f.id == flashcardId);
    if (index != -1) {
      final old = _flashcards[index];
      _flashcards[index] = Flashcard(
        id: old.id,
        chapterId: old.chapterId,
        subjectId: old.subjectId,
        type: old.type,
        frontText: old.frontText,
        backText: old.backText,
        imagePath: old.imagePath,
        isKnown: known,
        reviewCount: old.reviewCount + 1,
      );
      notifyListeners();
    }
  }
}
