class Subject {
  final String id;
  final String name;
  final List<Chapter> chapters;

  Subject({required this.id, required this.name, required this.chapters});
}

class Chapter {
  final String id;
  final String name;
  final List<MCQ> mcqs;
  final List<Flashcard> flashcards;

  Chapter({required this.id, required this.name, required this.mcqs, required this.flashcards});
}

class MCQ {
  final String question;
  final List<String> options;
  final String answer;

  MCQ({required this.question, required this.options, required this.answer});
}

class Flashcard {
  final String front;
  final String back;

  Flashcard({required this.front, required this.back});
}
