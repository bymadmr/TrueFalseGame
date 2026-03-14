# 📱 Uygulama Spec: Doğru mu, Yanlış mı?

## Genel Bakış

Kullanıcıların bilim, tarih, güncel konular ve pop kültür hakkındaki yaygın yanlış inanışları veya şaşırtıcı gerçekleri test ettiği bir mobil quiz uygulaması. Her soru "Doğru" veya "Yanlış" şeklinde cevaplanır; ardından kısa ve etkileyici bir açıklama gösterilir.

**Platform:** Android (Google Play Store)  
**Gelir Modeli:** Ücretsiz, reklam destekli (AdMob banner + interstitial)  
**Hedef Kitle:** 13–25 yaş arası gençler  
**Dil:** Türkçe (başlangıç), İngilizce (ilerleyen sürümlerde)

---

## Temel Özellikler (MVP)

### 1. Soru Akışı
- Kullanıcı uygulamayı açar ve direkt olarak oyuna başlar, kayıt zorunluluğu yoktur
- Sorular veritabanından rastgele sırayla gelir
- Kullanıcı istediği kadar soru cevaplayabilir, günlük limit yoktur
- Daha önce cevaplanan sorular tekrar gelmez (tüm sorular bitince liste sıfırlanır)

### 2. Soru Yapısı
Her sorunun şu alanları olacak:
```
- id: benzersiz kimlik
- ifade: kullanıcıya gösterilen cümle
- cevap: true / false
- aciklama: cevap sonrası gösterilen kısa açıklama (2–3 cümle, sürükleyici yazılmış)
- kategori: bilim | tarih | güncel | insan-vucudu | pop-kultur
```

**Örnek:**
```
İfade: "Çin Seddi uzaydan çıplak gözle görülebilir."
Cevap: Yanlış
Açıklama: "Bu inanış onlarca yıldır devam eden bir efsane. Astronotlar seddin
            uzaydan seçilemeyecek kadar dar olduğunu bizzat doğruladı.
            Hatta Çinli astronot Yang Liwei de görevde bunu teyit etti."
Kategori: Tarih
```

### 3. Oyun Ekranı (UI)
- Ortada büyük ve net bir şekilde ifade yazısı
- Alt kısımda iki büyük buton: ✅ **DOĞRU** | ❌ YANLIŞ
- Cevap seçilince butonlar kilitlenir
- Doğru cevaba göre ekran yeşil veya kırmızıya döner (anlık feedback)
- Açıklama kutusu aşağıdan kaydırılarak gelir
- "Sonraki Soru" butonu ile devam edilir

### 4. Streak Sistemi
- Kullanıcı art arda doğru cevap verdikçe streak sayacı artar
- Yanlış cevap streak'i sıfırlar
- Ekranda streak sayısı her zaman görünür ("🔥 7 streak")

### 5. Skor & İstatistik
- Oturum bazlı: kaç soru cevaplandı, kaçı doğru
- Uygulama içinde basit bir özet ekranı (istediğinde görebilir)

### 6. Reklamlar
- **Banner reklam:** Soru ekranının alt kısmında sabit
- **Interstitial reklam:** Her 5 soruda bir tam ekran reklam gösterilir
- Kullanıcı deneyimini bozmayacak şekilde konumlandırılacak

---

## Veritabanı & İçerik

- Başlangıçta en az **100 soru** ile çıkılacak
- Sorular kategorilere eşit dağıtılacak (her kategoriden ~20 soru)
- Sorular uygulama içi yerel veritabanında (SQLite veya JSON) tutulacak
- İleride içerik güncellemesi için uzak API'ye bağlanabilir yapı (şimdilik lokal)

### Kategoriler
| Kategori | Açıklama |
|---|---|
| 🔬 Bilim | Fizik, kimya, biyoloji mitler |
| 🏛️ Tarih | Yaygın tarihsel yanlışlar |
| 🧬 İnsan Vücudu | Sağlık ve vücut efsaneleri |
| 🌍 Güncel | Sosyal medya mitleri, modern efsaneler |
| 🎮 Pop Kültür | Filmler, müzik, internet kültürü |

---

## Teknik Gereksinimler

- **Framework:** Flutter (Android öncelikli, iOS ileride eklenebilir)
- **Minimum Android:** API 21 (Android 5.0)
- **Reklam SDK:** Google AdMob
- **Lokal veri:** JSON dosyası veya SQLite
- **State yönetimi:** Provider veya Riverpod

---

## Ekranlar (Screen List)

1. **Splash Screen** — Logo + kısa animasyon
2. **Ana Ekran (Home)** — "Oynamaya Başla" butonu, toplam soru sayısı
3. **Oyun Ekranı** — İfade + Doğru/Yanlış butonları + streak göstergesi
4. **Cevap Ekranı** — Sonuç (doğru/yanlış) + açıklama + sonraki soru butonu
5. **İstatistik Ekranı** — Toplam oynanan, doğru/yanlış oranı (opsiyonel, hamburger menüde)

---

## Gelecekteki Güncellemeler (Şu An Kapsam Dışı)

- Arkadaşlarla haftalık liderboard
- Kategori bazlı oynama modu
- Rozet / başarı sistemi
- Çoklu dil desteği
- Kullanıcı hesabı & bulut senkronizasyon
- Günlük özel soru paketi

---

## Başarı Kriterleri (MVP için)

- Uygulama stabil çalışıyor, çökmüyor
- En az 100 soru sorunsuz yükleniyor
- Reklamlar düzgün gösteriliyor
- Play Store politikalarına uygun (13+ yaş, içerik politikası)
- Kullanıcı bir oturumda 15+ soru oynayabilecek akıcılıkta
