# 🧠 Doğru mu Yanlış mı?

Test your knowledge with this interactive and fun "True or False" quiz game! Explore 100+ fascinating facts across various categories, challenge your streak, and learn new things every day.

---

## ✨ Özellikler (Features)

- **📚 100+ İlginç Bilgi:** Bilim, Tarih, İnsan Vücudu ve Pop Kültür gibi kategorilerde özenle seçilmiş bilgiler.
- **🔥 Seri (Streak) Sistemi:** Üst üste doğru cevaplar vererek serinizi artırın ve rekorunuzu kırın.
- **❤️ Can Mekaniği:** 3 canınız var! Yanlış cevaplarda can kaybedersiniz, dikkatli olun.
- **⏲️ Geri Sayım:** Her soru için sınırlı süreniz var. Hızlı düşünün, doğru karar verin!
- **🎵 Ses ve Animasyonlar:**
  - `audioplayers` ile zengin oyun atmosferi.
  - `animate_do` ile akıcı mikro-animasyonlar.
  - `confetti` ile kazanma anlarını kutlayın.
- **📊 İstatistikler:** Toplam oynanan oyun ve en yüksek skorunuzu takip edin.

---

## 🛠️ Teknik Altyapı (Tech Stack)

Bu proje Flutter framework'ü kullanılarak geliştirilmiştir.

- **State Management:** [Provider](https://pub.dev/packages/provider)
- **Animasyonlar:** [Animate_do](https://pub.dev/packages/animate_do) & [Confetti](https://pub.dev/packages/confetti)
- **Ses:** [Audioplayers](https://pub.dev/packages/audioplayers)
- **Veri Saklama:** [Shared Preferences](https://pub.dev/packages/shared_preferences) (İstatistikler ve Ayarlar için)
- **Tasarım:** Modern UI/UX, [Google Fonts (Inter & Outfit)](https://fonts.google.com/)

---

## 🚀 Başlangıç (Getting Started)

Projeyi yerel makinenizde çalıştırmak için:

1.  **Depoyu Klonlayın:**
    ```bash
    git clone https://github.com/your-username/testgame.git
    ```
2.  **Bağımlılıkları Yükleyin:**
    ```bash
    flutter pub get
    ```
3.  **Uygulamayı Çalıştırın:**
    ```bash
    flutter run
    ```

---

## 📂 Proje Yapısı

- `lib/screens/`: Splash, Home, Game, Settings ve Stats ekranları.
- `lib/models/`: Soru ve Oyun modelleri.
- `lib/services/`: Veri yükleme ve ses işlemleri.
- `assets/data/`: 100+ soruyu içeren `questions.json` dosyası.
- `assets/audio/`: Oyun içi ses efektleri ve müzikler.

---

## 🎨 Tasarım Anlayışı

Uygulama, kullanıcıda **premium** bir his uyandırmak için cam morfit (glassmorphism) etkileri, yumuşak geçişler ve canlı renkler kullanılarak tasarlanmıştır.

---
Developed with ❤️ by Antigravity & Emre
