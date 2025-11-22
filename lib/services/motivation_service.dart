import 'dart:math';
import '../data/models/motivation_message.dart';
import '../data/models/enums.dart';

class MotivationService {
  static final MotivationService _instance = MotivationService._internal();
  factory MotivationService() => _instance;
  MotivationService._internal();

  final Random _random = Random();

  // 기본 동기부여 메시지 목록
  static const List<Map<String, dynamic>> defaultMessages = [
    // 목표 설정 관련
    {
      'message': '큰 목표도 작은 발걸음에서 시작됩니다.',
      'author': '공자',
      'category': 'goal',
    },
    {
      'message': '목표가 없는 삶은 방향 없는 배와 같습니다.',
      'author': '토마스 칼라일',
      'category': 'goal',
    },
    {
      'message': '꿈을 크게 가지세요. 작은 꿈에는 사람의 마음을 움직이는 힘이 없습니다.',
      'author': '괴테',
      'category': 'goal',
    },

    // 꾸준함 관련
    {
      'message': '오늘 할 수 있는 일을 내일로 미루지 마라.',
      'author': '벤자민 프랭클린',
      'category': 'persistence',
    },
    {
      'message': '천 리 길도 한 걸음부터.',
      'author': '노자',
      'category': 'persistence',
    },
    {
      'message': '작은 실천이 큰 변화를 만듭니다.',
      'author': null,
      'category': 'persistence',
    },
    {
      'message': '매일 조금씩, 그것이 성공의 비결입니다.',
      'author': null,
      'category': 'persistence',
    },
    {
      'message': '포기하지 않는 한, 실패는 없습니다.',
      'author': null,
      'category': 'persistence',
    },

    // 성공 관련
    {
      'message': '성공은 최종 목적지가 아니라 여행입니다.',
      'author': '지그 지글러',
      'category': 'success',
    },
    {
      'message': '성공의 비결은 시작하는 것입니다.',
      'author': '마크 트웨인',
      'category': 'success',
    },
    {
      'message': '오늘의 노력이 내일의 성공을 만듭니다.',
      'author': null,
      'category': 'success',
    },

    // 긍정적 마인드
    {
      'message': '할 수 있다고 믿으면 이미 반은 이룬 것입니다.',
      'author': '시어도어 루즈벨트',
      'category': 'positive',
    },
    {
      'message': '당신은 생각보다 강합니다.',
      'author': null,
      'category': 'positive',
    },
    {
      'message': '오늘도 최선을 다하는 당신은 멋집니다.',
      'author': null,
      'category': 'positive',
    },
    {
      'message': '어제의 나보다 나은 오늘의 나를 만들어 가세요.',
      'author': null,
      'category': 'positive',
    },

    // 도전 관련
    {
      'message': '실패는 성공의 어머니입니다.',
      'author': '토마스 에디슨',
      'category': 'challenge',
    },
    {
      'message': '도전하지 않으면 아무것도 변하지 않습니다.',
      'author': null,
      'category': 'challenge',
    },
    {
      'message': '불가능은 도전하지 않는 자의 변명입니다.',
      'author': null,
      'category': 'challenge',
    },

    // 시간 관리
    {
      'message': '시간은 가장 공평한 자원입니다. 어떻게 쓰느냐가 중요합니다.',
      'author': null,
      'category': 'time',
    },
    {
      'message': '지금 이 순간이 가장 좋은 시작점입니다.',
      'author': null,
      'category': 'time',
    },

    // 자기계발
    {
      'message': '배움에는 끝이 없습니다.',
      'author': null,
      'category': 'growth',
    },
    {
      'message': '성장은 comfort zone 밖에서 일어납니다.',
      'author': null,
      'category': 'growth',
    },
    {
      'message': '오늘 배운 것이 내일의 나를 만듭니다.',
      'author': null,
      'category': 'growth',
    },

    // 습관 관련
    {
      'message': '좋은 습관은 최고의 투자입니다.',
      'author': null,
      'category': 'habit',
    },
    {
      'message': '21일이면 습관이 됩니다. 오늘도 화이팅!',
      'author': null,
      'category': 'habit',
    },
    {
      'message': '작은 습관이 인생을 바꿉니다.',
      'author': '제임스 클리어',
      'category': 'habit',
    },
  ];

