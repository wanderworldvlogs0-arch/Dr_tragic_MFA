import 'package:sqflite/sqflite.dart';

class SeedData {
  static Future<void> insertSeedData(Database db) async {
    // Insert Subjects
    await _insertSubjects(db);
    // Insert Chapters
    await _insertChapters(db);
    // Insert Questions
    await _insertQuestions(db);
    // Insert Flashcards
    await _insertFlashcards(db);
    // Insert Default Settings
    await _insertDefaultSettings(db);
  }

  static Future<void> _insertSubjects(Database db) async {
    List<Map<String, dynamic>> subjects = [
      {
        'name': 'Anatomy',
        'name_bn': 'শারীরস্থান',
        'icon': 'anatomy',
        'color': '#1565C0',
        'total_chapters': 12,
        'total_questions': 1200,
        'order_index': 1
      },
      {
        'name': 'Physiology',
        'name_bn': 'শারীরবৃত্ত',
        'icon': 'physiology',
        'color': '#2E7D32',
        'total_chapters': 10,
        'total_questions': 1000,
        'order_index': 2
      },
      {
        'name': 'Biochemistry',
        'name_bn': 'জৈবরসায়ন',
        'icon': 'biochemistry',
        'color': '#E65100',
        'total_chapters': 8,
        'total_questions': 800,
        'order_index': 3
      },
      {
        'name': 'Pathology',
        'name_bn': 'রোগতত্ত্ব',
        'icon': 'pathology',
        'color': '#C62828',
        'total_chapters': 7,
        'total_questions': 700,
        'order_index': 4
      },
      {
        'name': 'Pharmacology',
        'name_bn': 'ফার্মাকোলজি',
        'icon': 'pharmacology',
        'color': '#6A1B9A',
        'total_chapters': 9,
        'total_questions': 900,
        'order_index': 5
      },
      {
        'name': 'Microbiology',
        'name_bn': 'অণুজীববিজ্ঞান',
        'icon': 'microbiology',
        'color': '#00838F',
        'total_chapters': 6,
        'total_questions': 600,
        'order_index': 6
      },
      {
        'name': 'Forensic Medicine',
        'name_bn': 'ফরেনসিক মেডিসিন',
        'icon': 'forensic',
        'color': '#4E342E',
        'total_chapters': 5,
        'total_questions': 500,
        'order_index': 7
      },
      {
        'name': 'Community Medicine',
        'name_bn': 'কমিউনিটি মেডিসিন',
        'icon': 'community',
        'color': '#558B2F',
        'total_chapters': 4,
        'total_questions': 400,
        'order_index': 8
      },
      {
        'name': 'ENT',
        'name_bn': 'ইএনটি',
        'icon': 'ent',
        'color': '#37474F',
        'total_chapters': 4,
        'total_questions': 400,
        'order_index': 9
      },
      {
        'name': 'Ophthalmology',
        'name_bn': 'চক্ষুরোগ',
        'icon': 'ophthalmology',
        'color': '#0277BD',
        'total_chapters': 3,
        'total_questions': 300,
        'order_index': 10
      },
      {
        'name': 'Medicine',
        'name_bn': 'মেডিসিন',
        'icon': 'medicine',
        'color': '#D84315',
        'total_chapters': 15,
        'total_questions': 1500,
        'order_index': 11
      },
      {
        'name': 'Surgery',
        'name_bn': 'সার্জারি',
        'icon': 'surgery',
        'color': '#283593',
        'total_chapters': 14,
        'total_questions': 1400,
        'order_index': 12
      },
      {
        'name': 'Pediatrics',
        'name_bn': 'শিশুরোগ',
        'icon': 'pediatrics',
        'color': '#AD1457',
        'total_chapters': 8,
        'total_questions': 800,
        'order_index': 13
      },
      {
        'name': 'Obstetrics & Gynecology',
        'name_bn': 'প্রসূতি ও স্ত্রীরোগ',
        'icon': 'obgyn',
        'color': '#00695C',
        'total_chapters': 10,
        'total_questions': 1000,
        'order_index': 14
      },
    ];

    for (var subject in subjects) {
      await db.insert('subjects', subject);
    }
  }

