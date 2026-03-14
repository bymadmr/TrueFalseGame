import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildSettingTile(
              context,
              title: 'Ses Efektleri',
              subtitle: 'Doğru ve yanlış cevap sesleri',
              icon: Icons.volume_up_rounded,
              value: context.watch<GameProvider>().isSoundEnabled,
              onChanged: (val) => context.read<GameProvider>().toggleSound(),
            ),
            const SizedBox(height: 16),
            _buildSettingTile(
              context,
              title: 'Arka Plan Müziği',
              subtitle: 'Oyun sırasında çalan müzik',
              icon: Icons.music_note_rounded,
              value: context.watch<GameProvider>().isMusicEnabled,
              onChanged: (val) => context.read<GameProvider>().toggleMusic(),
            ),
            const Spacer(),
            const Text(
              'Versiyon 1.0.0',
              style: TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
