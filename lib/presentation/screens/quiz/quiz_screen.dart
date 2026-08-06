import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dr_tragic_mfa/presentation/providers/quiz_provider.dart';
import 'package:dr_tragic_mfa/presentation/widgets/question_card.dart';
import 'package:dr_tragic_mfa/presentation/widgets/option_button.dart';
import 'package:dr_tragic_mfa/presentation/screens/quiz/quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, _) {
        if (quizProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (quizProvider.error != null) {
          return Scaffold(
            body: Center(child: Text('Error: ${quizProvider.error}')),
          );
        }

        if (quizProvider.isFinished) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const QuizResultScreen(),
              ),
            );
          });
          return const SizedBox();
        }

        final question = quizProvider.currentQuestion;
        if (question == null) {
          return const Scaffold(
            body: Center(child: Text('No questions available')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Question ${quizProvider.currentIndex + 1}/${quizProvider.totalQuestions}'),
            actions: [
              if (quizProvider.quizMode == QuizMode.practice)
                IconButton(
                  icon: Icon(
                    quizProvider.isBookmarked(question.id)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: quizProvider.isBookmarked(question.id)
                        ? Colors.amber
                        : null,
                  ),
                  onPressed: quizProvider.toggleBookmark,
                ),
            ],
          ),
          body: Column(
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (quizProvider.currentIndex + 1) / quizProvider.totalQuestions,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              // Timer (for exam mode)
              if (quizProvider.quizMode == QuizMode.exam)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: quizProvider.remainingSeconds < 60
                      ? Colors.red[100]
                      : Colors.blue[50],
                  child: Text(
                    'Time: ${quizProvider.remainingSeconds ~/ 60}:${(quizProvider.remainingSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Question
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Card
                      QuestionCard(question: question),
                      const SizedBox(height: 24),
                      // Options
                      ...['A', 'B', 'C', 'D'].map((option) {
                        final optionText = question.getOption(option);
                        final isSelected = quizProvider.isSelected(
                          quizProvider.currentIndex,
                          option,
                        );
                        final isCorrect = option == question.correctOption;
                        
                        bool showCorrect = false;
                        if (quizProvider.quizMode == QuizMode.practice &&
                            quizProvider.isAnswered(quizProvider.currentIndex)) {
                          showCorrect = true;
                        }

                        return OptionButton(
                          option: option,
                          text: optionText,
                          isSelected: isSelected,
                          isCorrect: showCorrect ? isCorrect : null,
                          onPressed: () => quizProvider.selectAnswer(option),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              // Navigation Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (quizProvider.hasPrevious)
                      OutlinedButton.icon(
                        onPressed: quizProvider.previousQuestion,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: quizProvider.hasNext
                          ? quizProvider.nextQuestion
                          : quizProvider.finishQuiz,
                      icon: Icon(
                        quizProvider.hasNext
                            ? Icons.arrow_forward
                            : Icons.check_circle,
                      ),
                      label: Text(
                        quizProvider.hasNext ? 'Next' : 'Finish',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
