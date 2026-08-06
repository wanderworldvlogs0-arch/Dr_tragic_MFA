class Migrations {
  static List<String> createTables = [
    '''
    CREATE TABLE subjects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        name_bn TEXT,
        icon TEXT NOT NULL,
        color TEXT DEFAULT '#2196F3',
        total_chapters INTEGER DEFAULT 0,
        total_questions INTEGER DEFAULT 0,
        order_index INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
    ''',
    '''
    CREATE TABLE chapters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        name_bn TEXT,
        order_index INTEGER DEFAULT 0,
        total_questions INTEGER DEFAULT 0,
        total_flashcards INTEGER DEFAULT 0,
        FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chapter_id INTEGER NOT NULL,
        subject_id INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        option_a TEXT NOT NULL,
        option_b TEXT NOT NULL,
        option_c TEXT NOT NULL,
        option_d TEXT NOT NULL,
        correct_option TEXT NOT NULL CHECK(correct_option IN ('A','B','C','D')),
        explanation TEXT,
        difficulty TEXT CHECK(difficulty IN ('easy','medium','hard')) DEFAULT 'medium',
        topic TEXT,
        image_path TEXT,
        tags TEXT,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE,
        FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chapter_id INTEGER NOT NULL,
        subject_id INTEGER NOT NULL,
        type TEXT CHECK(type IN ('definition','classification','mnemonic','drug','image','table','flowchart')) DEFAULT 'definition',
        front_text TEXT NOT NULL,
        back_text TEXT NOT NULL,
        image_path TEXT,
        is_known INTEGER DEFAULT 0,
        review_count INTEGER DEFAULT 0,
        last_reviewed TEXT,
        next_review TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE,
        FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL UNIQUE,
        is_correct INTEGER DEFAULT 0,
        is_attempted INTEGER DEFAULT 0,
        is_bookmarked INTEGER DEFAULT 0,
        attempt_count INTEGER DEFAULT 0,
        last_attempted TEXT,
        time_taken_seconds REAL DEFAULT 0,
        mode TEXT DEFAULT 'practice',
        FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER UNIQUE,
        flashcard_id INTEGER UNIQUE,
        type TEXT CHECK(type IN ('question','flashcard')),
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
        FOREIGN KEY (flashcard_id) REFERENCES flashcards(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE test_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        test_type TEXT CHECK(test_type IN ('practice','exam','mock','random','weak','bookmark')),
        subject_id INTEGER,
        total_questions INTEGER NOT NULL,
        correct_count INTEGER DEFAULT 0,
        incorrect_count INTEGER DEFAULT 0,
        skipped_count INTEGER DEFAULT 0,
        accuracy REAL DEFAULT 0,
        time_taken_seconds REAL DEFAULT 0,
        date_taken TEXT DEFAULT CURRENT_TIMESTAMP,
        details TEXT
    )
    ''',
    '''
    CREATE TABLE mock_test_configs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        subject_ids TEXT,
        chapter_ids TEXT,
        total_questions INTEGER NOT NULL,
        difficulty TEXT DEFAULT 'all',
        time_limit_minutes INTEGER NOT NULL,
        negative_marking INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
    ''',
    '''
    CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
    )
    ''',
    // Indices
    'CREATE INDEX idx_questions_chapter ON questions(chapter_id)',
    'CREATE INDEX idx_questions_subject ON questions(subject_id)',
    'CREATE INDEX idx_progress_question ON user_progress(question_id)',
    'CREATE INDEX idx_bookmarks_type ON bookmarks(type)',
    'CREATE INDEX idx_flashcards_chapter ON flashcards(chapter_id)',
    'CREATE INDEX idx_test_results_date ON test_results(date_taken)',
    'CREATE INDEX idx_questions_tags ON questions(tags)',
  ];

  static Map<int, String> upgrades = {
    // Future migrations
  };
}
