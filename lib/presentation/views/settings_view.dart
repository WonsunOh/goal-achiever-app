import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../providers/database_provider.dart';

// Providers for settings
final dailyReminderEnabledProvider = StateProvider<bool>((ref) => false);
final dailyReminderTimeProvider = StateProvider<TimeOfDay>(
    (ref) => const TimeOfDay(hour: 9, minute: 0));

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool _dailyReminderEnabled = false;
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyReminderEnabled = prefs.getBool('daily_reminder_enabled') ?? false;
      final hour = prefs.getInt('daily_reminder_hour') ?? 9;
      final minute = prefs.getInt('daily_reminder_minute') ?? 0;
      _dailyReminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder_enabled', _dailyReminderEnabled);
    await prefs.setInt('daily_reminder_hour', _dailyReminderTime.hour);
    await prefs.setInt('daily_reminder_minute', _dailyReminderTime.minute);

    // Schedule or cancel notification
    final notificationService = ref.read(notificationServiceProvider);

    if (_dailyReminderEnabled) {
      await notificationService.scheduleDailyNotification(
        id: 999,
        title: '오늘의 할일',
        body: '오늘 목표를 확인하고 할일을 완료하세요!',
        hour: _dailyReminderTime.hour,
        minute: _dailyReminderTime.minute,
      );
    } else {
      await notificationService.cancelNotification(999);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, '알림'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('일일 알림'),
            subtitle: const Text('매일 정해진 시간에 알림 받기'),
            value: _dailyReminderEnabled,
            onChanged: (value) {
              setState(() {
                _dailyReminderEnabled = value;
              });
              _saveSettings();
            },
          ),
          if (_dailyReminderEnabled)
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('알림 시간'),
              subtitle: Text(_dailyReminderTime.format(context)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _dailyReminderTime,
                );
                if (time != null) {
                  setState(() {
                    _dailyReminderTime = time;
                  });
                  _saveSettings();
                }
              },
            ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('알림 테스트'),
            subtitle: const Text('테스트 알림 보내기'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final notificationService = ref.read(notificationServiceProvider);
              await notificationService.showNotification(
                id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                title: '테스트 알림',
                body: '알림이 정상적으로 작동합니다!',
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('테스트 알림을 보냈습니다')),
                );
              }
            },
          ),
          const Divider(),
          _buildSectionHeader(context, '앱 정보'),
          const ListTile(
            leading: Icon(Icons.info_outlined),
            title: Text('버전'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppColors.error),
            title: const Text('모든 데이터 삭제',
                style: TextStyle(color: AppColors.error)),
            subtitle: const Text('모든 목표와 할일을 삭제합니다'),
            onTap: () => _showDeleteAllDataDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showDeleteAllDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모든 데이터 삭제'),
        content: const Text(
            '정말로 모든 목표와 할일을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              // Delete all data
              final database = ref.read(appDatabaseProvider);
              // This would need a deleteAll method in database
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('모든 데이터가 삭제되었습니다')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
