import 'package:flutter/material.dart';

enum BadgeType {
  // 시작 관련 배지
  firstGoal,      // 첫 목표 설정
  firstTask,      // 첫 할일 완료
  firstComplete,  // 첫 목표 달성

  // 연속 달성 배지
  streak3,        // 3일 연속
  streak7,        // 7일 연속
  streak14,       // 14일 연속
  streak21,       // 21일 연속
  streak30,       // 30일 연속
  streak50,       // 50일 연속
  streak100,      // 100일 연속

  // 목표 달성 배지
  goals3,         // 3개 목표 달성
  goals5,         // 5개 목표 달성
  goals10,        // 10개 목표 달성
  goals25,        // 25개 목표 달성
  goals50,        // 50개 목표 달성

  // 할일 완료 배지
  tasks10,        // 10개 할일 완료
  tasks50,        // 50개 할일 완료
  tasks100,       // 100개 할일 완료
  tasks500,       // 500개 할일 완료
  tasks1000,      // 1000개 할일 완료

  // 특별 배지
  earlyBird,      // 아침 일찍 할일 완료 (6시 이전)
  nightOwl,       // 밤늦게 할일 완료 (자정 이후)
  perfectWeek,    // 일주일 모든 할일 완료
  perfectMonth,   // 한 달 모든 할일 완료
}

