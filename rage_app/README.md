# 🔥 Rage Room — Developer Stress Relief App

> **Can't break things in real life? Break them in the digital world!**
>
> Rage Room is a **physics-based stress relief application** designed for developers. Smash virtual objects in intense 3-minute destruction sessions, then unwind in Zen Mode. Built with Flame + Forge2D physics engine, Clean Architecture, Firebase, and RevenueCat.

---

## 📑 Table of Contents

- [Features](#-features)
- [Screens](#-screens)
- [Game Mechanics](#-game-mechanics)
- [Material System](#-material-system)
- [Badge & Achievement System](#-badge--achievement-system)
- [Architecture (Clean Architecture)](#-architecture-clean-architecture)
- [State Management](#-state-management)
- [Firebase Integration](#-firebase-integration)
- [Monetization (RevenueCat)](#-monetization-revenuecat)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| **Physics-Based Destruction** | Realistic breaking, bouncing, and shattering simulation powered by Forge2D |
| **3-Minute Sessions** | Timed, intense stress-relief sessions |
| **Zen Mode** | Post-destruction calming meditation screen |
| **4 Unique Materials** | Digital Glass, Porcelain Vase, CRT Monitor, Bubble Wrap |
| **7 Badges / Achievements** | Achievement system based on cumulative break count |
| **Haptic Feedback** | Material-specific tactile feedback profiles |
| **Sound Effects** | Material-based breaking sounds |
| **Particle System** | Material-specific shard shapes (triangles, polygons, circles, squares) |
| **Google Sign-In** | Stats synchronization across devices |
| **PRO Subscription** | Extra materials, custom backgrounds, advanced effects |
| **Offline Mode** | Fully playable without Firebase |
| **Crash Reporting** | Firebase Crashlytics integration |

---

## 📱 Screens

### 🌊 Splash Screen
- 1.8-second animated loading with logo/title
- Firebase initialization (optional)
- Anonymous authentication
- RevenueCat subscription status check

### 🏠 Home Screen
- 2×2 material selection grid
- Lock indicator for PRO-only materials
- Stats card: total breaks, session count, badge summary
- Navigation to Badges & Settings screens

### 💥 Rage Screen (Main Game)
- Full-screen Flame game widget (60 FPS)
- Top overlay: back button, circular countdown timer (3 min), material icon
- Bottom overlay: break counter, shard counter
- **"LAST CHANCE!"** red alert during final 10 seconds
- Real-time physics-based destruction

### 🧘 Zen Screen (Meditation)
- Calming dark purple UI
- **"BREATHE"** meditation message
- Session summary: total breaks, total shards, time spent
- Motivational text & emoji animation
- "Home" or "Play Again" options

### 🏅 Badges Screen
- Grid view of 7 achievement badges
- Locked (grayed + lock icon) / Earned (highlighted) states
- Each badge: emoji, title, required break count

### ⚙️ Settings Screen
- Audio & haptic toggles
- Particle intensity slider
- Custom background picker (PRO only)
- Google Sign-In for stats sync
- Restore purchases button
- Legal information

### 💎 Paywall Screen (PRO)
- PRO feature list
- Subscription package selection (Monthly / Yearly / Lifetime)
- Local PRO activation in test mode

---

## 🎮 Game Mechanics

### Physics Engine: Flame + Forge2D

| Parameter | Value |
|-----------|-------|
| Gravity | -10 units/sec² |
| Physics Zoom | 10 (1 unit = 10 pixels) |
| Target FPS | 60 |
| Session Duration | 180 seconds |

### Interaction Flow

```
User Tap
  │
  ├─ Object Found → Break it!
  │   ├─ Spawn shards (material-specific shapes)
  │   ├─ Apply radial impulse from tap point
  │   ├─ Trigger haptic feedback
  │   ├─ Emit RageSessionObjectBroken event
  │   └─ Respawn new object after 800ms
  │
  └─ Empty Space → Shockwave effect
      └─ Apply force to all visible objects
```

### Game Components

| Component | Purpose |
|-----------|---------|
| `WorldBoundaries` | Static edges (ground, walls, ceiling) for containment |
| `BreakableObject` | Dynamic 2D rect objects that shatter on tap |
| `ShardParticle` | Physics-based particles spawned on destruction (8s lifespan) |
| `BackgroundComponent` | Gradient or custom image background layer |

### Particle System

Material-specific shard shapes:
- 🪟 **Glass** → Triangle fragments
- 🏺 **Porcelain** → Irregular polygon chunks
- 🖥️ **CRT** → Small squares
- 🫧 **Bubble Wrap** → Circles

Particle lifespan: **8 seconds** (opacity fade during last 2 seconds)

---

## 🧱 Material System

Four unique materials, each with distinct physics parameters:

| Material | Shards | Restitution | Friction | Density | PRO? | Behavior |
|----------|--------|-------------|----------|---------|------|----------|
| 🪟 Digital Glass | 18 | 0.3 | 0.2 | 1.2 | ❌ | Light, bouncy, flies far |
| 🏺 Porcelain Vase | 24 | 0.1 | 0.6 | 2.0 | ✅ | Sticky, crumbles nearby |
| 🖥️ CRT Monitor | 30 | 0.05 | 0.8 | 3.5 | ✅ | Heavy, no bounce, falls straight |
| 🫧 Bubble Wrap | 40 | 0.6 | 0.1 | 0.3 | ✅ | Super bouncy, chaotic movement |

Full physics configuration is defined in `assets/data/materials.json`.

---

## 🏅 Badge & Achievement System

7 badges based on **cumulative total breaks** across all sessions:

| # | Badge | Requirement |
|---|-------|-------------|
| 💥 | **First Rage** | 1+ breaks |
| ⚔️ | **Syntax Error Slayer** | 50+ breaks |
| 🏆 | **Deadline Survivor** | 100+ breaks |
| 🧪 | **TÜBİTAK Warrior** | 200+ breaks |
| 💣 | **Century Destroyer** | 500+ breaks |
| 🧘 | **Zen Master** | Stay in Zen Mode for 60+ seconds |
| 👑 | **PRO Unlocked** | Purchase PRO plan |

---

## 🏛️ Architecture (Clean Architecture)

The project follows a layered **Clean Architecture** pattern:

```
┌──────────────────────────────────────────────────┐
│          Presentation Layer (UI)                 │
│   Screens • Widgets • BLoCs • Providers          │
│   Controllers (GetX)                             │
├──────────────────────────────────────────────────┤
│          Domain Layer (Business Logic)           │
│   Entities • Repository Interfaces • Use Cases   │
├──────────────────────────────────────────────────┤
│          Data Layer (Data Sources)               │
│   Models • Repository Implementations            │
│   Firebase Source • Local Repository             │
├──────────────────────────────────────────────────┤
│          Game Layer (Game Engine)                 │
│   RageGame (Forge2D) • Components                │
├──────────────────────────────────────────────────┤
│          Core Layer (Infrastructure)             │
│   DI (GetIt) • Services • Network (Dio)          │
│   Constants                                      │
└──────────────────────────────────────────────────┘
```

### Folder Structure

```
lib/
├── main.dart                 # Application entry point
├── app/
│   ├── app.dart              # Root widget, Provider/BLoC/GetX setup
│   ├── routes/               # GetX route definitions
│   └── theme/                # Rage & Zen themes
├── core/
│   ├── constants/            # App constants & configuration
│   ├── di/                   # GetIt dependency injection
│   ├── network/              # Dio HTTP client
│   └── services/             # Haptic service
├── data/
│   ├── models/               # Firestore data models
│   ├── repositories/         # Repository implementations
│   └── sources/              # Firebase data source
├── domain/
│   ├── entities/             # RageSession, Badge entities
│   ├── repositories/         # Repository interfaces
│   └── usecases/             # StartSession, SaveSession
├── game/
│   ├── rage_game.dart        # Flame/Forge2D game class
│   └── components/           # BreakableObject, ShardParticle, etc.
└── presentation/
    ├── blocs/                # RageSessionBloc, MonetizationCubit
    ├── controllers/          # GetX RageController
    ├── providers/            # MaterialProvider, SettingsProvider
    ├── screens/              # 7 screens
    └── widgets/              # TimerWidget, BadgeWidget, etc.
```

---

## 🔄 State Management

The project uses a **hybrid state management** approach:

### 📦 Flutter BLoC — Game Session Management

**RageSessionBloc** manages the session lifecycle:

```
SessionPhase: idle → raging → ending → saving → zen
```

| Event | Description |
|-------|-------------|
| `RageSessionStarted` | Start session, create Firestore document |
| `RageSessionObjectBroken` | Update break and shard counters |
| `RageSessionTimerTicked` | Update countdown, transition to "ending" at <10s |
| `RageSessionEnded` | Calculate badges, save to Firestore, enter Zen Mode |
| `RageSessionReset` | Reset all counters |

**MonetizationCubit** manages subscription state:
- `MonetizationFree` / `MonetizationPro` states
- Purchase, restore, and test mode activation

### 🔔 Provider (ChangeNotifier) — Settings & Preferences

- **MaterialProvider**: Selected material, sound/haptic toggles, particle intensity
- **SettingsProvider**: Custom background, notifications, session count (SharedPreferences)

### ⚡ GetX — Global Utility Controller

- **RageController**: Observable material selection, game state, UI feedback triggers

---

## 🔥 Firebase Integration

| Service | Usage |
|---------|-------|
| **Firebase Auth** | Anonymous sign-in + Google Sign-In |
| **Cloud Firestore** | Session data, user statistics, badge tracking |
| **Firebase Crashlytics** | Error catching & reporting in release mode |

### Firestore Schema

```
/users/{uid}
  ├── totalBreaks: int              (atomic increment)
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

> **Note:** Set `AppConstants.enableFirebase = false` to develop without Firebase. The app will use an in-memory local repository instead.

---

## 💰 Monetization (RevenueCat)

### PRO Entitlement: `rage_pro`

| Plan | Description |
|------|-------------|
| Monthly Subscription | Recurring monthly PRO access |
| Yearly Subscription | Discounted annual PRO access |
| Lifetime | One-time permanent purchase |

### PRO Unlocked Features

- ✅ 3 additional materials (Porcelain Vase, CRT Monitor, Bubble Wrap)
- ✅ Custom background image picker
- ✅ Advanced particle effects
- ✅ Ad-free experience
- ✅ PRO badge/status

### Purchase Flow

```
Select PRO Material → Lock Check → ProRequiredDialog
  → PaywallScreen → RevenueCat Transaction → PRO Activation
  → "🎉 PRO Active! All features unlocked"
```

---

## 🎨 Theme System

The app features two distinct themes:

### ⚡ Rage Theme (During Gameplay)
- **Primary:** Electric Blue `#00BCD4`
- **Secondary:** Rage Crimson `#E53935`
- **Surface:** Dark `#0A0A0F`
- **Font:** RobotoMono (monospace, industrial feel)

### 🧘 Zen Theme (During Meditation)
- **Primary:** Lavender `#CE93D8`
- **Secondary:** Zen Purple `#7B1FA2`
- **Surface:** Deep Dark `#080612`
- **Font:** Roboto (light, clean)

---

## 🛠️ Tech Stack

### Framework & Engine
| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | SDK ≥3.4.0 | Cross-platform UI framework |
| **Flame** | ^1.32.0 | 2D game engine |
| **Forge2D** | 0.14.0 | Box2D physics engine |

### State Management
| Technology | Purpose |
|------------|---------|
| **flutter_bloc** / **bloc** | Session & monetization state management |
| **Provider** | Settings & material preferences |
| **GetX** | Route management, global controller, reactive state |

### Backend & Auth
| Technology | Purpose |
|------------|---------|
| **Firebase Core** | Firebase infrastructure |
| **Firebase Auth** | Anonymous + Google authentication |
| **Cloud Firestore** | NoSQL database |
| **Firebase Crashlytics** | Crash reporting |

### Monetization
| Technology | Purpose |
|------------|---------|
| **RevenueCat (purchases_flutter)** | In-app purchase & subscription management |

### UI & Animation
| Technology | Purpose |
|------------|---------|
| **flutter_animate** | Declarative widget animations |
| **Lottie** | JSON-based vector animations |
| **cupertino_icons** | iOS-style icons |

### Data & Storage
| Technology | Purpose |
|------------|---------|
| **SharedPreferences** | Key-value local storage |
| **Hive** | Fast NoSQL local database |
| **Dio** | HTTP client |

### Media
| Technology | Purpose |
|------------|---------|
| **audioplayers** | Sound effects playback |
| **image_picker** | Gallery/camera image picker |

### Architecture & Utilities
| Technology | Purpose |
|------------|---------|
| **GetIt** | Service Locator / Dependency Injection |
| **Injectable** | Automatic DI code generation |
| **Equatable** | Value equality comparison |
| **dartz** | Functional programming (Either, Option) |
| **freezed_annotation** | Immutable model classes |
| **json_annotation** | JSON serialization |
| **uuid** | Unique ID generator |
| **intl** | Internationalization |
| **logger** | Structured logging |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.4.0
- Dart SDK ≥ 3.4.0
- Android Studio / Xcode (depending on target platform)

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/<username>/RageRoom.git
cd RageRoom/rage_app

# 2. Install dependencies
flutter pub get

# 3. (Optional) Firebase configuration
# Add android/app/google-services.json
# Add ios/Runner/GoogleService-Info.plist
# To run without Firebase, set AppConstants.enableFirebase = false

# 4. Run the app
flutter run
```

> **Note:** The app runs seamlessly in debug mode without Firebase configuration. It uses an in-memory local repository and test mode PRO activation.

---

## 📂 Project Structure

```
rage_app/
├── assets/
│   ├── animations/           # Lottie animation files
│   ├── audio/                # Breaking sound effects (glass, ceramic, monitor, bubble)
│   ├── data/
│   │   └── materials.json    # Material physics configuration
│   └── images/               # Images and backgrounds
├── lib/                      # Application source code (Clean Architecture)
├── test/                     # Unit & widget tests
├── android/                  # Android platform code
├── ios/                      # iOS platform code
├── web/                      # Web platform code
├── macos/                    # macOS platform code
├── linux/                    # Linux platform code
├── windows/                  # Windows platform code
└── pubspec.yaml              # Project dependencies
```

---

## 📄 License

This project is developed for private use.

---

<p align="center">
  <b>💥 Just tap to break. 🧘 Then breathe.</b>
</p>
