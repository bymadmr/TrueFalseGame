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
  List<Question> _gameQuestions = [];
  int _currentIndex = 0;
  int _streak = 0;
  int _score = 0;
  int _highScore = 0;
  int _lives = 3;
  int _totalAnswered = 0;
  int _correctAnswers = 0;
  int _questionsSinceLastAd = 0;
  int _maxQuestions = 10;
  bool _isLoading = true;
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = true;
  bool _isGameOver = false;
  bool _jokerUsed = false;
  String _selectedCategory = 'Hepsi';
  String _selectedMode = 'Klasik';
  int _timeLimit = 60; // Total time for Time Attack or per question for Classic

  List<Question> get questions => _gameQuestions;
  List<Question> get allQuestions => _questions;
  String get selectedCategory => _selectedCategory;
  String get selectedMode => _selectedMode;
  int get timeLimit => _timeLimit;
  Question? get currentQuestion => 
    (_gameQuestions.isNotEmpty && _currentIndex < _gameQuestions.length) 
    ? _gameQuestions[_currentIndex] : null;
  int get streak => _streak;
  int get score => _score;
  int get highScore => _highScore;
  int get lives => _lives;
  int get totalAnswered => _totalAnswered;
  int get correctAnswers => _correctAnswers;
  int get maxQuestions => _maxQuestions;
  bool get isLoading => _isLoading;
  bool get isGameOver => _isGameOver;
  bool get jokerUsed => _jokerUsed;
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
    _highScore = prefs.getInt('highScore') ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    if (_score > _highScore) {
      _highScore = _score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', _highScore);
    }
  }

  Future<void> initGame() async {
    _questions = await DataService.loadQuestions();
    await _loadSettings();
    _isLoading = false;
    notifyListeners();
  }

  void startGame(int questionLimit, {String category = 'Hepsi', String mode = 'Klasik', int timeLimit = 60}) {
    _selectedCategory = category;
    _selectedMode = mode;
    _timeLimit = timeLimit;
    
    // Filter questions by category
    List<Question> filtered = category == 'Hepsi' 
      ? List.from(_questions) 
      : _questions.where((q) => q.kategori == category).toList();
      
    filtered.shuffle();
    
    // Ensure we have questions after filtering
    if (filtered.isEmpty) {
      _gameQuestions = [];
      _isGameOver = true;
      notifyListeners();
      return;
    }

    // Apply question limit
    _gameQuestions = (mode == 'Sonsuz') ? filtered : filtered.take(questionLimit).toList();
    _maxQuestions = _gameQuestions.length;
    
    _currentIndex = 0;
    _streak = 0;
    _score = 0;
    _lives = 3;
    _totalAnswered = 0;
    _correctAnswers = 0;
    _isGameOver = false;
    _jokerUsed = false;
    notifyListeners();
  }

  void answer(bool userAnswer, {int timeLeft = 15}) {
    if (currentQuestion == null || _isGameOver) return;
    
    bool isCorrect = userAnswer == currentQuestion!.cevap;
    _totalAnswered++;
    _questionsSinceLastAd++;
    
    if (isCorrect) {
      _score += 10;
      _correctAnswers++;
      // Bonus Score (Flash Speed: < 2 seconds)
      if (timeLeft >= 13) {
        _score += 5;
      }
      _streak++;
    } else {
      _streak = 0;
      _lives--;
      if (_lives <= 0) {
        _isGameOver = true;
        _saveHighScore();
      }
    }

    if (_selectedMode == 'Klasik' && _totalAnswered >= _maxQuestions && !_isGameOver) {
      _isGameOver = true;
      _saveHighScore();
    }

    notifyListeners();
  }

  void useJoker() {
    if (!_jokerUsed && !_isGameOver) {
      _jokerUsed = true;
      _score += 5;
      _correctAnswers++; // Joker automatic correct
      nextQuestion();
    }
  }

  void resetAdCounter() {
    _questionsSinceLastAd = 0;
    notifyListeners();
  }

  void nextQuestion() {
    if (_isGameOver) return;
    
    if (_currentIndex < _gameQuestions.length - 1 && _totalAnswered < _maxQuestions) {
      _currentIndex++;
    } else {
      _isGameOver = true;
      _saveHighScore();
    }
    notifyListeners();
  }
}
