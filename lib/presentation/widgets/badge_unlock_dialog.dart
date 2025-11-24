import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../data/models/badge.dart' as app_badge;

class BadgeUnlockDialog extends StatefulWidget {
  final app_badge.Badge badge;

  const BadgeUnlockDialog({
    super.key,
    required this.badge,
  });

  @override
  State<BadgeUnlockDialog> createState() => _BadgeUnlockDialogState();
}

class _BadgeUnlockDialogState extends State<BadgeUnlockDialog>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _startCelebration();
  }

  void _startCelebration() {
    _confettiController.play();
    _animationController.forward();

    // 3초 후 자동 종료
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 컨페티
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                widget.badge.color,
                widget.badge.color.withValues(alpha: 0.7),
                Colors.yellow,
                Colors.orange,
              ],
              numberOfParticles: 15,
              maxBlastForce: 30,
              minBlastForce: 10,
              emissionFrequency: 0.1,
              gravity: 0.3,
            ),
          ),

          // 배지 카드
          ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: widget.badge.color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 배지 획득 텍스트
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.badge.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '배지 획득!',
                        style: TextStyle(
                          color: widget.badge.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 배지 아이콘
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: widget.badge.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.badge.color,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.badge.color.withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.badge.icon,
                        color: widget.badge.color,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 배지 이름
                    Text(
                      widget.badge.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // 배지 설명
                    Text(
                      widget.badge.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 배지 획득 다이얼로그를 표시하는 함수
Future<void> showBadgeUnlockDialog(BuildContext context, app_badge.Badge badge) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (context) => BadgeUnlockDialog(badge: badge),
  );
}

/// 여러 배지를 순차적으로 표시하는 함수
Future<void> showBadgeUnlockDialogs(BuildContext context, List<app_badge.Badge> badges) async {
  for (final badge in badges) {
    if (context.mounted) {
      await showBadgeUnlockDialog(context, badge);
      // 다음 배지 표시 전 잠시 대기
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }
}
