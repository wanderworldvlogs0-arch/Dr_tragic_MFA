import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dr_tragic_mfa/presentation/providers/quiz_provider.dart';
import 'package:dr_tragic_mfa/presentation/screens/quiz/quiz_screen.dart';
import 'package:dr_tragic_mfa/presentation/widgets/bottom_nav.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('Review your bookmarked questions'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Bookmark Review'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => QuizProvider()
                        ..loadQuestions(mode: QuizMode.bookmark),
                      child: const QuizScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