  // 연속 달성 축하 메시지
  static const List<String> streakMessages = [
    '3일 연속 달성! 좋은 시작이에요!',
    '7일 연속 달성! 일주일을 완벽하게 보냈어요!',
    '14일 연속 달성! 2주 동안 꾸준히 노력했어요!',
    '21일 연속 달성! 이제 습관이 되었어요!',
    '30일 연속 달성! 한 달의 기적을 만들었어요!',
    '50일 연속 달성! 대단해요!',
    '100일 연속 달성! 놀라운 성과입니다!',
  ];

  // 진행률 축하 메시지
  static Map<int, String> progressMessages = {
    25: '목표의 25%를 달성했어요! 좋은 출발이에요!',
    50: '절반을 달성했어요! 끝이 보이기 시작합니다!',
    75: '75% 달성! 거의 다 왔어요!',
    100: '축하합니다! 목표를 달성했어요! 🎉',
  };

  // 랜덤 동기부여 메시지 가져오기
  MotivationMessage getRandomMessage() {
    final message = defaultMessages[_random.nextInt(defaultMessages.length)];
    return MotivationMessage(
      id: 'default_${DateTime.now().millisecondsSinceEpoch}',
      message: message['message'] as String,
      type: MotivationType.encouragement,
      author: message['author'] as String?,
      category: message['category'] as String,
      isCustom: false,
      createdAt: DateTime.now(),
    );
  }

  // 카테고리별 메시지 가져오기
  MotivationMessage getMessageByCategory(String category) {
    final categoryMessages = defaultMessages
        .where((m) => m['category'] == category)
        .toList();

    if (categoryMessages.isEmpty) {
      return getRandomMessage();
    }

    final message = categoryMessages[_random.nextInt(categoryMessages.length)];
    return MotivationMessage(
      id: 'default_${DateTime.now().millisecondsSinceEpoch}',
      message: message['message'] as String,
      type: MotivationType.encouragement,
      author: message['author'] as String?,
      category: message['category'] as String,
      isCustom: false,
      createdAt: DateTime.now(),
    );
  }

  // 오늘의 메시지 (날짜 기반으로 일관된 메시지)
  MotivationMessage getTodayMessage() {
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year, 1, 1)).inDays;
    final index = dayOfYear % defaultMessages.length;

    final message = defaultMessages[index];
    return MotivationMessage(
      id: 'today_${today.year}_$dayOfYear',
      message: message['message'] as String,
      type: MotivationType.encouragement,
      author: message['author'] as String?,
      category: message['category'] as String,
      isCustom: false,
      createdAt: today,
    );
  }

  // 연속 달성 메시지 가져오기
  String? getStreakMessage(int streakDays) {
    if (streakDays >= 100) return streakMessages[6];
    if (streakDays >= 50) return streakMessages[5];
    if (streakDays >= 30) return streakMessages[4];
    if (streakDays >= 21) return streakMessages[3];
    if (streakDays >= 14) return streakMessages[2];
    if (streakDays >= 7) return streakMessages[1];
    if (streakDays >= 3) return streakMessages[0];
    return null;
  }

  // 진행률 메시지 가져오기
  String? getProgressMessage(int progress) {
    if (progress >= 100) return progressMessages[100];
    if (progress >= 75) return progressMessages[75];
    if (progress >= 50) return progressMessages[50];
    if (progress >= 25) return progressMessages[25];
    return null;
  }

  // 시간대별 인사 메시지
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '늦은 밤에도 열심히 하시네요!';
    if (hour < 12) return '좋은 아침이에요!';
    if (hour < 18) return '활기찬 오후 보내세요!';
    return '좋은 저녁이에요!';
  }

  // 완료 축하 메시지
  List<String> getCompletionMessages() {
    return [
      '잘했어요! 👏',
      '멋져요! ⭐',
      '훌륭해요! 🌟',
      '최고예요! 🏆',
      '대단해요! 💪',
      '완벽해요! ✨',
    ];
  }

  String getRandomCompletionMessage() {
    final messages = getCompletionMessages();
    return messages[_random.nextInt(messages.length)];
  }
}
