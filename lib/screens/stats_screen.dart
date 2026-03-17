import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../main.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final double accuracy = provider.totalAnswered > 0 
        ? (provider.correctAnswers / provider.totalAnswered) * 100 
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistikler'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            FadeInDown(
              child: _buildStatCard(
                title: 'Başarı Oranı',
                value: '%${accuracy.toStringAsFixed(1)}',
                subtitle: '${provider.correctAnswers} / ${provider.totalAnswered}',
                icon: Icons.percent_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FadeInLeft(
                    child: _buildStatCard(
                      title: 'Doğru',
                      value: '${provider.correctAnswers}',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.correct,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: FadeInRight(
                    child: _buildStatCard(
                      title: 'Yanlış',
                      value: '${provider.totalAnswered - provider.correctAnswers}',
                      icon: Icons.cancel_rounded,
                      color: AppColors.wrong,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FadeInUp(
              child: _buildStatCard(
                title: 'En Yüksek Streak',
                value: '${provider.streak}',
                subtitle: 'Şu anki seriniz',
                icon: Icons.local_fire_department_rounded,
                color: Colors.orange,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('GERİ DÖN'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.grey)),
              Text(
                value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (subtitle != null)
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
