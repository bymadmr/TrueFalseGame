import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../constants/app_colors.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NASIL OYNANIR?'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModeSection(
              title: 'KLASİK MOD',
              icon: Icons.flash_on_rounded,
              color: Colors.amber,
              rules: [
                'Her soru için tam 15 saniye süreniz var.',
                'Süre biterse veya yanlış cevap verirseniz 1 can kaybedersiniz.',
                'Toplam 3 canınız bittiğinde oyun sona erer.',
              ],
            ),
            const SizedBox(height: 32),
            _buildModeSection(
              title: 'ZAMANA KARŞI',
              icon: Icons.timer_rounded,
              color: Colors.blue,
              rules: [
                'Sınırsız canınız var! Tek rakibiniz zaman.',
                'Doğru cevap verdiğinizde süreniz 2 saniye artar.',
                'Yanlış cevap verdiğinizde süreniz 3 saniye azalır.',
                'Süre tamamen bittiğinde oyun sona erer.',
              ],
            ),
            const SizedBox(height: 32),
            _buildModeSection(
              title: 'SONSUZ MOD',
              icon: Icons.all_inclusive_rounded,
              color: Colors.purpleAccent,
              rules: [
                'Ölene kadar devam edin! Soru sınırı yok.',
                'Toplam 3 canınız var.',
                'Üst üste 3 doğru cevap (seri) yaptığınızda +1 can kazanırsınız.',
                'Maksimum can sayınız 3 olabilir.',
              ],
            ),
            const SizedBox(height: 48),
            Center(
              child: FadeInUp(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'ANLADIM, BAŞLAYALIM!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> rules,
  }) {
    return FadeInLeft(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
            ),
            child: Column(
              children: rules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.grey, fontSize: 18)),
                    Expanded(
                      child: Text(
                        rule,
                        style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
