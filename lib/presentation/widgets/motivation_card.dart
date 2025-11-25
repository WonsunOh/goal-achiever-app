import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/motivation_service.dart';
import '../../data/models/motivation_message.dart';

class MotivationCard extends StatefulWidget {
  final bool showGreeting;
  final bool allowRefresh;

  const MotivationCard({
    super.key,
    this.showGreeting = true,
    this.allowRefresh = true,
  });

  @override
  State<MotivationCard> createState() => _MotivationCardState();
}

class _MotivationCardState extends State<MotivationCard>
    with SingleTickerProviderStateMixin {
  final MotivationService _motivationService = MotivationService();
  late MotivationMessage _currentMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _autoRefreshTimer;

  // 자동 변경 간격 (10초)
  static const Duration _autoRefreshInterval = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    _currentMessage = _motivationService.getTodayMessage();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0, // 처음에 완전히 보이게 시작
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 자동 새로고침 타이머 시작
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(_autoRefreshInterval, (_) {
      if (mounted) {
        _refreshMessage();
      }
    });
  }

  void _refreshMessage() async {
    // 이미 애니메이션 중이면 무시
    if (_animationController.isAnimating) return;

    // fade out
    await _animationController.reverse();

    if (!mounted) return;

    setState(() {
      _currentMessage = _motivationService.getRandomMessage();
    });

    // fade in
    await _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with greeting and refresh button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.showGreeting)
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.light_mode,
                        size: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _motivationService.getGreeting(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.allowRefresh)
                IconButton(
                  onPressed: _refreshMessage,
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white70,
                    size: 20,
                  ),
                  tooltip: '새로운 메시지',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Quote
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${_currentMessage.message}"',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                ),
                if (_currentMessage.author != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '- ${_currentMessage.author}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Compact motivation card for smaller spaces
class CompactMotivationCard extends StatelessWidget {
  const CompactMotivationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final motivationService = MotivationService();
    final message = motivationService.getTodayMessage();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontStyle: FontStyle.italic,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Daily tip card
class DailyTipCard extends StatelessWidget {
  final String tip;
  final IconData icon;

  const DailyTipCard({
    super.key,
    required this.tip,
    this.icon = Icons.tips_and_updates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.amber.shade700,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오늘의 팁',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Streak card
class StreakCard extends StatelessWidget {
  final int streakDays;
  final VoidCallback? onTap;

  const StreakCard({
    super.key,
    required this.streakDays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade400,
              Colors.deepOrange.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streakDays일 연속',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    _getStreakMessage(streakDays),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  String _getStreakMessage(int days) {
    if (days >= 100) return '전설이 되어가고 있어요!';
    if (days >= 50) return '대단한 의지력이에요!';
    if (days >= 30) return '한 달의 기적을 이뤘어요!';
    if (days >= 21) return '습관이 형성되고 있어요!';
    if (days >= 14) return '2주 동안 꾸준히!';
    if (days >= 7) return '일주일 완성!';
    if (days >= 3) return '좋은 출발이에요!';
    return '오늘도 화이팅!';
  }
}
