import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CelebrationOverlay extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onDismiss;
  final bool showConfetti;

  const CelebrationOverlay({
    super.key,
    required this.title,
    required this.message,
    required this.onDismiss,
    this.icon = Icons.celebration,
    this.iconColor = Colors.amber,
    this.showConfetti = true,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Scale animation for the card
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeIn,
    );

    // Confetti animation
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    if (widget.showConfetti) {
      _generateConfetti();
      _confettiController.repeat();
    }

    _scaleController.forward();
  }

  void _generateConfetti() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];

    for (int i = 0; i < 50; i++) {
      _particles.add(ConfettiParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble() * -1,
        color: colors[_random.nextInt(colors.length)],
        size: _random.nextDouble() * 8 + 4,
        speed: _random.nextDouble() * 2 + 1,
        rotation: _random.nextDouble() * 360,
        rotationSpeed: _random.nextDouble() * 10 - 5,
      ));
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background overlay
          GestureDetector(
            onTap: widget.onDismiss,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),

          // Confetti
          if (widget.showConfetti)
            AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: ConfettiPainter(
                    particles: _particles,
                    progress: _confettiController.value,
                  ),
                );
              },
            ),

          // Celebration card
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: widget.iconColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated icon
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.5 + (value * 0.5),
                          child: Transform.rotate(
                            angle: (1 - value) * 0.5,
                            child: Icon(
                              widget.icon,
                              size: 80,
                              color: widget.iconColor,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Message
                    Text(
                      widget.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Close button
                    ElevatedButton(
                      onPressed: widget.onDismiss,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('확인'),
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

class ConfettiParticle {
  double x;
  double y;
  final Color color;
  final double size;
  final double speed;
  double rotation;
  final double rotationSpeed;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final y = (particle.y + progress * particle.speed * 2) % 1.5 - 0.5;
      final x = particle.x + sin(progress * 10 + particle.rotation) * 0.05;

      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x * size.width, y * size.height);
      canvas.rotate((particle.rotation + progress * particle.rotationSpeed * 20) * pi / 180);

      // Draw confetti shape (rectangle)
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 0.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Badge unlock celebration
class BadgeUnlockOverlay extends StatelessWidget {
  final String badgeName;
  final String badgeDescription;
  final IconData badgeIcon;
  final Color badgeColor;
  final VoidCallback onDismiss;

  const BadgeUnlockOverlay({
    super.key,
    required this.badgeName,
    required this.badgeDescription,
    required this.badgeIcon,
    required this.badgeColor,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return CelebrationOverlay(
      title: '배지 획득!',
      message: '$badgeName\n$badgeDescription',
      icon: badgeIcon,
      iconColor: badgeColor,
      onDismiss: onDismiss,
      showConfetti: true,
    );
  }
}

// Goal completion celebration
class GoalCompletionOverlay extends StatelessWidget {
  final String goalTitle;
  final VoidCallback onDismiss;

  const GoalCompletionOverlay({
    super.key,
    required this.goalTitle,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return CelebrationOverlay(
      title: '목표 달성!',
      message: '"$goalTitle"\n목표를 달성했습니다!\n축하합니다!',
      icon: Icons.emoji_events,
      iconColor: Colors.amber,
      onDismiss: onDismiss,
      showConfetti: true,
    );
  }
}

// Streak celebration
class StreakCelebrationOverlay extends StatelessWidget {
  final int streakDays;
  final VoidCallback onDismiss;

  const StreakCelebrationOverlay({
    super.key,
    required this.streakDays,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return CelebrationOverlay(
      title: '$streakDays일 연속 달성!',
      message: '대단해요!\n$streakDays일 동안 꾸준히 목표를 향해\n나아가고 있어요!',
      icon: Icons.local_fire_department,
      iconColor: Colors.deepOrange,
      onDismiss: onDismiss,
      showConfetti: true,
    );
  }
}

// Helper function to show celebration
void showCelebration(BuildContext context, Widget overlay) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) => overlay,
  );
}
