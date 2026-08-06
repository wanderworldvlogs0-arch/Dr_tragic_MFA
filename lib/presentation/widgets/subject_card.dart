import 'package:flutter/material.dart';
import 'package:dr_tragic_mfa/data/models/subject.dart';
import 'package:dr_tragic_mfa/presentation/screens/chapters/chapter_list_screen.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChapterListScreen(subject: subject),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: subject.color.withOpacity(0.15),
                child: Icon(subject.iconData, color: subject.color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                subject.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (subject.nameBn != null) ...[
                const SizedBox(height: 4),
                Text(
                  subject.nameBn!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                '${subject.totalQuestions} Qs · ${subject.totalChapters} Ch',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