  static Future<void> _insertChapters(Database db) async {
    // Pathology Chapters (Subject ID = 4)
    List<Map<String, dynamic>> pathologyChapters = [
      {
        'subject_id': 4,
        'name': 'Cell Injury',
        'name_bn': 'কোষীয় আঘাত',
        'order_index': 1,
        'total_questions': 100,
        'total_flashcards': 25
      },
      {
        'subject_id': 4,
        'name': 'Inflammation',
        'name_bn': 'প্রদাহ',
        'order_index': 2,
        'total_questions': 100,
        'total_flashcards': 25
      },
      {
        'subject_id': 4,
        'name': 'Healing',
        'name_bn': 'আরোগ্য',
        'order_index': 3,
        'total_questions': 100,
        'total_flashcards': 25
      },
      {
        'subject_id': 4,
        'name': 'Hemodynamics',
        'name_bn': 'হেমোডায়নামিক্স',
        'order_index': 4,
        'total_questions': 100,
        'total_flashcards': 25
      },
      {
        'subject_id': 4,
        'name': 'Neoplasia',
        'name_bn': 'নিওপ্লাসিয়া',
        'order_index': 5,
        'total_questions': 100,
        'total_flashcards': 25
      },
      {
        'subject_id': 4,
        'name': 'Genetics',
        'name_bn': 'জিনতত্ত্ব',
        'order_index': 6,
        'total_questions': 100,
        'total_flashcards': 25
      },
      {
        'subject_id': 4,
        'name': 'Immunology',
        'name_bn': 'ইমিউনোলজি',
        'order_index': 7,
        'total_questions': 100,
        'total_flashcards': 25
      },
    ];

    for (var chapter in pathologyChapters) {
      await db.insert('chapters', chapter);
    }
    
    // Add chapters for other subjects similarly...
  }

  static Future<void> _insertQuestions(Database db) async {
    // Sample Pathology - Cell Injury Questions
    List<Map<String, dynamic>> questions = [
      {
        'chapter_id': 1,
        'subject_id': 4,
        'question_text': 'Which of the following is the earliest sign of reversible cell injury?',
        'option_a': 'Nuclear pyknosis',
        'option_b': 'Cellular swelling',
        'option_c': 'Karyorrhexis',
        'option_d': 'Karyolysis',
        'correct_option': 'B',
        'explanation': 'Cellular swelling (hydropic change) is the earliest manifestation of reversible cell injury, occurring due to failure of ATP-dependent sodium-potassium pump.',
        'difficulty': 'easy',
        'topic': 'Cell Injury Basics',
        'tags': 'cell injury,hydropic change,ATP'
      },
      {
        'chapter_id': 1,
        'subject_id': 4,
        'question_text': 'What type of necrosis is characteristic of myocardial infarction?',
        'option_a': 'Liquefactive necrosis',
        'option_b': 'Caseous necrosis',
        'option_c': 'Coagulative necrosis',
        'option_d': 'Fat necrosis',
        'correct_option': 'C',
        'explanation': 'Coagulative necrosis is characteristic of ischemic injury in solid organs except brain. The basic tissue architecture is preserved for several days.',
        'difficulty': 'medium',
        'topic': 'Necrosis Types',
        'tags': 'necrosis,coagulative,MI'
      },
      {
        'chapter_id': 1,
        'subject_id': 4,
        'question_text': 'Apoptosis is characterized by all EXCEPT:',
        'option_a': 'Cell shrinkage',
        'option_b': 'Chromatin condensation',
        'option_c': 'Inflammatory response',
        'option_d': 'DNA fragmentation',
        'correct_option': 'C',
        'explanation': 'Unlike necrosis, apoptosis does NOT elicit an inflammatory response. It is a programmed cell death that is "clean" and involves phagocytosis of apoptotic bodies.',
        'difficulty': 'medium',
        'topic': 'Apoptosis',
        'tags': 'apoptosis,inflammation,programmed cell death'
      },
    ];

    for (var question in questions) {
      await db.insert('questions', question);
    }
    
    // Add more questions for other chapters and subjects...
  }

  static Future<void> _insertFlashcards(Database db) async {
    List<Map<String, dynamic>> flashcards = [
      {
        'chapter_id': 1,
        'subject_id': 4,
        'type': 'definition',
        'front_text': 'What is Necrosis?',
        'back_text': 'Necrosis is unprogrammed cell death resulting from severe irreversible injury, characterized by cell swelling, protein denaturation, organelle breakdown, and leakage of cellular contents causing inflammation.',
      },
      {
        'chapter_id': 1,
        'subject_id': 4,
        'type': 'mnemonic',
        'front_text': 'Causes of Cell Injury - MNEMONIC',
        'back_text': 'O H I G E N\nO - Oxygen deficiency (Hypoxia)\nH - Hypoglycemia\nI - Infection/Inflammation\nG - Genetic\nE - Extreme temperatures\nN - Nutritional',
      },
      {
        'chapter_id': 1,
        'subject_id': 4,
        'type': 'classification',
        'front_text': 'Types of Necrosis',
        'back_text': '1. Coagulative\n2. Liquefactive\n3. Caseous\n4. Fat\n5. Fibrinoid\n6. Gangrenous',
      },
    ];

    for (var flashcard in flashcards) {
      await db.insert('flashcards', flashcard);
    }
  }

  static Future<void> _insertDefaultSettings(Database db) async {
    Map<String, String> defaultSettings = {
      'theme': 'system',
      'font_size': 'medium',
      'language': 'english',
      'negative_marking': 'off',
      'sound_effects': 'on',
      'vibration': 'on',
      'default_quiz_mode': 'practice',
    };

    for (var entry in defaultSettings.entries) {
      await db.insert('settings', {
        'key': entry.key,
        'value': entry.value,
      });
    }
  }
}
