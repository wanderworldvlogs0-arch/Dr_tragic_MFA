import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dr_tragic_mfa/presentation/providers/settings_provider.dart';
import 'package:dr_tragic_mfa/presentation/widgets/bottom_nav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(settings.themeModeName),
            trailing: DropdownButton<String>(
              value: settings.themeModeSetting,
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
              ],
              onChanged: (value) {
                if (value != null) settings.setTheme(value);
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Negative Marking'),
            subtitle: const Text('Deduct marks for wrong answers in exam mode'),
            value: settings.negativeMarking,
            onChanged: (_) => settings.toggleNegativeMarking(),
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            value: settings.vibration,
            onChanged: (_) => settings.toggleVibration(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restore, color: Colors.red),
            title: const Text('Reset All Progress'),
            subtitle: const Text('Clears bookmarks, test results and stats'),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Progress?'),
                  content: const Text('This will permanently delete your quiz history, bookmarks and stats.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Reset', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await settings.resetAllProgress();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Progress reset')),
                  );
                }
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }
}
