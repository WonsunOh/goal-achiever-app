import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/badge.dart';

class BadgeService {
  static final BadgeService _instance = BadgeService._internal();
  factory BadgeService() => _instance;
  BadgeService._internal();

  static const String _unlockedBadgesKey = 'unlocked_badges';
  static const String _statsKey = 'badge_stats';

  // 통계 데이터
  Map<String, dynamic> _stats = {
    'totalGoalsCreated': 0,
    'totalGoalsCompleted': 0,
    'totalTasksCompleted': 0,
    'currentStreak': 0,
    'maxStreak': 0,
    'earlyBirdCount': 0,
    'nightOwlCount': 0,
    'perfectWeeks': 0,
    'perfectMonths': 0,
  };

  Set<String> _unlockedBadgeIds = {};

  // 초기화
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // 해금된 배지 로드
    final unlockedJson = prefs.getStringList(_unlockedBadgesKey) ?? [];
    _unlockedBadgeIds = unlockedJson.toSet();

    // 통계 로드
    final statsJson = prefs.getString(_statsKey);
    if (statsJson != null) {
      _stats = Map<String, dynamic>.from(jsonDecode(statsJson));
    }
  }

  // 통계 저장
  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(_stats));
  }

  // 배지 해금 저장
  Future<void> _saveUnlockedBadges() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_unlockedBadgesKey, _unlockedBadgeIds.toList());
  }

  // 배지 해금
  Future<Badge?> unlockBadge(BadgeType type) async {
    final badge = BadgeDefinitions.getBadgeByType(type);
    if (badge == null) return null;

    if (_unlockedBadgeIds.contains(badge.id)) {
      return null; // 이미 해금됨
    }

    _unlockedBadgeIds.add(badge.id);
    await _saveUnlockedBadges();

    return badge.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );
  }

  // 배지 해금 여부 확인
  bool isBadgeUnlocked(BadgeType type) {
    final badge = BadgeDefinitions.getBadgeByType(type);
    return badge != null && _unlockedBadgeIds.contains(badge.id);
  }

  // 모든 배지 가져오기 (해금 상태 포함)
  List<Badge> getAllBadgesWithStatus() {
    return BadgeDefinitions.getAllBadges().map((badge) {
      final isUnlocked = _unlockedBadgeIds.contains(badge.id);
      return badge.copyWith(isUnlocked: isUnlocked);
    }).toList();
  }

  // 해금된 배지만 가져오기
  List<Badge> getUnlockedBadges() {
    return getAllBadgesWithStatus().where((b) => b.isUnlocked).toList();
  }

  // 목표 생성 시 체크
  Future<Badge?> onGoalCreated() async {
    _stats['totalGoalsCreated'] = (_stats['totalGoalsCreated'] ?? 0) + 1;
    await _saveStats();

    if (_stats['totalGoalsCreated'] == 1) {
      return await unlockBadge(BadgeType.firstGoal);
    }
    return null;
  }

  // 목표 완료 시 체크
  Future<List<Badge>> onGoalCompleted() async {
    _stats['totalGoalsCompleted'] = (_stats['totalGoalsCompleted'] ?? 0) + 1;
    await _saveStats();

    final unlockedBadges = <Badge>[];
    final completed = _stats['totalGoalsCompleted'] as int;

    // 첫 목표 달성
    if (completed == 1) {
      final badge = await unlockBadge(BadgeType.firstComplete);
      if (badge != null) unlockedBadges.add(badge);
    }

    // 목표 달성 횟수별 배지
    if (completed >= 3 && !isBadgeUnlocked(BadgeType.goals3)) {
      final badge = await unlockBadge(BadgeType.goals3);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (completed >= 5 && !isBadgeUnlocked(BadgeType.goals5)) {
      final badge = await unlockBadge(BadgeType.goals5);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (completed >= 10 && !isBadgeUnlocked(BadgeType.goals10)) {
      final badge = await unlockBadge(BadgeType.goals10);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (completed >= 25 && !isBadgeUnlocked(BadgeType.goals25)) {
      final badge = await unlockBadge(BadgeType.goals25);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (completed >= 50 && !isBadgeUnlocked(BadgeType.goals50)) {
      final badge = await unlockBadge(BadgeType.goals50);
      if (badge != null) unlockedBadges.add(badge);
    }

    return unlockedBadges;
  }

  // 할일 완료 시 체크
  Future<List<Badge>> onTaskCompleted() async {
    _stats['totalTasksCompleted'] = (_stats['totalTasksCompleted'] ?? 0) + 1;
    await _saveStats();

    final unlockedBadges = <Badge>[];
    final completed = _stats['totalTasksCompleted'] as int;

    // 첫 할일 완료
    if (completed == 1) {
      final badge = await unlockBadge(BadgeType.firstTask);
      if (badge != null) unlockedBadges.add(badge);
    }

    // 할일 완료 횟수별 배지
    if (completed >= 10 && !isBadgeUnlocked(BadgeType.tasks10)) {
      final badge = await unlockBadge(BadgeType.tasks10);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (completed >= 50 && !isBadgeUnlocked(BadgeType.tasks50)) {
      final badge = await unlockBadge(BadgeType.tasks50);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (completed >= 100 && !isBadgeUnlocked(BadgeType.tasks100)) {
      final badge = await unlockBadge(BadgeType.tasks100);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (completed >= 500 && !isBadgeUnlocked(BadgeType.tasks500)) {
      final badge = await unlockBadge(BadgeType.tasks500);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (completed >= 1000 && !isBadgeUnlocked(BadgeType.tasks1000)) {
      final badge = await unlockBadge(BadgeType.tasks1000);
      if (badge != null) unlockedBadges.add(badge);
    }

    // 시간대별 배지
    final now = DateTime.now();
    if (now.hour < 6) {
      final badge = await unlockBadge(BadgeType.earlyBird);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (now.hour >= 0 && now.hour < 4) {
      final badge = await unlockBadge(BadgeType.nightOwl);
      if (badge != null) unlockedBadges.add(badge);
    }

    return unlockedBadges;
  }

  // 연속 달성 업데이트
  Future<List<Badge>> onStreakUpdated(int streak) async {
    _stats['currentStreak'] = streak;
    if (streak > (_stats['maxStreak'] ?? 0)) {
      _stats['maxStreak'] = streak;
    }
    await _saveStats();

    final unlockedBadges = <Badge>[];

    if (streak >= 3 && !isBadgeUnlocked(BadgeType.streak3)) {
      final badge = await unlockBadge(BadgeType.streak3);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (streak >= 7 && !isBadgeUnlocked(BadgeType.streak7)) {
      final badge = await unlockBadge(BadgeType.streak7);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (streak >= 14 && !isBadgeUnlocked(BadgeType.streak14)) {
      final badge = await unlockBadge(BadgeType.streak14);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (streak >= 21 && !isBadgeUnlocked(BadgeType.streak21)) {
      final badge = await unlockBadge(BadgeType.streak21);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (streak >= 30 && !isBadgeUnlocked(BadgeType.streak30)) {
      final badge = await unlockBadge(BadgeType.streak30);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (streak >= 50 && !isBadgeUnlocked(BadgeType.streak50)) {
      final badge = await unlockBadge(BadgeType.streak50);
      if (badge != null) unlockedBadges.add(badge);
    }
    if (streak >= 100 && !isBadgeUnlocked(BadgeType.streak100)) {
      final badge = await unlockBadge(BadgeType.streak100);
      if (badge != null) unlockedBadges.add(badge);
    }

    return unlockedBadges;
  }

  // 완벽한 일주일 체크
  Future<Badge?> onPerfectWeek() async {
    _stats['perfectWeeks'] = (_stats['perfectWeeks'] ?? 0) + 1;
    await _saveStats();
    return await unlockBadge(BadgeType.perfectWeek);
  }

  // 완벽한 한 달 체크
  Future<Badge?> onPerfectMonth() async {
    _stats['perfectMonths'] = (_stats['perfectMonths'] ?? 0) + 1;
    await _saveStats();
    return await unlockBadge(BadgeType.perfectMonth);
  }

  // 통계 가져오기
  Map<String, dynamic> getStats() => Map.from(_stats);

  // 해금된 배지 수
  int getUnlockedCount() => _unlockedBadgeIds.length;

  // 전체 배지 수
  int getTotalCount() => BadgeDefinitions.getAllBadges().length;

  // 진행률 (퍼센트)
  double getProgress() {
    final total = getTotalCount();
    if (total == 0) return 0;
    return getUnlockedCount() / total;
  }
}
