import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dr_tragic_mfa/presentation/providers/flashcard_provider.dart';
import 'package:dr_tragic_mfa/presentation/widgets/flashcard_widget.dart';

class FlashcardScreen extends StatefulWidget {
  final int chapterId;

  const FlashcardScreen({super.key, required this.chapterId});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlashcardProvider>().loadFlashcards(widget.chapterId);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<FlashcardProvider>(
          builder: (context, provider, _) {
            if (provider.flashcards.isEmpty) return const Text('Flashcards');
            return Text(
              '${_currentIndex + 1}/${provider.flashcards.length}',
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              // Shuffle flashcards
            },
          ),
        ],
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.flashcards.isEmpty) {
            return const Center(
              child: Text('No flashcards available'),
            );
          }

          return PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: provider.flashcards.length,
            itemBuilder: (context, index) {
              final flashcard = provider.flashcards[index];
              return Padding(
                padding: const EdgeInsets.all(24),
                child: FlashcardWidget(
                  frontText: flashcard.frontText,
                  backText: flashcard.backText,
                  type: flashcard.type,
                  onKnown: () => provider.markAsKnown(flashcard.id),
                  onUnknown: () => provider.markAsUnknown(flashcard.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
