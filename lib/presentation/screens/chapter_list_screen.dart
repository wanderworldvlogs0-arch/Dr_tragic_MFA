import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dr_tragic_mfa/data/models/subject.dart';
import 'package:dr_tragic_mfa/presentation/providers/chapter_provider.dart';
import 'package:dr_tragic_mfa/presentation/providers/quiz_provider.dart';
import 'package:dr_tragic_mfa/presentation/providers/flashcard_provider.dart';
import 'package:dr_tragic_mfa/presentation/screens/quiz/quiz_screen.dart';
import 'package:dr_tragic_mfa/presentation/screens/flashcards/flashcard_screen.dart';

class ChapterListScreen extends StatelessWidget {
  final Subject subject;

  const ChapterListScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChapterProvider()..loadChapters(subject.id),
      child: Scaffold(
        appBar: AppBar(title: Text(subject.name)),
        body: Consumer<ChapterProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null) {
              return Center(child: Text('Error: ${provider.error}'));
            }
            if (provider.chapters.isEmpty) {
              return const Center(child: Text('No chapters available yet'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.chapters.length,
              itemBuilder: (context, index) {
                final chapter = provider.chapters[index];
                return Card(
                  child: ListTile(
                    title: Text(chapter.name),
                    subtitle: Text('${chapter.totalQuestions} questions · ${chapter.totalFlashcards} flashcards'),
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          tooltip: 'Quiz',
                          icon: const Icon(Icons.quiz_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => QuizProvider()
                                    ..loadQuestions(
                                      mode: QuizMode.practice,
                                      chapterId: chapter.id,
                                    ),
                                  child: const QuizScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'Flashcards',
                          icon: const Icon(Icons.style_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => FlashcardProvider(),
                                  child: FlashcardScreen(chapterId: chapter.id),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
