import 'package:flutter/foundation.dart';
import 'package:dr_tragic_mfa/data/models/question.dart';
import 'package:dr_tragic_mfa/data/repositories/question_repository.dart';
import 'package:dr_tragic_mfa/core/utils/stats_calculator.dart';

enum QuizMode { practice, exam, random, weak, bookmark }

class QuizProvider extends ChangeNotifier {
  final QuestionRepository _questionRepository = QuestionRepository();
  
  List<Question> _questions = [];
  int _currentIndex = 0;
  QuizMode _quizMode = QuizMode.practice;
  
  // Results tracking
  Map<int, String> _userAnswers = {};
  Map<int, bool> _correctnessMap = {};
  Map<int, double> _timeMap = {};
  Set<int> _bookmarkedQuestions = {};
  
  // Timer
  int _remainingSeconds = 0;
  bool _isTimerActive = false;
  
  // State
  bool _isLoading = false;
  bool _isFinished = false;
  String? _error;

  // Getters
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  Question? get currentQuestion => 
      _questions.isNotEmpty ? _questions[_currentIndex] : null;
  QuizMode get quizMode => _quizMode;
  bool get isLoading => _isLoading;
  bool get isFinished => _isFinished;
  bool get hasNext => _currentIndex < _questions.length - 1;
  bool get hasPrevious => _currentIndex > 0;
  int get totalQuestions => _questions.length;
  int get remainingSeconds => _remainingSeconds;
  bool get isTimerActive => _isTimerActive;
  String? get error => _error;

  // Load questions based on mode
  Future<void> loadQuestions({
    required QuizMode mode,
    int? chapterId,
    int? subjectId,
    List<int>? chapterIds,
    int count = 10,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      switch (mode) {
        case QuizMode.practice:
        case QuizMode.exam:
          if (chapterId != null) {
            _questions = await _questionRepository.getQuestionsByChapter(chapterId);
          } else if (subjectId != null) {
            _questions = await _questionRepository.getQuestionsBySubject(subjectId);
          }
          break;
        case QuizMode.random:
          _questions = await _questionRepository.getRandomQuestions(
            count: count,
            chapterIds: chapterIds,
          );
          break;
        case QuizMode.weak:
          _questions = await _questionRepository.getWeakQuestions();
          break;
        case QuizMode.bookmark:
          _questions = await _questionRepository.getBookmarkedQuestions();
          break;
      }

      _quizMode = mode;
      _currentIndex = 0;
      _userAnswers.clear();
      _correctnessMap.clear();
      _timeMap.clear();
      _isFinished = false;
      _bookmarkedQuestions = Set.from(
        await _questionRepository.getBookmarkIds()
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Answer selection
  void selectAnswer(String option) {
    if (_isFinished || _userAnswers.containsKey(_currentIndex)) return;
    
    final question = currentQuestion!;
    final isCorrect = option == question.correctOption;
    
    _userAnswers[_currentIndex] = option;
    _correctnessMap[_currentIndex] = isCorrect;
    
    notifyListeners();
  }

  // Navigation
  void nextQuestion() {
    if (hasNext) {
      _currentIndex++;
      notifyListeners();
    } else {
      finishQuiz();
    }
  }

  void previousQuestion() {
    if (hasPrevious) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  // Bookmark
  Future<void> toggleBookmark() async {
    final question = currentQuestion!;
    if (_bookmarkedQuestions.contains(question.id)) {
      await _questionRepository.removeBookmark(question.id);
      _bookmarkedQuestions.remove(question.id);
    } else {
      await _questionRepository.addBookmark(question.id);
      _bookmarkedQuestions.add(question.id);
    }
    notifyListeners();
  }

  bool isBookmarked(int questionId) => _bookmarkedQuestions.contains(questionId);

  // Timer management
  void startTimer(int seconds) {
    _remainingSeconds = seconds;
    _isTimerActive = true;
    notifyListeners();
  }

  void stopTimer() {
    _isTimerActive = false;
    notifyListeners();
  }

  void tickTimer() {
    if (_isTimerActive && _remainingSeconds > 0) {
      _remainingSeconds--;
      if (_remainingSeconds <= 0) {
        finishQuiz();
      }
      notifyListeners();
    }
  }

  // Finish quiz
  void finishQuiz() {
    _isFinished = true;
    _isTimerActive = false;
    _saveResults();
    notifyListeners();
  }

  Future<void> _saveResults() async {
    // Calculate stats and save to database
    await StatsCalculator.saveTestResult(
      questions: _questions,
      userAnswers: _userAnswers,
      correctnessMap: _correctnessMap,
      quizMode: _quizMode,
    );
  }

  // Reset
  void reset() {
    _questions = [];
    _currentIndex = 0;
    _userAnswers.clear();
    _correctnessMap.clear();
    _isFinished = false;
    _isTimerActive = false;
    _remainingSeconds = 0;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _isTimerActive = false;
    super.dispose();
  }
}
