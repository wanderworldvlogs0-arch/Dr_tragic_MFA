import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dr_tragic_mfa/core/database/database_helper.dart';
import 'dart:io';

class BackupManager {
  static Future<void> backupDatabase(BuildContext context) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final dbPath = db.path;
      
      final directory = await getApplicationDocumentsDirectory();
      final backupPath = '${directory.path}/dr_tragic_mfa_backup_${DateTime.now().millisecondsSinceEpoch}.db';
      
      await File(dbPath).copy(backupPath);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup saved to: $backupPath')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup failed: $e')),
        );
      }
    }
  }

  static Future<void> restoreDatabase(BuildContext context) async {
    try {
      // This would use file_picker to select backup file
      // Implementation depends on file_picker package
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restore feature coming soon')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
      }
    }
  }
}