class Badge {
  final BadgeType type;
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Badge({
    required this.type,
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Badge copyWith({
    BadgeType? type,
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Badge(
      type: type ?? this.type,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'id': id,
      'name': name,
      'description': description,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}

// 모든 배지 정의
class BadgeDefinitions {
  static List<Badge> getAllBadges() {
    return [
      // 시작 관련 배지
      const Badge(
        type: BadgeType.firstGoal,
        id: 'first_goal',
        name: '첫 발걸음',
        description: '첫 번째 목표를 설정했습니다',
        icon: Icons.flag,
        color: Colors.green,
      ),
      const Badge(
        type: BadgeType.firstTask,
        id: 'first_task',
        name: '실천가',
        description: '첫 번째 할일을 완료했습니다',
        icon: Icons.check_circle,
        color: Colors.blue,
      ),
      const Badge(
        type: BadgeType.firstComplete,
        id: 'first_complete',
        name: '성취자',
        description: '첫 번째 목표를 달성했습니다',
        icon: Icons.emoji_events,
        color: Colors.amber,
      ),

      // 연속 달성 배지
      const Badge(
        type: BadgeType.streak3,
        id: 'streak_3',
        name: '3일 연속',
        description: '3일 연속으로 할일을 완료했습니다',
        icon: Icons.local_fire_department,
        color: Colors.orange,
      ),
      const Badge(
        type: BadgeType.streak7,
        id: 'streak_7',
        name: '일주일 연속',
        description: '7일 연속으로 할일을 완료했습니다',
        icon: Icons.local_fire_department,
        color: Colors.deepOrange,
      ),
      const Badge(
        type: BadgeType.streak14,
        id: 'streak_14',
        name: '2주 연속',
        description: '14일 연속으로 할일을 완료했습니다',
        icon: Icons.local_fire_department,
        color: Colors.red,
      ),
      const Badge(
        type: BadgeType.streak21,
        id: 'streak_21',
        name: '습관 형성',
        description: '21일 연속으로 할일을 완료했습니다',
        icon: Icons.psychology,
        color: Colors.purple,
      ),
      const Badge(
        type: BadgeType.streak30,
        id: 'streak_30',
        name: '한 달의 기적',
        description: '30일 연속으로 할일을 완료했습니다',
        icon: Icons.stars,
        color: Colors.indigo,
      ),
      const Badge(
        type: BadgeType.streak50,
        id: 'streak_50',
        name: '철인',
        description: '50일 연속으로 할일을 완료했습니다',
        icon: Icons.military_tech,
        color: Colors.teal,
      ),
      const Badge(
        type: BadgeType.streak100,
        id: 'streak_100',
        name: '전설',
        description: '100일 연속으로 할일을 완료했습니다',
        icon: Icons.workspace_premium,
        color: Colors.amber,
      ),

      // 목표 달성 배지
      const Badge(
        type: BadgeType.goals3,
        id: 'goals_3',
        name: '목표 달성 3회',
        description: '3개의 목표를 달성했습니다',
        icon: Icons.flag,
        color: Colors.green,
      ),
      const Badge(
        type: BadgeType.goals5,
        id: 'goals_5',
        name: '목표 달성 5회',
        description: '5개의 목표를 달성했습니다',
        icon: Icons.flag,
        color: Colors.lightGreen,
      ),
      const Badge(
        type: BadgeType.goals10,
        id: 'goals_10',
        name: '목표 달성 10회',
        description: '10개의 목표를 달성했습니다',
        icon: Icons.flag,
        color: Colors.teal,
      ),
      const Badge(
        type: BadgeType.goals25,
        id: 'goals_25',
        name: '목표 달성 25회',
        description: '25개의 목표를 달성했습니다',
        icon: Icons.flag,
        color: Colors.blue,
      ),
      const Badge(
        type: BadgeType.goals50,
        id: 'goals_50',
        name: '목표 달성 50회',
        description: '50개의 목표를 달성했습니다',
        icon: Icons.flag,
        color: Colors.purple,
      ),

      // 할일 완료 배지
      const Badge(
        type: BadgeType.tasks10,
        id: 'tasks_10',
        name: '할일 10개 완료',
        description: '총 10개의 할일을 완료했습니다',
        icon: Icons.task_alt,
        color: Colors.green,
      ),
      const Badge(
        type: BadgeType.tasks50,
        id: 'tasks_50',
        name: '할일 50개 완료',
        description: '총 50개의 할일을 완료했습니다',
        icon: Icons.task_alt,
        color: Colors.lightGreen,
      ),
      const Badge(
        type: BadgeType.tasks100,
        id: 'tasks_100',
        name: '할일 100개 완료',
        description: '총 100개의 할일을 완료했습니다',
        icon: Icons.task_alt,
        color: Colors.teal,
      ),
      const Badge(
        type: BadgeType.tasks500,
        id: 'tasks_500',
        name: '할일 500개 완료',
        description: '총 500개의 할일을 완료했습니다',
        icon: Icons.task_alt,
        color: Colors.blue,
      ),
      const Badge(
        type: BadgeType.tasks1000,
        id: 'tasks_1000',
        name: '할일 1000개 완료',
        description: '총 1000개의 할일을 완료했습니다',
        icon: Icons.task_alt,
        color: Colors.purple,
      ),

      // 특별 배지
      const Badge(
        type: BadgeType.earlyBird,
        id: 'early_bird',
        name: '얼리버드',
        description: '아침 6시 이전에 할일을 완료했습니다',
        icon: Icons.wb_sunny,
        color: Colors.orange,
      ),
      const Badge(
        type: BadgeType.nightOwl,
        id: 'night_owl',
        name: '올빼미',
        description: '자정 이후에 할일을 완료했습니다',
        icon: Icons.nightlight_round,
        color: Colors.indigo,
      ),
      const Badge(
        type: BadgeType.perfectWeek,
        id: 'perfect_week',
        name: '완벽한 일주일',
        description: '일주일 동안 모든 할일을 완료했습니다',
        icon: Icons.calendar_today,
        color: Colors.cyan,
      ),
      const Badge(
        type: BadgeType.perfectMonth,
        id: 'perfect_month',
        name: '완벽한 한 달',
        description: '한 달 동안 모든 할일을 완료했습니다',
        icon: Icons.calendar_month,
        color: Colors.deepPurple,
      ),
    ];
  }

  static Badge? getBadgeByType(BadgeType type) {
    try {
      return getAllBadges().firstWhere((b) => b.type == type);
    } catch (e) {
      return null;
    }
  }

  static Badge? getBadgeById(String id) {
    try {
      return getAllBadges().firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }
}
