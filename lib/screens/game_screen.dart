import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../main.dart';
import '../widgets/answer_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _confettiController;
  late CountDownController _timerController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  
  bool _showOverlay = false;
  bool _lastResultCorrect = false;
  bool _isMusicIntense = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _timerController = CountDownController();
    _startMusic();
  }

  Future<void> _startMusic() async {
    if (!mounted) return;
    if (context.read<GameProvider>().isMusicEnabled) {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(AssetSource('audio/background_music.mp3'));
    }
  }

  void _updateMusicPlaybackRate(double rate) {
    if (context.read<GameProvider>().isMusicEnabled) {
      _musicPlayer.setPlaybackRate(rate);
    }
  }

  Future<void> _playSound(bool isCorrect) async {
    if (context.read<GameProvider>().isSoundEnabled) {
      final source = isCorrect ? 'audio/correct.mp3' : 'audio/wrong.mp3';
      await _audioPlayer.play(AssetSource(source));
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    _musicPlayer.dispose();
    super.dispose();
  }

  void _handleAnswer(bool userAnswer) {
    if (_showOverlay) return;

    final provider = context.read<GameProvider>();
    if (provider.selectedMode != 'Zamana Karşı') {
      _timerController.pause();
    }

    bool isCorrect = userAnswer == provider.currentQuestion!.cevap;
    
    // Get current time for bonus
    int timeLeft = int.tryParse(_timerController.getTime() ?? "15") ?? 15;

    provider.answer(userAnswer, timeLeft: timeLeft);
    _playSound(isCorrect);

    if (!isCorrect) {
      HapticFeedback.heavyImpact(); // Haptic feedback recommendation
    }

    if (isCorrect && provider.streak >= 5) {
      _confettiController.play();
    }

    setState(() {
      _lastResultCorrect = isCorrect;
      _showOverlay = true;
    });
  }

  void _nextQuestion() {
    final provider = context.read<GameProvider>();
    if (provider.isGameOver) {
      Navigator.pop(context); // Go back home or show final stats
      return;
    }

    setState(() {
      _showOverlay = false;
      _isMusicIntense = false;
    });
    _updateMusicPlaybackRate(1.0);
    provider.nextQuestion();
    if (provider.selectedMode != 'Zamana Karşı') {
      _timerController.restart();
    } else {
      _timerController.resume();
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'bilim': return Colors.blue;
      case 'tarih': return const Color(0xFFFFD700); // Gold
      case 'insan vücudu': return Colors.pinkAccent;
      case 'pop kültür': return Colors.purpleAccent;
      case 'güncel': return Colors.teal;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final question = provider.currentQuestion;

    if (question == null || provider.isGameOver) {
      if (provider.isGameOver && !_showOverlay) {
        // This handles cases where game ends between questions
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showGameOverDialog(provider);
        });
      }
      if (question == null && !provider.isGameOver) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    }

    final categoryColor = question != null ? _getCategoryColor(question.kategori) : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                index < provider.lives ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: index < provider.lives ? Colors.red : Colors.grey,
              ),
            );
          }),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${provider.score} 🏆',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${provider.streak} 🔥 Streak', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${provider.totalAnswered}/${provider.maxQuestions} 📝', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                CircularCountDownTimer(
                  duration: provider.selectedMode == 'Zamana Karşı' ? provider.timeLimit : 15,
                  initialDuration: 0,
                  controller: _timerController,
                  width: 60,
                  height: 60,
                  ringColor: AppColors.surface,
                  fillColor: _isMusicIntense ? Colors.red : categoryColor,
                  backgroundColor: Colors.transparent,
                  strokeWidth: 8.0,
                  strokeCap: StrokeCap.round,
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: _isMusicIntense ? Colors.red : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textFormat: CountdownTextFormat.S,
                  isReverse: true,
                  isReverseAnimation: true,
                  isTimerTextShown: true,
                  autoStart: true,
                  onComplete: () {
                    if (!_showOverlay) {
                      if (provider.selectedMode == 'Zamana Karşı') {
                        provider.answer(!provider.currentQuestion!.cevap); // Time's up for whole game? No, handle answer as wrong
                      } else {
                        _handleAnswer(!provider.currentQuestion!.cevap);
                      }
                    }
                  },
                  onChange: (String timeStamp) {
                    int time = int.tryParse(timeStamp) ?? provider.timeLimit;
                    int warningTime = provider.selectedMode == 'Zamana Karşı' ? 10 : 5;
                    if (time <= warningTime && !_isMusicIntense) {
                      setState(() => _isMusicIntense = true);
                      _updateMusicPlaybackRate(1.5);
                    }
                  },
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: provider.totalAnswered / provider.maxQuestions,
                  backgroundColor: AppColors.surface,
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: FadeInRight(
                    key: ValueKey(question?.id ?? 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              question?.kategori.toUpperCase() ?? "",
                              style: TextStyle(
                                color: categoryColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            question?.ifade ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        label: 'DOĞRU',
                        icon: Icons.check_rounded,
                        color: AppColors.correct,
                        onTap: () => _handleAnswer(true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        IconButton.filled(
                          onPressed: provider.jokerUsed ? null : () => provider.useJoker(),
                          icon: const Icon(Icons.bolt_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: provider.jokerUsed ? Colors.grey : Colors.amber,
                            minimumSize: const Size(56, 56),
                          ),
                        ),
                        const Text("Joker", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        label: 'YANLIŞ',
                        icon: Icons.close_rounded,
                        color: AppColors.wrong,
                        onTap: () => _handleAnswer(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                categoryColor,
                AppColors.correct,
                AppColors.secondary,
                Colors.yellow,
              ],
            ),
          ),
          if (_showOverlay && question != null)
            AnswerOverlay(
              isCorrect: _lastResultCorrect,
              isGameOver: provider.isGameOver,
              question: question,
              onNext: _nextQuestion,
            ),
        ],
      ),
    );
  }

  void _showGameOverDialog(GameProvider provider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => FadeInUp(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'OYUN BİTTİ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    '${provider.score}',
                    style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900),
                  ),
                  const Text('Toplam Skor', style: TextStyle(color: AppColors.grey)),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniStat('Doğru', '${provider.correctAnswers}'),
                      _buildMiniStat('En Yüksek', '${provider.highScore}'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Dialog
                        Navigator.pop(context); // Game Screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text(
                        'ANA MENÜYE DÖN',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Dialog
                      provider.startGame(
                        provider.maxQuestions,
                        category: provider.selectedCategory,
                        mode: provider.selectedMode,
                      );
                      setState(() {
                        _showOverlay = false;
                        _isMusicIntense = false;
                      });
                      _timerController.restart();
                    },
                    child: const Text('TEKRAR DENE', style: TextStyle(color: AppColors.grey)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
