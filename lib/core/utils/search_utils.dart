class SearchUtils {
  /// Search through list of items with multiple fields
  static List<T> search<T>({
    required List<T> items,
    required String query,
    required List<String Function(T)> searchFields,
  }) {
    if (query.isEmpty) return items;

    final searchTerms = query.toLowerCase().trim().split(' ');
    
    return items.where((item) {
      final searchText = searchFields
          .map((field) => field(item).toLowerCase())
          .join(' ');
      
      return searchTerms.every((term) => searchText.contains(term));
    }).toList();
  }

  /// Fuzzy search with similarity threshold
  static List<T> fuzzySearch<T>({
    required List<T> items,
    required String query,
    required List<String Function(T)> searchFields,
    double threshold = 0.6,
  }) {
    if (query.isEmpty) return items;

    final searchTerm = query.toLowerCase().trim();
    
    return items.where((item) {
      for (var field in searchFields) {
        final text = field(item).toLowerCase();
        if (text.contains(searchTerm)) return true;
        if (_calculateSimilarity(text, searchTerm) >= threshold) return true;
      }
      return false;
    }).toList();
  }

  /// Calculate Levenshtein distance-based similarity
  static double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    
    final distance = _levenshteinDistance(s1, s2);
    final maxLength = s1.length > s2.length ? s1.length : s2.length;
    
    return 1.0 - (distance / maxLength);
  }

  /// Levenshtein distance algorithm
  static int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<int> prev = List.generate(s2.length + 1, (i) => i);
    List<int> curr = List.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      curr[0] = i + 1;
      for (int j = 0; j < s2.length; j++) {
        int cost = s1[i] == s2[j] ? 0 : 1;
        curr[j + 1] = [
          curr[j] + 1,
          prev[j + 1] + 1,
          prev[j] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
      List<int> temp = prev;
      prev = curr;
      curr = temp;
    }

    return prev[s2.length];
  }

  /// Highlight matching text
  static String highlightMatch(String text, String query) {
    if (query.isEmpty) return text;
    
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);
    
    if (index == -1) return text;
    
    return '${text.substring(0, index)}<b>${text.substring(index, index + query.length)}</b>${text.substring(index + query.length)}';
  }
}
