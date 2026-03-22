import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../main.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> _facts = [
    "Ispanağın içindeki demir miktarı aslında sanılandan daha azdır.",
    "Altın balıkların hafızası 3 saniye değil, yaklaşık 3 aydır.",
    "Boğalar kırmızı renge değil, pelerinin hareketine saldırır.",
    "İnsanlar beyinlerinin sadece %10'unu kullanmaz, neredeyse tamamını kullanır.",
    "Bukalemunlar renklerini sadece kamuflaj için değil, duygularını göstermek için de değiştirir.",
  ];
  late String _currentFact;

  @override
  void initState() {
    super.initState();
    _currentFact = (_facts..shuffle()).first;
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<GameProvider>().initGame();
    if (!mounted) return;
    
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Pulse(
              infinite: true,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/images/splash_logo.png',
                width: 180,
                height: 180,
              ),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: const Text(
                'DOĞRU MU?\nYANLIŞ MI?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "BİLİYOR MUYDUNUZ?",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    duration: const Duration(seconds: 1),
                    child: Text(
                      _currentFact,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
