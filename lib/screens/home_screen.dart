import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../main.dart';
import 'game_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'how_to_play_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCount = 10;
  int _selectedDuration = 60;
  String _selectedCategory = 'Hepsi';
  String _selectedMode = 'Klasik';

  final List<int> _durations = [60, 90, 120, 180];

  final List<String> _categories = ['Hepsi', 'Bilim', 'Tarih', 'İnsan Vücudu', 'Pop Kültür', 'Güncel'];
  final List<Map<String, dynamic>> _modes = [
    {'name': 'Klasik', 'desc': 'Sınırlı Soru', 'icon': Icons.flash_on_rounded},
    {'name': 'Zamana Karşı', 'desc': '60 Saniye', 'icon': Icons.timer_rounded},
    {'name': 'Sonsuz', 'desc': 'Ölene Kadar', 'icon': Icons.all_inclusive_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hoş Geldin! 👋',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.settings_rounded),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.help_outline_rounded, color: AppColors.primary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HowToPlayScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.bar_chart_rounded),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StatsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      FadeInLeft(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.surface],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Hedef Soru', '$_selectedCount', Icons.quiz_outlined),
                      _buildStatItem('Son Skor', '${provider.score}', Icons.history_rounded),
                      _buildStatItem('En Yüksek', '${provider.highScore}', Icons.workspace_premium_rounded),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInRight(
                delay: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Soru Sayısı Seç',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.grey),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [10, 25, 50, 100, 250].map((count) {
                          bool isSelected = _selectedCount == count;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildChoiceChip(
                              label: count.toString(),
                              isSelected: isSelected,
                              onTap: () => setState(() => _selectedCount = count),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              FadeInLeft(
                delay: const Duration(milliseconds: 350),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kategori Seç',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.grey),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((cat) {
                          bool isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildChoiceChip(
                              label: cat,
                              isSelected: isSelected,
                              onTap: () => setState(() => _selectedCategory = cat),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Oyun Modu',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: _modes.map((mode) {
                        bool isSelected = _selectedMode == mode['name'];
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: mode == _modes.last ? 0 : 12),
                            child: _buildModeCard(
                              title: mode['name'],
                              desc: mode['desc'],
                              icon: mode['icon'],
                              isSelected: isSelected,
                              onTap: () => setState(() => _selectedMode = mode['name']),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              if (_selectedMode == 'Zamana Karşı')
                FadeInUp(
                  delay: const Duration(milliseconds: 450),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Süre Seç (Saniye)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.grey),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _durations.map((dur) {
                              bool isSelected = _selectedDuration == dur;
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: _buildChoiceChip(
                                  label: '$dur sn',
                                  isSelected: isSelected,
                                  onTap: () => setState(() => _selectedDuration = dur),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    onPressed: () {
                      provider.startGame(
                        _selectedCount, 
                        category: _selectedCategory, 
                        mode: _selectedMode,
                        timeLimit: _selectedDuration,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameScreen()),
                      );
                    },
                    child: const Text(
                      'OYUNU BAŞLAT',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary.withValues(alpha: 0.5), size: 24),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.grey, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildChoiceChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String desc,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.grey, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper for rounded corners
class RoundedRectangleAtMost extends RoundedRectangleBorder {
  const RoundedRectangleAtMost({super.borderRadius});
}
