import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/badge.dart' as app_badge;
import '../providers/database_provider.dart';

// All badges provider - database_provider의 badgeService 사용
final allBadgesProvider = FutureProvider<List<app_badge.Badge>>((ref) async {
  final service = await ref.watch(badgeServiceProvider.future);
  return service.getAllBadgesWithStatus();
});

class AchievementsView extends ConsumerWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(allBadgesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('업적'),
      ),
      body: badgesAsync.when(
        data: (badges) => _buildContent(context, ref, badges),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('오류: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<app_badge.Badge> badges) {
    final unlockedBadges = badges.where((b) => b.isUnlocked).toList();

    // Group badges by category
    final streakBadges = badges.where((b) =>
        b.type.name.startsWith('streak')).toList();
    final goalBadges = badges.where((b) =>
        b.type.name.startsWith('goals') ||
        b.type == app_badge.BadgeType.firstGoal ||
        b.type == app_badge.BadgeType.firstComplete).toList();
    final taskBadges = badges.where((b) =>
        b.type.name.startsWith('tasks') ||
        b.type == app_badge.BadgeType.firstTask).toList();
    final specialBadges = badges.where((b) =>
        b.type == app_badge.BadgeType.earlyBird ||
        b.type == app_badge.BadgeType.nightOwl ||
        b.type == app_badge.BadgeType.perfectWeek ||
        b.type == app_badge.BadgeType.perfectMonth).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress card
          _buildProgressCard(context, unlockedBadges.length, badges.length),
          const SizedBox(height: 24),

          // Unlocked badges section
          if (unlockedBadges.isNotEmpty) ...[
            _buildSectionHeader(context, '획득한 배지', unlockedBadges.length),
            const SizedBox(height: 12),
            _buildBadgeGrid(context, unlockedBadges),
            const SizedBox(height: 24),
          ],

          // Streak badges
          _buildSectionHeader(context, '연속 달성', streakBadges.where((b) => b.isUnlocked).length, streakBadges.length),
          const SizedBox(height: 12),
          _buildBadgeGrid(context, streakBadges),
          const SizedBox(height: 24),

          // Goal badges
          _buildSectionHeader(context, '목표 달성', goalBadges.where((b) => b.isUnlocked).length, goalBadges.length),
          const SizedBox(height: 12),
          _buildBadgeGrid(context, goalBadges),
          const SizedBox(height: 24),

          // Task badges
          _buildSectionHeader(context, '할일 완료', taskBadges.where((b) => b.isUnlocked).length, taskBadges.length),
          const SizedBox(height: 12),
          _buildBadgeGrid(context, taskBadges),
          const SizedBox(height: 24),

          // Special badges
          _buildSectionHeader(context, '특별 배지', specialBadges.where((b) => b.isUnlocked).length, specialBadges.length),
          const SizedBox(height: 12),
          _buildBadgeGrid(context, specialBadges),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, int unlocked, int total) {
    final progress = total > 0 ? unlocked / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '업적 진행률',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$unlocked / $total',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% 완료',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, [int? unlocked, int? total]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (unlocked != null && total != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$unlocked / $total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildBadgeGrid(BuildContext context, List<app_badge.Badge> badges) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        return _BadgeItem(badge: badges[index]);
      },
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final app_badge.Badge badge;

  const _BadgeItem({required this.badge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBadgeDetails(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: badge.isUnlocked
                  ? badge.color.withValues(alpha: 0.2)
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(
                color: badge.isUnlocked ? badge.color : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: badge.isUnlocked
                  ? [
                      BoxShadow(
                        color: badge.color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              badge.icon,
              color: badge.isUnlocked ? badge.color : Colors.grey.shade400,
              size: 24,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              badge.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: badge.isUnlocked ? null : Colors.grey,
                    fontWeight: badge.isUnlocked ? FontWeight.w500 : null,
                    fontSize: 11,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showBadgeDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? badge.color.withValues(alpha: 0.2)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge.icon,
                color: badge.isUnlocked ? badge.color : Colors.grey,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              badge.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? Colors.green.shade100
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge.isUnlocked ? '획득 완료' : '미획득',
                style: TextStyle(
                  color: badge.isUnlocked
                      ? Colors.green.shade700
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
