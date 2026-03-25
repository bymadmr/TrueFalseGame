import 'dart:io';
import 'package:flutter/foundation.dart';

class AdConstants {
  static const String admobAppId = 'NULL_ADMOB_APP_ID';

  // Kaç soruda bir interstitial gösterileceği
  static const int interstitialFrequency = 5;

  static String get bannerAdUnitId {
    if (kReleaseMode) {
      // !!! DİKKAT: KENDİ BANNER REKLAM KİMLİĞİNİZİ AŞAĞIYA YAPIŞTIRIN !!!
      return Platform.isAndroid 
          ? 'NULL_BANNER_AD_UNIT_ID' // Android Banner Reklam ID'si buraya
          : 'NULL_IOS_BANNER_AD_UNIT_ID'; // iOS Banner Reklam ID'si buraya
    }
    // Bunlar Google'ın Test ID'leridir, ellemeyin.
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
  }

  static String get interstitialAdUnitId {
    if (kReleaseMode) {
      // !!! DİKKAT: UYGULAMAYI YAYINLAMADAN ÖNCE KENDİ GEÇİŞ (INTERSTITIAL) REKLAM KİMLİĞİNİZİ AŞAĞIYA YAPIŞTIRIN !!!
      return Platform.isAndroid 
          ? 'NULL_ANDROID_INTERSTITIAL_AD_UNIT_ID' // Android Geçiş Reklamı ID'si buraya
          : 'NULL_IOS_INTERSTITIAL_AD_UNIT_ID'; // iOS Geçiş Reklamı ID'si buraya
    }
    // Bunlar Google'ın Test ID'leridir, ellemeyin.
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/4411468910';
  }
}
