import 'package:flutter/material.dart';

class FlashcardWidget extends StatefulWidget {
  final String frontText;
  final String backText;
  final String type;
  final VoidCallback onKnown;
  final VoidCallback onUnknown;

  const FlashcardWidget({
    super.key,
    required this.frontText,
    required this.backText,
    required this.type,
    required this.onKnown,
    required this.onUnknown,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool _showBack = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _showBack = !_showBack),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      _showBack ? widget.backText : widget.frontText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _showBack ? 'Tap to see question' : 'Tap card to reveal answer',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  widget.onUnknown();
                  setState(() => _showBack = false);
                },
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text('Still learning'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onKnown();
                  setState(() => _showBack = false);
                },
                icon: const Icon(Icons.check),
                label: const Text('Known'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
