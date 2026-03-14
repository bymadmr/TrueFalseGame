import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
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

    _timerController.pause();
    
    final provider = context.read<GameProvider>();
    bool isCorrect = userAnswer == provider.currentQuestion!.cevap;

    provider.answer(userAnswer);
    _playSound(isCorrect);

    if (isCorrect && provider.streak >= 5) {
      _confettiController.play();
    }

    setState(() {
      _lastResultCorrect = isCorrect;
      _showOverlay = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      _showOverlay = false;
      _isMusicIntense = false;
    });
    _updateMusicPlaybackRate(1.0);
    context.read<GameProvider>().nextQuestion();
    _timerController.restart();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final question = provider.currentQuestion;

    if (question == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text('${provider.streak} 🔥 Streak', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircularCountDownTimer(
                  duration: 15,
                  initialDuration: 0,
                  controller: _timerController,
                  width: 60,
                  height: 60,
                  ringColor: AppColors.surface,
                  fillColor: _isMusicIntense ? Colors.red : AppColors.primary,
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
                  onStart: () {
                    debugPrint('Countdown Started');
                  },
                  onComplete: () {
                    if (!_showOverlay) {
                      _handleAnswer(!provider.currentQuestion!.cevap); // Auto-wrong
                    }
                  },
                  onChange: (String timeStamp) {
                    int time = int.tryParse(timeStamp) ?? 15;
                    if (time <= 5 && !_isMusicIntense) {
                      setState(() => _isMusicIntense = true);
                      _updateMusicPlaybackRate(1.5); // Increase intensity
                    }
                  },
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: (provider.totalAnswered % 10) / 10,
                  backgroundColor: AppColors.surface,
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
                const SizedBox(height: 60),
                Expanded(
                  child: FadeInRight(
                    key: ValueKey(question.id),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
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
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              question.kategori.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            question.ifade,
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
                const SizedBox(height: 60),
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
                    const SizedBox(width: 20),
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
                const SizedBox(height: 40),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.correct,
                AppColors.secondary,
                Colors.yellow,
              ],
            ),
          ),
          if (_showOverlay)
            AnswerOverlay(
              isCorrect: _lastResultCorrect,
              question: question,
              onNext: _nextQuestion,
            ),
        ],
      ),
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
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
