import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../constants/app_colors.dart';
import '../models/question.dart';

class AnswerOverlay extends StatelessWidget {
  final bool isCorrect;
  final Question question;
  final VoidCallback onNext;

  const AnswerOverlay({
    super.key,
    required this.isCorrect,
    required this.question,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.85),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(
            child: Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: isCorrect ? AppColors.correct : AppColors.wrong,
              size: 100,
            ),
          ),
          const SizedBox(height: 16),
          FadeIn(
            child: Text(
              isCorrect ? 'HARİKA!' : 'ÜZGÜNÜZ...',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isCorrect ? AppColors.correct : AppColors.wrong,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    'NEDEN ${question.cevap ? "DOĞRU" : "YANLIŞ"}?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.aciklama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: onNext,
                child: const Text(
                  'SONRAKİ SORU',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
