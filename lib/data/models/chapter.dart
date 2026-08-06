class Chapter {
  final int id;
  final int subjectId;
  final String name;
  final String? nameBn;
  final int orderIndex;
  final int totalQuestions;
  final int totalFlashcards;

  Chapter({
    required this.id,
    required this.subjectId,
    required this.name,
    this.nameBn,
    this.orderIndex = 0,
    this.totalQuestions = 0,
    this.totalFlashcards = 0,
  });

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'] as int,
      subjectId: map['subject_id'] as int,
      name: map['name'] as String,
      nameBn: map['name_bn'] as String?,
      orderIndex: map['order_index'] as int? ?? 0,
      totalQuestions: map['total_questions'] as int? ?? 0,
      totalFlashcards: map['total_flashcards'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_id': subjectId,
      'name': name,
      'name_bn': nameBn,
      'order_index': orderIndex,
      'total_questions': totalQuestions,
      'total_flashcards': totalFlashcards,
    };
  }
}
