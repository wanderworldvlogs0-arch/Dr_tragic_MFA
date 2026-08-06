import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String option;
  final String text;
  final bool isSelected;
  final bool? isCorrect; // null = don't reveal, true/false = reveal correctness
  final VoidCallback onPressed;

  const OptionButton({
    super.key,
    required this.option,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color borderColor = Colors.grey.shade300;
    Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    if (isCorrect != null) {
      // Reveal mode (practice mode, already answered)
      if (isCorrect == true) {
        backgroundColor = Colors.green.withOpacity(0.15);
        borderColor = Colors.green;
      } else if (isSelected && isCorrect == false) {
        backgroundColor = Colors.red.withOpacity(0.15);
        borderColor = Colors.red;
      }
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.12);
      borderColor = Theme.of(context).colorScheme.primary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: borderColor,
                child: Text(
                  option,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text, style: TextStyle(color: textColor, fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
