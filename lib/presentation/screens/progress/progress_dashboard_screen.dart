import 'package:flutter/material.dart';
import 'package:dr_tragic_mfa/core/utils/stats_calculator.dart';
import 'package:dr_tragic_mfa/presentation/widgets/bottom_nav.dart';

class ProgressDashboardScreen extends StatefulWidget {
  const ProgressDashboardScreen({super.key});

  @override
  State<ProgressDashboardScreen> createState() => _ProgressDashboardScreenState();
}

class _ProgressDashboardScreenState extends State<ProgressDashboardScreen> {
  Map<String, dynamic>? _overall;
  List<Map<String, dynamic>> _subjectProgress = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final overall = await StatsCalculator.getOverallStats();
    final subjects = await StatsCalculator.getSubjectProgress();
    setState(() {
      _overall = overall;
      _subjectProgress = subjects;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            '${(_overall?['accuracy'] as double? ?? 0.0).toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          const Text('Overall Accuracy'),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _MiniStat(label: 'Attempted', value: '${_overall?['total_questions'] ?? 0}'),
                              _MiniStat(label: 'Correct', value: '${_overall?['correct'] ?? 0}'),
                              _MiniStat(label: 'Incorrect', value: '${_overall?['incorrect'] ?? 0}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Subject-wise Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  if (_subjectProgress.isEmpty) const Text('No attempts yet'),
                  ..._subjectProgress.map((s) {
                    final total = (s['total'] as int?) ?? 0;
                    final attempted = (s['attempted'] as int?) ?? 0;
                    final correct = (s['correct'] as int?) ?? 0;
                    final progress = total > 0 ? attempted / total : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${s['subject_name'] ?? ''}'),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
                          const SizedBox(height: 2),
                          Text(
                            '$attempted/$total attempted · $correct correct',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
