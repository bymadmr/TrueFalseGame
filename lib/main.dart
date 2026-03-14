import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';
import 'screens/splash_screen.dart';
import 'services/data_service.dart';
import 'models/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const DogruYanlisApp(),
    ),
  );
}

class DogruYanlisApp extends StatelessWidget {
  const DogruYanlisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doğru mu Yanlış mı?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class GameProvider with ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _streak = 0;
  int _correctAnswers = 0;
  int _totalAnswered = 0;
  int _questionsSinceLastAd = 0;
  bool _isLoading = true;
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = true;

  List<Question> get questions => _questions;
  Question? get currentQuestion => _questions.isNotEmpty ? _questions[_currentIndex] : null;
  int get streak => _streak;
  int get correctAnswers => _correctAnswers;
  int get totalAnswered => _totalAnswered;
  bool get isLoading => _isLoading;
  bool get shouldShowInterstitial => _questionsSinceLastAd >= 5;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isMusicEnabled => _isMusicEnabled;

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    _saveSettings();
    notifyListeners();
  }

  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', _isSoundEnabled);
    await prefs.setBool('music', _isMusicEnabled);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundEnabled = prefs.getBool('sound') ?? true;
    _isMusicEnabled = prefs.getBool('music') ?? true;
    notifyListeners();
  }

  Future<void> initGame() async {
    _questions = await DataService.loadQuestions();
    _questions.shuffle();
    await _loadSettings();
    _isLoading = false;
    notifyListeners();
  }

  void answer(bool userAnswer) {
    if (currentQuestion == null) return;
    
    bool isCorrect = userAnswer == currentQuestion!.cevap;
    _totalAnswered++;
    _questionsSinceLastAd++;
    
    if (isCorrect) {
      _correctAnswers++;
      _streak++;
    } else {
      _streak = 0;
    }
    notifyListeners();
  }

  void resetAdCounter() {
    _questionsSinceLastAd = 0;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
      _questions.shuffle();
    }
    notifyListeners();
  }
}
