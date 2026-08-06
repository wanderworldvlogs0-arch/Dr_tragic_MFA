import 'package:flutter/material.dart';
import 'package:dr_tragic_mfa/core/database/database_helper.dart';
import 'package:dr_tragic_mfa/data/models/question.dart';
import 'package:dr_tragic_mfa/core/utils/search_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Question> _allQuestions = [];
  List<Question> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('questions', where: 'is_active = 1');
    setState(() {
      _allQuestions = rows.map((m) => Question.fromMap(m)).toList();
      _results = _allQuestions;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _results = SearchUtils.search<Question>(
        items: _allQuestions,
        query: query,
        searchFields: [
          (q) => q.questionText,
          (q) => q.topic ?? '',
          (q) => q.tags ?? '',
        ],
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search questions...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _onSearchChanged,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('No questions found'))
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final q = _results[index];
                    return ListTile(
                      title: Text(
                        q.questionText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: q.topic != null ? Text(q.topic!) : null,
                    );
                  },
                ),
    );
  }
}
