# 🔥 Rage Room — Developer Stress Relief App

> **Gerçek hayatta kıramıyorsan, dijital dünyada kır!**
>
> Rage Room, yazılımcılar için tasarlanmış **fizik tabanlı stres atma uygulamasıdır.** 3 dakikalık yıkım seanslarında sanal nesneleri parçalayın, ardından Zen Modunda nefes alın. Flame + Forge2D fizik motoru, Clean Architecture, Firebase ve RevenueCat ile geliştirilmiştir.

---

## 📑 İçindekiler

- [Özellikler](#-özellikler)
- [Ekranlar](#-ekranlar)
- [Oyun Mekaniği](#-oyun-mekaniği)
- [Materyal Sistemi](#-materyal-sistemi)
- [Rozet & Başarı Sistemi](#-rozet--başarı-sistemi)
- [Mimari (Clean Architecture)](#-mimari-clean-architecture)
- [State Management](#-state-management)
- [Firebase Entegrasyonu](#-firebase-entegrasyonu)
- [Monetizasyon (RevenueCat)](#-monetizasyon-revenuecat)
- [Kullanılan Teknolojiler](#-kullanılan-teknolojiler)
- [Kurulum](#-kurulum)
- [Proje Yapısı](#-proje-yapısı)

---

## ✨ Özellikler

| Özellik | Açıklama |
|---------|----------|
| **Fizik Tabanlı Yıkım** | Forge2D motoru ile gerçekçi kırılma, sıçrama ve parçalanma simülasyonu |
| **3 Dakikalık Seanslar** | Zamanlayıcılı yoğun stres atma oturumları |
| **Zen Modu** | Yıkım sonrası sakinleştirici meditasyon ekranı |
| **4 Farklı Materyal** | Dijital Cam, Porselen Vazo, CRT Monitör, Balonlu Naylon |
| **7 Rozet / Başarı** | Kümülatif kırma sayısına dayalı başarı sistemi |
| **Haptic Feedback** | Her materyale özel dokunsal geri bildirim profilleri |
| **Ses Efektleri** | Materyal bazlı kırılma sesleri |
| **Parçacık Sistemi** | Materyale göre farklı şekillerde (üçgen, çokgen, daire, kare) parçalanma |
| **Google ile Giriş** | İstatistik senkronizasyonu |
| **PRO Abonelik** | Ek materyaller, özel arka plan, gelişmiş efektler |
| **Çevrimdışı Mod** | Firebase olmadan da tam oynanabilirlik |
| **Crash Raporlama** | Firebase Crashlytics entegrasyonu |

---

## 📱 Ekranlar

### 🌊 Splash Screen
- 1.8 saniyelik animasyonlu açılış
- Firebase başlatma (opsiyonel)
- Anonim kimlik doğrulama
- RevenueCat abonelik durumu kontrolü

### 🏠 Home Screen (Ana Menü)
- 2×2 materyal seçim gridi
- PRO materyaller için kilit göstergesi
- İstatistik kartı: toplam kırma, seans sayısı, rozet özeti
- Rozet ve Ayarlar ekranlarına navigasyon

### 💥 Rage Screen (Oyun Ekranı)
- Tam ekran Flame oyun widget'ı (60 FPS)
- Üst overlay: geri butonu, dairesel geri sayım (3 dakika), materyal ikonu
- Alt overlay: kırma sayacı, parça sayacı
- Son 10 saniyede **"SON ŞANS!"** kırmızı uyarı
- Gerçek zamanlı fizik tabanlı yıkım

### 🧘 Zen Screen (Meditasyon)
- Koyu mor tonlarında sakinleştirici arayüz
- **"NEFES AL"** meditasyon mesajı
- Seans özeti: toplam kırma, toplam parça, geçen süre
- Motivasyon metni ve emoji animasyonu
- "Ana Menü" veya "Tekrar Oyna" seçenekleri

### 🏅 Badges Screen (Rozetler)
- 7 başarı rozetinin grid görünümü
- Kilitli (gri + kilit ikonu) / Kazanılmış (vurgulu) durum gösterimi
- Her rozet: emoji, başlık, gerekli kırma sayısı

### ⚙️ Settings Screen (Ayarlar)
- Ses ve haptic açma/kapama
- Parçacık yoğunluğu slider'ı
- Özel arka plan seçici (PRO)
- Google ile giriş (istatistik senkronizasyonu)
- Satın alma geri yükleme
- Hukuki bilgiler

### 💎 Paywall Screen (PRO)
- PRO özellik listesi
- Abonelik paketi seçimi (Aylık / Yıllık / Ömür Boyu)
- Test modunda yerel PRO aktivasyonu

---

## 🎮 Oyun Mekaniği

### Fizik Motoru: Flame + Forge2D

| Parametre | Değer |
|-----------|-------|
| Yerçekimi | -10 birim/sn² |
| Fizik Zoom | 10 (1 birim = 10 piksel) |
| Hedef FPS | 60 |
| Seans Süresi | 180 saniye |

### Etkileşim Akışı

```
Kullanıcı Dokunuşu
  │
  ├─ Nesne Bulundu → Kır!
  │   ├─ Parçaları üret (materyale özgü şekiller)
  │   ├─ Dokunma noktasından radyal impuls uygula
  │   ├─ Haptic feedback tetikle
  │   ├─ RageSessionObjectBroken event yayınla
  │   └─ 800ms sonra yeni nesne spawn et
  │
  └─ Boş Alan → Şok dalgası efekti
      └─ Tüm görünür nesnelere kuvvet uygula
```

### Oyun Bileşenleri

| Bileşen | Görev |
|---------|-------|
| `WorldBoundaries` | Statik kenarlar (zemin, duvarlar, tavan) |
| `BreakableObject` | Dokunulduğunda parçalanan dinamik 2D nesneler |
| `ShardParticle` | Yıkım sonrası fizik tabanlı parçacıklar (8 sn ömür) |
| `BackgroundComponent` | Gradient veya özel görsel arka plan |

### Parçacık Sistemi

Her materyal için farklı parça şekilleri:
- 🪟 **Cam** → Üçgen kırıklar
- 🏺 **Porselen** → Düzensiz çokgen parçalar
- 🖥️ **CRT** → Küçük kareler
- 🫧 **Balonlu Naylon** → Daireler

Parçacık yaşam süresi: **8 saniye** (son 2 saniyede solma efekti)

---

## 🧱 Materyal Sistemi

Dört farklı materyal, her biri kendine özgü fizik parametreleriyle:

| Materyal | Parça | Sıçrama | Sürtünme | Yoğunluk | PRO? | Açıklama |
|----------|-------|---------|----------|----------|------|----------|
| 🪟 Dijital Cam | 18 | 0.3 | 0.2 | 1.2 | ❌ | Hafif, sıçrar, uzağa uçar |
| 🏺 Porselen Vazo | 24 | 0.1 | 0.6 | 2.0 | ✅ | Yapışkan, yakına ufalanır |
| 🖥️ CRT Monitör | 30 | 0.05 | 0.8 | 3.5 | ✅ | Ağır, sıçramaz, düz düşer |
| 🫧 Balonlu Naylon | 40 | 0.6 | 0.1 | 0.3 | ✅ | Süper sıçrar, kaotik hareket |

Materyallerin tam fizik konfigürasyonu `assets/data/materials.json` dosyasında tanımlıdır.

---

## 🏅 Rozet & Başarı Sistemi

Tüm seanslar boyunca **kümülatif toplam kırma** sayısına göre 7 rozet:

| # | Rozet | Koşul |
|---|-------|-------|
| 💥 | **First Rage** | 1+ kırma |
| ⚔️ | **Syntax Error Slayer** | 50+ kırma |
| 🏆 | **Deadline Survivor** | 100+ kırma |
| 🧪 | **TÜBİTAK Warrior** | 200+ kırma |
| 💣 | **Century Destroyer** | 500+ kırma |
| 🧘 | **Zen Master** | Zen modunda 60+ saniye kalma |
| 👑 | **PRO Unlocked** | PRO plan satın alma |

---

## 🏛️ Mimari (Clean Architecture)

Proje, katmanlı **Clean Architecture** prensipleriyle yapılandırılmıştır:

```
┌──────────────────────────────────────────────────┐
│          Presentation Layer (UI)                 │
│   Screens • Widgets • BLoCs • Providers          │
│   Controllers (GetX)                             │
├──────────────────────────────────────────────────┤
│          Domain Layer (İş Mantığı)               │
│   Entities • Repository Arayüzleri • Use Cases   │
├──────────────────────────────────────────────────┤
│          Data Layer (Veri Kaynakları)             │
│   Models • Repository Uygulamaları               │
│   Firebase Source • Local Repository             │
├──────────────────────────────────────────────────┤
│          Game Layer (Oyun Motoru)                 │
│   RageGame (Forge2D) • Components                │
├──────────────────────────────────────────────────┤
│          Core Layer (Altyapı)                    │
│   DI (GetIt) • Services • Network (Dio)          │
│   Constants                                      │
└──────────────────────────────────────────────────┘
```

### Klasör Yapısı

```
lib/
├── main.dart                 # Uygulama giriş noktası
├── app/
│   ├── app.dart              # Root widget, Provider/BLoC/GetX kurulumu
│   ├── routes/               # GetX route tanımları
│   └── theme/                # Rage ve Zen temaları
├── core/
│   ├── constants/            # Sabitler ve konfigürasyon
│   ├── di/                   # GetIt dependency injection
│   ├── network/              # Dio HTTP client
│   └── services/             # Haptic service
├── data/
│   ├── models/               # Firestore modelleri
│   ├── repositories/         # Repository uygulamaları
│   └── sources/              # Firebase veri kaynağı
├── domain/
│   ├── entities/             # RageSession, Badge entity'leri
│   ├── repositories/         # Repository arayüzleri
│   └── usecases/             # StartSession, SaveSession
├── game/
│   ├── rage_game.dart        # Flame/Forge2D oyun sınıfı
│   └── components/           # BreakableObject, ShardParticle, vb.
└── presentation/
    ├── blocs/                # RageSessionBloc, MonetizationCubit
    ├── controllers/          # GetX RageController
    ├── providers/            # MaterialProvider, SettingsProvider
    ├── screens/              # 7 ekran
    └── widgets/              # TimerWidget, BadgeWidget, vb.
```

---

## 🔄 State Management

Proje **hibrit state management** yaklaşımı kullanır:

### 📦 Flutter BLoC — Oyun Oturum Yönetimi

**RageSessionBloc** seans yaşam döngüsünü yönetir:

```
SessionPhase: idle → raging → ending → saving → zen
```

| Event | Açıklama |
|-------|----------|
| `RageSessionStarted` | Seansı başlat, Firestore'da döküman oluştur |
| `RageSessionObjectBroken` | Kırma ve parça sayaçlarını güncelle |
| `RageSessionTimerTicked` | Geri sayımı güncelle, <10s'de "ending" fazı |
| `RageSessionEnded` | Rozetleri hesapla, Firestore'a kaydet, Zen moduna geç |
| `RageSessionReset` | Tüm sayaçları sıfırla |

**MonetizationCubit** abonelik durumunu yönetir:
- `MonetizationFree` / `MonetizationPro` durumları
- Satın alma, geri yükleme, test modu aktivasyonu

### 🔔 Provider (ChangeNotifier) — Ayar ve Tercihler

- **MaterialProvider**: Seçili materyal, ses/haptic toggle, parçacık yoğunluğu
- **SettingsProvider**: Özel arka plan, bildirim, oturum sayısı (SharedPreferences)

### ⚡ GetX — Global Utility Controller

- **RageController**: Observable materyal seçimi, oyun durumu, UI geri bildirim tetikleyicileri

---

## 🔥 Firebase Entegrasyonu

| Servis | Kullanım |
|--------|----------|
| **Firebase Auth** | Anonim giriş + Google Sign-In |
| **Cloud Firestore** | Seans verileri, kullanıcı istatistikleri, rozet takibi |
| **Firebase Crashlytics** | Release modda hata yakalama ve raporlama |

### Firestore Şeması

```
/users/{uid}
  ├── totalBreaks: int              (atomik artış)
  └── /sessions/{sessionId}
        ├── userId: string
        ├── startedAt: Timestamp
        ├── endedAt: Timestamp?
        ├── materialTypeIndex: int
        ├── totalBreaks: int
        ├── totalShards: int
        ├── earnedBadgeIds: [string]
        ├── backgroundTemplateId: string?
        └── customImagePath: string?
```

> **Not:** `AppConstants.enableFirebase = false` yapılarak Firebase olmadan geliştirme yapılabilir. Bu durumda yerel in-memory repository kullanılır.

---

## 💰 Monetizasyon (RevenueCat)

### PRO Entitlement: `rage_pro`

| Plan | Açıklama |
|------|----------|
| Aylık Abonelik | Aylık yenilenen PRO erişim |
| Yıllık Abonelik | Yıllık indirimli PRO erişim |
| Ömür Boyu | Tek seferlik kalıcı satın alma |

### PRO ile Açılan Özellikler

- ✅ 3 ek materyal (Porselen Vazo, CRT Monitör, Balonlu Naylon)
- ✅ Özel arka plan görsel seçici
- ✅ Gelişmiş parçacık efektleri
- ✅ Reklamsız deneyim
- ✅ PRO rozeti

### Satın Alma Akışı

```
PRO Materyal Seçimi → Kilit Kontrolü → ProRequiredDialog
  → PaywallScreen → RevenueCat İşlem → PRO Aktivasyon
  → "🎉 PRO Aktif! Tüm özellikler açıldı"
```

---

## 🎨 Tema Sistemi

Uygulama iki ayrı temaya sahiptir:

### ⚡ Rage Teması (Oyun Sırasında)
- **Primary:** Electric Blue `#00BCD4`
- **Secondary:** Rage Crimson `#E53935`
- **Surface:** Dark `#0A0A0F`
- **Font:** RobotoMono (monospace, endüstriyel)

### 🧘 Zen Teması (Meditasyon Sırasında)
- **Primary:** Lavender `#CE93D8`
- **Secondary:** Zen Purple `#7B1FA2`
- **Surface:** Deep Dark `#080612`
- **Font:** Roboto (hafif, temiz)

---

## 🛠️ Kullanılan Teknolojiler

### Framework & Motor
| Teknoloji | Versiyon | Kullanım Amacı |
|-----------|----------|----------------|
| **Flutter** | SDK ≥3.4.0 | Cross-platform UI framework |
| **Flame** | ^1.32.0 | 2D oyun motoru |
| **Forge2D** | 0.14.0 | Box2D fizik motoru |

### State Management
| Teknoloji | Kullanım Amacı |
|-----------|----------------|
| **flutter_bloc** / **bloc** | Seans ve monetizasyon state yönetimi |
| **Provider** | Ayar ve materyal tercihleri |
| **GetX** | Route yönetimi, global controller, reaktif state |

### Backend & Auth
| Teknoloji | Kullanım Amacı |
|-----------|----------------|
| **Firebase Core** | Firebase altyapısı |
| **Firebase Auth** | Anonim + Google kimlik doğrulama |
| **Cloud Firestore** | NoSQL veritabanı |
| **Firebase Crashlytics** | Hata raporlama |

### Monetizasyon
| Teknoloji | Kullanım Amacı |
|-----------|----------------|
| **RevenueCat (purchases_flutter)** | In-app purchase ve abonelik yönetimi |

### UI & Animasyon
| Teknoloji | Kullanım Amacı |
|-----------|----------------|
| **flutter_animate** | Deklaratif widget animasyonları |
| **Lottie** | JSON tabanlı vektör animasyonlar |
| **cupertino_icons** | iOS tarzı ikonlar |

### Veri & Depolama
| Teknoloji | Kullanım Amacı |
|-----------|----------------|
| **SharedPreferences** | Anahtar-değer yerel depolama |
| **Hive** | Hızlı NoSQL yerel veritabanı |
| **Dio** | HTTP istemcisi |

### Medya
| Teknoloji | Kullanım Amacı |
|-----------|----------------|
| **audioplayers** | Ses efektleri |
| **image_picker** | Galeri/kamera görsel seçici |

### Mimari & Yardımcılar
| Teknoloji | Kullanım Amacı |
|-----------|----------------|
| **GetIt** | Service Locator / Dependency Injection |
| **Injectable** | Otomatik DI kodu üretimi |
| **Equatable** | Değer eşitliği karşılaştırması |
| **dartz** | Fonksiyonel programlama (Either, Option) |
| **freezed_annotation** | Immutable model sınıfları |
| **json_annotation** | JSON serileştirme |
| **uuid** | Benzersiz kimlik üreteci |
| **intl** | Uluslararasılaştırma |
| **logger** | Yapılandırılmış loglama |

---

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK ≥ 3.4.0
- Dart SDK ≥ 3.4.0
- Android Studio / Xcode (platform hedefine göre)

### Adımlar

```bash
# 1. Repoyu klonla
git clone https://github.com/<username>/RageRoom.git
cd RageRoom/rage_app

# 2. Bağımlılıkları yükle
flutter pub get

# 3. (Opsiyonel) Firebase yapılandırması
# android/app/google-services.json dosyasını ekle
# ios/Runner/GoogleService-Info.plist dosyasını ekle
# Firebase olmadan çalıştırmak için AppConstants.enableFirebase = false

# 4. Uygulamayı çalıştır
flutter run
```

> **Not:** Firebase yapılandırması olmadan uygulama debug modda sorunsuz çalışır. Yerel in-memory repository ve test modu PRO aktivasyonu kullanılır.

---

## 📂 Proje Yapısı

```
rage_app/
├── assets/
│   ├── animations/           # Lottie animasyon dosyaları
│   ├── audio/                # Kırılma ses efektleri (glass, ceramic, monitor, bubble)
│   ├── data/
│   │   └── materials.json    # Materyal fizik konfigürasyonu
│   └── images/               # Görseller ve arka planlar
├── lib/                      # Uygulama kaynak kodu (Clean Architecture)
├── test/                     # Unit ve widget testleri
├── android/                  # Android platform kodu
├── ios/                      # iOS platform kodu
├── web/                      # Web platform kodu
├── macos/                    # macOS platform kodu
├── linux/                    # Linux platform kodu
├── windows/                  # Windows platform kodu
└── pubspec.yaml              # Proje bağımlılıkları
```

---

## 📄 Lisans

Bu proje özel kullanım için geliştirilmiştir.

---

<p align="center">
  <b>💥 Kırmak için dokunmanız yeterli. 🧘 Sonra nefes alın.</b>
</p>
