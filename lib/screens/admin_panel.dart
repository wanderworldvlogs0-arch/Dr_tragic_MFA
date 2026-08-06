import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../services/data_service.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<Subject> subjects = [];
  Subject? selectedSubject;
  Chapter? selectedChapter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DataService.loadSubjects();
    setState(() => subjects = data);
  }

  Future<void> _saveData() async {
    await DataService.saveSubjects(subjects);
    setState(() {});
  }

  void _addSubject() {
    showDialog(
      context: context,
      builder: (ctx) => _buildInputDialog('Subject Name', (name) {
        setState(() {
          subjects.add(Subject(id: DateTime.now().toString(), name: name, chapters: []));
        });
        _saveData();
      }),
    );
  }

  void _addChapter(Subject subject) {
    showDialog(
      context: context,
      builder: (ctx) => _buildInputDialog('Chapter Name', (name) {
        subject.chapters.add(Chapter(id: DateTime.now().toString(), name: name, mcqs: [], flashcards: []));
        _saveData();
      }),
    );
  }

  void _addMCQ(Chapter chapter) {
    // সরলীকৃত — পরে আরও বিস্তারিত দেব
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add MCQ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Question')),
            TextField(decoration: InputDecoration(labelText: 'Options (comma separated)')),
            TextField(decoration: InputDecoration(labelText: 'Correct Answer')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          TextButton(onPressed: () {
            // logic to add MCQ
            Navigator.pop(ctx);
            _saveData();
          }, child: Text('Add')),
        ],
      ),
    );
  }

  Widget _buildInputDialog(String label, Function(String) onSave) {
    final controller = TextEditingController();
    return AlertDialog(
      title: Text('Add $label'),
      content: TextField(controller: controller, decoration: InputDecoration(labelText: label)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(onPressed: () {
          if (controller.text.isNotEmpty) onSave(controller.text);
          Navigator.pop(context);
        }, child: Text('Save')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel'), backgroundColor: Colors.deepPurple),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade100, Colors.purple.shade200]),
        ),
        child: Row(
          children: [
            // Subjects list
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addSubject,
                      icon: Icon(Icons.add),
                      label: Text('Add Subject'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: subjects.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Text(subjects[i].name),
                          selected: selectedSubject == subjects[i],
                          onTap: () => setState(() => selectedSubject = subjects[i]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Chapters & content
            Expanded(
              flex: 3,
              child: selectedSubject == null
                  ? Center(child: Text('Select a subject', style: TextStyle(fontSize: 18, color: Colors.white70)))
                  : Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                      ),
                      child: Column(
                        children: [
                          Text(selectedSubject!.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ElevatedButton.icon(
                            onPressed: () => _addChapter(selectedSubject!),
                            icon: Icon(Icons.add),
                            label: Text('Add Chapter'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: selectedSubject!.chapters.length,
                              itemBuilder: (ctx, i) => Card(
                                child: ListTile(
                                  title: Text(selectedSubject!.chapters[i].name),
                                  onTap: () => setState(() => selectedChapter = selectedSubject!.chapters[i]),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(icon: Icon(Icons.quiz), onPressed: () => _addMCQ(selectedSubject!.chapters[i])),
                                      IconButton(icon: Icon(Icons.style), onPressed: () {}),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
