class Question {
  final int id;
  final int chapterId;
  final int subjectId;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;
  final String? explanation;
  final String difficulty;
  final String? topic;
  final String? imagePath;
  final String? tags;

  Question({
    required this.id,
    required this.chapterId,
    required this.subjectId,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    this.explanation,
    this.difficulty = 'medium',
    this.topic,
    this.imagePath,
    this.tags,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int,
      chapterId: map['chapter_id'] as int,
      subjectId: map['subject_id'] as int,
      questionText: map['question_text'] as String,
      optionA: map['option_a'] as String,
      optionB: map['option_b'] as String,
      optionC: map['option_c'] as String,
      optionD: map['option_d'] as String,
      correctOption: map['correct_option'] as String,
      explanation: map['explanation'] as String?,
      difficulty: map['difficulty'] as String? ?? 'medium',
      topic: map['topic'] as String?,
      imagePath: map['image_path'] as String?,
      tags: map['tags'] as String?,
    );
  }

  String getOption(String option) {
    switch (option) {
      case 'A':
        return optionA;
      case 'B':
        return optionB;
      case 'C':
        return optionC;
      case 'D':
        return optionD;
      default:
        return '';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'subject_id': subjectId,
      'question_text': questionText,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'correct_option': correctOption,
      'explanation': explanation,
      'difficulty': difficulty,
      'topic': topic,
      'image_path': imagePath,
      'tags': tags,
    };
  }
}
