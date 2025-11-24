import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class CelebrationDialog extends StatefulWidget {
  final String message;

  const CelebrationDialog({
    super.key,
    this.message = '잘했어요!',
  });

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<String> _celebrationEmojis = ['🎉', '🎊', '✨', '🌟', '💪', '👏', '🏆'];

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

  Future<void> _startCelebration() async {
    // 진동 패턴 (팡파레 느낌)
    try {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        // 짧은 진동 3번 (축하 느낌)
        Vibration.vibrate(pattern: [0, 100, 100, 100, 100, 200], intensities: [0, 255, 0, 255, 0, 255]);
      }
    } catch (e) {
      debugPrint('Vibration error: $e');
    }

    // 팡파레 소리 재생
    try {
      await _audioPlayer.play(AssetSource('sounds/fanfare.mp3'));
    } catch (e) {
      debugPrint('Sound error: $e');
    }

    // 컨페티 시작
    _confettiController.play();

    // 애니메이션 시작
    _animationController.forward();

    // 2.5초 후 자동 종료
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  String get _randomEmoji {
    return _celebrationEmojis[Random().nextInt(_celebrationEmojis.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 컨페티 - 중앙에서 발사
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.purple,
                Colors.pink,
              ],
              numberOfParticles: 20,
              maxBlastForce: 40,
              minBlastForce: 15,
              emissionFrequency: 0.08,
              gravity: 0.3,
            ),
          ),

          // 축하 메시지 카드
          ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _randomEmoji,
                      style: const TextStyle(fontSize: 50),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.message,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '목표 달성을 향해 한 걸음 더!',
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

/// 축하 다이얼로그를 표시하는 함수
Future<void> showCelebration(BuildContext context, {String? message}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black38,
    builder: (context) => CelebrationDialog(
      message: message ?? '잘했어요!',
    ),
  );
}
