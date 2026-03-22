# 🛠️ TrueFalseGame — Antigravity Uygulama Talimatları

> Bu doküman uygulamanın Play Store'a hazır hale getirilmesi için yapılması gereken
> tüm teknik adımları içermektedir. AdMob ID'leri şu an placeholder olarak bırakılmıştır,
> hesap oluşturulduktan sonra ayrıca iletilecektir.

---

## 1. AdMob Entegrasyonu

### pubspec.yaml
```yaml
dependencies:
  google_mobile_ads: ^5.1.0
```

### AndroidManifest.xml
`android/app/src/main/AndroidManifest.xml` dosyasına `<application>` tagı içine ekle:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="NULL_ADMOB_APP_ID"/>
```

### lib/constants/ad_constants.dart
Tüm reklam ID'lerini tek bir dosyada topla:
```dart
class AdConstants {
  // TODO: AdMob hesabı oluşturulduktan sonra bu değerler güncellenecek
  static const String admobAppId = 'NULL_ADMOB_APP_ID';
  static const String bannerAdUnitId = 'NULL_BANNER_AD_UNIT_ID';
  static const String interstitialAdUnitId = 'NULL_INTERSTITIAL_AD_UNIT_ID';

  // Test ID'leri — geliştirme sırasında bunları kullan
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  // Kaç soruda bir interstitial gösterileceği
  static const int interstitialFrequency = 5;
}
```

> ⚠️ Geliştirme ve test sürecinde `testBannerAdUnitId` ve `testInterstitialAdUnitId`
> kullanılsın. Gerçek ID'ler yalnızca production build'de aktif olacak.

### lib/services/ad_service.dart
Reklam servisini merkezi bir yapıda kur:
```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/ad_constants.dart';

class AdService {
  static BannerAd? bannerAd;
  static InterstitialAd? interstitialAd;
  static bool isBannerLoaded = false;
  static int _questionCounter = 0;

