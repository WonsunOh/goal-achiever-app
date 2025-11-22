# Goal Achiever - 목표 달성 앱 개발 계획서

## 📋 프로젝트 개요

**앱 이름**: Goal Achiever (또는 원하시는 이름)
**핵심 기능**: 목표 설정 → 일일 과제 관리 → 알림 → 동기부여 → 달성 추적
**기술 스택**: Flutter + Riverpod + MVVM 패턴

---

## 🏗️ 프로젝트 구조 (MVVM)

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── themes/
│   ├── utils/
│   └── router/
├── data/
│   ├── models/          # 데이터 모델
│   ├── repositories/    # 데이터 접근 계층
│   └── local/          # 로컬 DB (Drift/SQLite)
├── domain/
│   ├── entities/       # 비즈니스 엔티티
│   └── usecases/       # 비즈니스 로직
├── presentation/
│   ├── providers/      # Riverpod providers
│   ├── viewmodels/     # ViewModel
│   ├── views/          # UI 화면
│   └── widgets/        # 재사용 위젯
└── services/
    ├── notification_service.dart
    └── storage_service.dart
```

---

## 📊 데이터 모델 설계

### 1. Goal (목표)
```dart
- id: String
- title: String
- description: String
- category: String (건강, 학습, 재정, 취미 등)
- startDate: DateTime
- targetDate: DateTime
- isCompleted: bool
- progress: double (0.0 ~ 1.0)
- motivationQuote: String
- createdAt: DateTime
```

### 2. DailyTask (일일 과제)
```dart
- id: String
- goalId: String (연결된 목표)
- title: String
- description: String
- scheduledDate: DateTime
- isCompleted: bool
- completedAt: DateTime?
- reminderTime: DateTime?
- priority: enum (High, Medium, Low)
```

### 3. Achievement (성취 기록)
```dart
- id: String
- goalId: String
- achievementDate: DateTime
- note: String
- emoji: String (축하 이모지)
```

### 4. MotivationMessage (동기부여 메시지)
```dart
- id: String
- message: String
- type: enum (Encouragement, Celebration, Reminder)
```

---

## 🎨 주요 화면 설계

### 1. **홈 화면** (Dashboard)
- 오늘의 할 일 목록
- 진행 중인 목표 카드
- 전체 진행률 위젯
- 동기부여 문구

### 2. **목표 관리 화면**
- 전체 목표 리스트
- 목표 추가/수정/삭제
- 카테고리별 필터링
- 진행률 시각화

### 3. **일일 과제 화면**
- 날짜별 과제 캘린더
- 과제 체크리스트
- 과제 추가/수정
- 알림 설정

### 4. **통계 화면**
- 목표 달성률 그래프
- 연속 달성 일수 (Streak)
- 카테고리별 통계
- 월간/주간 리포트

### 5. **설정 화면**
- 알림 설정
- 테마 설정
- 동기부여 메시지 커스터마이징

---

## 🔧 기술 스택 및 패키지

```yaml
dependencies:
  flutter_riverpod: ^2.5.0        # 상태관리
  riverpod_annotation: ^2.3.0     # 코드 생성
  go_router: ^13.0.0              # 라우팅

  # 로컬 저장소 (SQLite)
  drift: ^2.20.3
  sqlite3_flutter_libs: ^0.5.24
  path_provider: ^2.1.4
  path: ^1.9.0

  # 알림
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.0

  # UI
  fl_chart: ^0.66.0               # 차트
  table_calendar: ^3.0.9          # 캘린더
  animations: ^2.0.11             # 애니메이션

  # 유틸리티
  intl: ^0.19.0                   # 날짜 포맷
  uuid: ^4.0.0                    # ID 생성
  freezed_annotation: ^2.4.0      # 불변 모델
  json_annotation: ^4.8.0

dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  drift_dev: ^2.20.3
```

---

## 🔄 Riverpod 상태관리 구조

### Providers 예시:

```dart
// 목표 리스트 Provider
@riverpod
class GoalList extends _$GoalList {
  @override
  Future<List<Goal>> build() async {
    return ref.watch(goalRepositoryProvider).getAllGoals();
  }

  Future<void> addGoal(Goal goal) async { ... }
  Future<void> updateGoal(Goal goal) async { ... }
  Future<void> deleteGoal(String id) async { ... }
}

// 오늘의 과제 Provider
@riverpod
Future<List<DailyTask>> todayTasks(TodayTasksRef ref) async {
  final tasks = await ref.watch(taskRepositoryProvider).getTodayTasks();
  return tasks;
}

// 선택된 목표 Provider
@riverpod
class SelectedGoal extends _$SelectedGoal {
  @override
  Goal? build() => null;

