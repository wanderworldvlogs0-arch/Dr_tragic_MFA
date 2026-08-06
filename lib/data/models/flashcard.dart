class Flashcard {
  final int id;
  final int chapterId;
  final int subjectId;
  final String type;
  final String frontText;
  final String backText;
  final String? imagePath;
  final bool isKnown;
  final int reviewCount;

  Flashcard({
    required this.id,
    required this.chapterId,
    required this.subjectId,
    required this.type,
    required this.frontText,
    required this.backText,
    this.imagePath,
    this.isKnown = false,
    this.reviewCount = 0,
  });

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'] as int,
      chapterId: map['chapter_id'] as int,
      subjectId: map['subject_id'] as int,
      type: map['type'] as String? ?? 'definition',
      frontText: map['front_text'] as String,
      backText: map['back_text'] as String,
      imagePath: map['image_path'] as String?,
      isKnown: (map['is_known'] as int? ?? 0) == 1,
      reviewCount: map['review_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'subject_id': subjectId,
      'type': type,
      'front_text': frontText,
      'back_text': backText,
      'image_path': imagePath,
      'is_known': isKnown ? 1 : 0,
      'review_count': reviewCount,
    };
  }
}
