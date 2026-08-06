import 'package:flutter/foundation.dart';
import 'package:dr_tragic_mfa/data/models/subject.dart';
import 'package:dr_tragic_mfa/data/repositories/subject_repository.dart';

class SubjectProvider extends ChangeNotifier {
  final SubjectRepository _subjectRepository = SubjectRepository();

  List<Subject> _subjects = [];
  bool _isLoading = false;
  String? _error;

  List<Subject> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSubjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _subjects = await _subjectRepository.getAllSubjects();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
