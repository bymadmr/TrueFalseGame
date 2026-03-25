import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/ad_constants.dart';

class AdService {
  static BannerAd? bannerAd;
  static InterstitialAd? interstitialAd;
  static bool isBannerLoaded = false;
  static int _questionCounter = 0;

  // AdMob başlatma — main.dart'ta çağrılacak
  static Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      loadInterstitialAd(); // İlk yüklemeyi yap
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
    }
  }

  // Banner reklam yükle
  static void loadBannerAd(Function onLoaded) {
    bannerAd = BannerAd(
      adUnitId: AdConstants.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerLoaded = true;
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          isBannerLoaded = false;
        },
      ),
    )..load();
  }

  // Interstitial reklam yükle
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => interstitialAd = ad,
        onAdFailedToLoad: (error) => interstitialAd = null,
      ),
    );
  }

  // Soru sayacını artır, gerekirse interstitial göster
  static void onQuestionAnswered() {
    _questionCounter++;
    if (_questionCounter % AdConstants.interstitialFrequency == 0) {
      showInterstitialAd();
    }
  }

  // Interstitial göster
  static void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd = null;
      loadInterstitialAd(); // Bir sonraki için önceden yükle
    }
  }

  // Temizlik
  static void dispose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
  }
}
