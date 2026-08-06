import 'package:flutter/material.dart';
import 'package:dr_tragic_mfa/core/constants/app_colors.dart';

class Subject {
  final int id;
  final String name;
  final String? nameBn;
  final String icon;
  final Color color;
  final int totalChapters;
  final int totalQuestions;

  Subject({
    required this.id,
    required this.name,
    this.nameBn,
    required this.icon,
    required this.color,
    required this.totalChapters,
    required this.totalQuestions,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as int,
      name: map['name'] as String,
      nameBn: map['name_bn'] as String?,
      icon: map['icon'] as String,
      color: Color(int.parse((map['color'] as String).substring(1), radix: 16) + 0xFF000000),
      totalChapters: map['total_chapters'] as int? ?? 0,
      totalQuestions: map['total_questions'] as int? ?? 0,
    );
  }

  IconData get iconData {
    switch (icon) {
      case 'anatomy':
        return Icons.accessibility_new;
      case 'physiology':
        return Icons.favorite;
      case 'biochemistry':
        return Icons.science;
      case 'pathology':
        return Icons.coronavirus;
      case 'pharmacology':
        return Icons.medication;
      case 'microbiology':
        return Icons.bug_report;
      case 'forensic':
        return Icons.gavel;
      case 'community':
        return Icons.people;
      case 'ent':
        return Icons.hearing;
      case 'ophthalmology':
        return Icons.remove_red_eye;
      case 'medicine':
        return Icons.local_hospital;
      case 'surgery':
        return Icons.content_cut;
      case 'pediatrics':
        return Icons.child_care;
      case 'obgyn':
        return Icons.pregnant_woman;
      default:
        return Icons.school;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_bn': nameBn,
      'icon': icon,
      'color': '#${color.value.toRadixString(16).substring(2)}',
      'total_chapters': totalChapters,
      'total_questions': totalQuestions,
    };
  }
}