  void select(Goal goal) => state = goal;
  void clear() => state = null;
}
```

---

## 📱 핵심 기능 구현 계획

### Phase 1: 기본 기능 (2-3주)
1. ✅ 프로젝트 초기 설정 및 폴더 구조
2. ✅ 목표 CRUD 기능
3. ✅ 일일 과제 CRUD 기능
4. ✅ 로컬 데이터베이스 설정 (Drift/SQLite)
5. ✅ 기본 UI 구현

### Phase 2: 알림 및 추적 (1-2주)
6. ✅ 로컬 알림 시스템 구현
7. ✅ 과제 완료 체크 및 진행률 계산
8. ✅ 캘린더 뷰 구현
9. ✅ 목표별 진행률 시각화

### Phase 3: 동기부여 기능 (1주)
10. ✅ 동기부여 메시지 시스템
11. ✅ 연속 달성 일수 (Streak) 추적
12. ✅ 성취 배지/이모지 시스템
13. ✅ 축하 애니메이션

### Phase 4: 통계 및 개선 (1주)
14. ✅ 통계 대시보드 (차트)
15. ✅ 주간/월간 리포트
16. ✅ 데이터 백업/복원
17. ✅ 최종 테스트 및 최적화

---

## 💡 동기부여 시스템 아이디어

1. **일일 명언**: 앱 실행 시 랜덤 동기부여 문구
2. **Streak 시스템**: 연속 달성일 추적 및 뱃지
3. **Progress Celebration**: 25%, 50%, 75%, 100% 달성 시 애니메이션
4. **Virtual Rewards**: 목표 달성 시 가상 보상 (스티커, 배지)
5. **리마인더**: "3일 연속 달성 중! 오늘도 화이팅!"

---

## 🎯 MVVM 패턴 적용 예시

### Model (data/models/goal.dart)
```dart
@freezed
class Goal with _$Goal {
  factory Goal({
    required String id,
    required String title,
    required DateTime targetDate,
    @Default(0.0) double progress,
  }) = _Goal;
}
```

### Repository (data/repositories/goal_repository.dart)
```dart
class GoalRepository {
  Future<List<Goal>> getAllGoals() async { ... }
  Future<void> saveGoal(Goal goal) async { ... }
}
```

### ViewModel (presentation/viewmodels/goal_viewmodel.dart)
```dart
@riverpod
class GoalViewModel extends _$GoalViewModel {
  @override
  AsyncValue<List<Goal>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadGoals() async { ... }
  Future<void> createGoal(Goal goal) async { ... }
}
```

### View (presentation/views/goal_list_view.dart)
```dart
class GoalListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalViewModelProvider);

    return goalsAsync.when(
      data: (goals) => ListView(...),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => ErrorWidget(err),
    );
  }
}
```

---

## 🚀 시작하기

### 1. 프로젝트 생성
```bash
flutter create goal_achiever
cd goal_achiever
```

### 2. pubspec.yaml 설정
위의 패키지들을 dependencies에 추가

### 3. 폴더 구조 생성
프로젝트 구조에 맞게 폴더 생성

### 4. 구현 시작
Phase 1부터 순차적으로 구현

---

## 📝 개발 진행 상황 체크리스트

- [ ] Phase 1: 기본 기능
  - [ ] 프로젝트 초기 설정
  - [ ] 폴더 구조 생성
  - [ ] 데이터 모델 작성
  - [ ] Repository 구현
  - [ ] ViewModel 구현
  - [ ] 기본 UI 화면

- [ ] Phase 2: 알림 및 추적
  - [ ] 알림 서비스 구현
  - [ ] 진행률 계산 로직
  - [ ] 캘린더 통합
  - [ ] 진행률 차트

- [ ] Phase 3: 동기부여
  - [ ] 명언 시스템
  - [ ] Streak 추적
  - [ ] 배지 시스템
  - [ ] 애니메이션

- [ ] Phase 4: 통계 및 마무리
  - [ ] 통계 대시보드
  - [ ] 리포트 기능
  - [ ] 백업/복원
  - [ ] 최종 테스트

---

## 🎨 디자인 가이드라인

### 색상 테마
- Primary: 목표 달성을 상징하는 밝고 활기찬 색 (예: 청록색, 보라색)
- Success: 녹색 계열
- Warning: 주황색 계열
- Background: 화이트/다크모드 지원

### 애니메이션
- 과제 완료 시 체크 애니메이션
- 목표 달성 시 축하 애니메이션
- 부드러운 화면 전환

---

**마지막 업데이트**: 2025-11-22