  // AdMob başlatma — main.dart'ta çağrılacak
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // Banner reklam yükle
  static void loadBannerAd(Function onLoaded) {
    bannerAd = BannerAd(
      adUnitId: AdConstants.testBannerAdUnitId, // TODO: production'da bannerAdUnitId kullan
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
      adUnitId: AdConstants.testInterstitialAdUnitId, // TODO: production'da interstitialAdUnitId kullan
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
```

### main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize(); // AdMob başlat
  runApp(const MyApp());
}
```

### Oyun Ekranı — Banner Reklam Yerleşimi
Oyun ekranının en altına banner reklam widget'ı ekle:
```dart
if (AdService.isBannerLoaded && AdService.bannerAd != null)
  SizedBox(
    height: AdService.bannerAd!.size.height.toDouble(),
    child: AdWidget(ad: AdService.bannerAd!),
  ),
```

### Oyun Ekranı — Interstitial Tetikleme
Her soru cevaplandığında çağrılacak:
```dart
AdService.onQuestionAnswered();
```

---

## 2. Uygulama İkonu

### pubspec.yaml'a ekle:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.1

flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#0D1117"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"
```

### Gereksinimler:
- `assets/images/app_icon.png` → 512x512 px, mevcut dark/mor tema ile uyumlu
- `assets/images/app_icon_foreground.png` → Adaptive icon için ön plan görseli
- Arka plan rengi: `#0D1117` (mevcut dark theme rengi)

### Çalıştırma komutu:
```bash
flutter pub run flutter_launcher_icons
```

---

## 3. Native Splash Screen

### pubspec.yaml'a ekle:
```yaml
dev_dependencies:
  flutter_native_splash: ^2.4.0

flutter_native_splash:
  color: "#0D1117"
  image: assets/images/splash_logo.png
  android: true
  ios: false
  android_12:
    color: "#0D1117"
    image: assets/images/splash_logo.png
```

### Gereksinimler:
- `assets/images/splash_logo.png` → Merkeze yerleşecek logo/ikon
- Arka plan: `#0D1117`

### Çalıştırma komutu:
```bash
dart run flutter_native_splash:create
```

---

## 4. Bug Düzeltmeleri

### 4.1 Sonsuz Modda Süre Sayacı
Oyun ekranında süre sayacı yalnızca `Zamana Karşı` modu seçiliyken görünsün:
```dart
if (gameMode == GameMode.timeAttack)
  CircularCountDownTimer(...)
```

### 4.2 Joker Butonu Açıklaması
İlk kullanımda `SharedPreferences` ile kontrol et, daha önce gösterilmediyse tooltip göster:
```dart
// İlk açılışta joker açıklaması göster
final prefs = await SharedPreferences.getInstance();
final jokerShown = prefs.getBool('joker_tooltip_shown') ?? false;
if (!jokerShown) {
  // Tooltip/dialog göster
  await prefs.setBool('joker_tooltip_shown', true);
}
```

### 4.3 Soru Kartı Dinamik Yükseklik
Sabit yükseklik yerine içeriğe göre genişleyen kart kullan:
```dart
Container(
  constraints: const BoxConstraints(
    minHeight: 200,
    maxHeight: 400,
  ),
  // Kart içeriği
)
```

---

## 5. Versiyon Yönetimi

### pubspec.yaml:
```yaml
version: 1.0.0+1
# format: versiyon_adı+versiyon_kodu
# Her Play Store güncellemesinde versiyon_kodu +1 artırılmalı
# Örnek: 1.0.1+2, 1.0.2+3 ...
```

---

## 6. Release Build Ayarları

### android/app/build.gradle:
```gradle
android {
    ...
    signingConfigs {
        release {
            storeFile file("truefalsegame.keystore")
            storePassword System.getenv("KEYSTORE_PASSWORD")
            keyAlias "truefalsegame"
            keyPassword System.getenv("KEY_PASSWORD")
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### AAB Üretme:
```bash
flutter build appbundle --release
```
Çıktı: `build/app/outputs/bundle/release/app-release.aab`

> 🔴 `truefalsegame.keystore` dosyası GitHub'a yüklenmemeli, `.gitignore`'a ekli olduğundan emin ol.

---

## 7. AdMob Hesabı Gelince Yapılacaklar

AdMob hesabı oluşturulup ID'ler alındıktan sonra yalnızca şu iki dosya güncellenecek:

### AndroidManifest.xml:
```xml
<!-- NULL_ADMOB_APP_ID → Gerçek App ID ile değiştirilecek -->
android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"
```

### lib/constants/ad_constants.dart:
```dart
// NULL değerler gerçek ID'lerle değiştirilecek
static const String admobAppId = 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';
static const String bannerAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
static const String interstitialAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
```

> Test ID'lerinden gerçek ID'lere geçmek için `AdService.dart` içindeki
> `testBannerAdUnitId` → `bannerAdUnitId` ve
> `testInterstitialAdUnitId` → `interstitialAdUnitId` olarak güncelle.

---

## 📋 Kontrol Listesi

### Şimdi Yapılacaklar:
- [ ] `google_mobile_ads` paketi eklendi (NULL ID'lerle)
- [ ] `AdService` oluşturuldu, `main.dart`'a bağlandı
- [ ] Banner reklam oyun ekranına yerleştirildi (test ID ile)
- [ ] Interstitial her 5 soruda tetikleniyor (test ID ile)
- [ ] Uygulama ikonu özelleştirildi
- [ ] Native splash screen eklendi
- [ ] Sonsuz modda sayaç düzeltildi
- [ ] Joker tooltip eklendi
- [ ] Soru kartı dinamik yükseklik yapıldı
- [ ] Versiyon yönetimi ayarlandı
- [ ] Release build ayarları yapıldı

### AdMob Hesabı Sonrası:
- [ ] `NULL_ADMOB_APP_ID` gerçek App ID ile güncellendi
- [ ] `NULL_BANNER_AD_UNIT_ID` gerçek ID ile güncellendi
- [ ] `NULL_INTERSTITIAL_AD_UNIT_ID` gerçek ID ile güncellendi
- [ ] Test ID'lerinden production ID'lerine geçildi
- [ ] Gerçek cihazda reklamlar test edildi
- [ ] `flutter build appbundle --release` hatasız çalıştı
- [ ] AAB Play Console'a yüklendi

---

*Hazırlayan: Claude (Anthropic) — Emre ile birlikte*
