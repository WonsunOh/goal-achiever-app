enum Priority {
  high,
  medium,
  low;

  String get displayName {
    switch (this) {
      case Priority.high:
        return '높음';
      case Priority.medium:
        return '보통';
      case Priority.low:
        return '낮음';
    }
  }
}

enum GoalCategory {
  health,
  learning,
  finance,
  hobby,
  career,
  relationship,
  other;

  String get displayName {
    switch (this) {
      case GoalCategory.health:
        return '건강';
      case GoalCategory.learning:
        return '학습';
      case GoalCategory.finance:
        return '재정';
      case GoalCategory.hobby:
        return '취미';
      case GoalCategory.career:
        return '경력';
      case GoalCategory.relationship:
        return '관계';
      case GoalCategory.other:
        return '기타';
    }
  }

  String get icon {
    switch (this) {
      case GoalCategory.health:
        return '💪';
      case GoalCategory.learning:
        return '📚';
      case GoalCategory.finance:
        return '💰';
      case GoalCategory.hobby:
        return '🎨';
      case GoalCategory.career:
        return '💼';
      case GoalCategory.relationship:
        return '👥';
      case GoalCategory.other:
        return '📌';
    }
  }
}

enum MotivationType {
  encouragement,
  celebration,
  reminder;

  String get displayName {
    switch (this) {
      case MotivationType.encouragement:
        return '격려';
      case MotivationType.celebration:
        return '축하';
      case MotivationType.reminder:
        return '리마인더';
    }
  }
}
