// lib/core/l10n/app_strings.dart
// Simple localization system — English (default) + Turkish.

enum AppLanguage { en, tr }

abstract class AppStrings {
  static AppLanguage _current = AppLanguage.en;

  static AppLanguage get current => _current;

  static void setLanguage(AppLanguage lang) => _current = lang;

  static bool get isEnglish => _current == AppLanguage.en;

  // ── Home Screen ───────────────────────────────────────────────────────────
  static String get chooseMaterial => _t('CHOOSE MATERIAL', 'MATERYAL SEÇ');
  static String get upgradeToPro => _t('Upgrade to PRO', 'PRO\'ya Yüksel');
  static String get proBannerSubtitle => _t(
      'CRT Monitor, Porcelain Vase and more',
      'CRT Monitör, Porselen Vazo ve daha fazlası');
  static String get statistics => _t('📊 STATISTICS', '📊 İSTATİSTİKLER');
  static String get totalBreaksLabel => _t('Total Breaks', 'Toplam Kırım');
  static String get sessionsLabel => _t('Sessions', 'Seanslar');
  static String get badgesLabel => _t('Badges', 'Rozetler');
  static String get startButton =>
      _t('💥  3 MIN DISCHARGE', '💥  3 DAKİKA DEŞARJ OL');

  // ── Rage Screen ───────────────────────────────────────────────────────────
  static String get lastChance =>
      _t('⚡ LAST CHANCE! KEEP GOING!', '⚡ SON ŞANS! DEVAM ET!');
  static String get breaks => _t('BREAKS', 'KIRIM');
  static String get shards => _t('SHARDS', 'PARÇA');

  // ── Zen Screen ────────────────────────────────────────────────────────────
  static String get breathe => _t('BREATHE', 'NEFES AL');
  static String get zenMessage => _t(
      'The things that broke have settled.\nNow you settle too.',
      'Kırılan şeyler yerli yerine oturdu.\nŞimdi sen de otur.');
  static String get homeMenu => _t('Home', 'Ana Menü');
  static String get playAgain => _t('Play Again', 'Tekrar Oyna');
  static String get zenBreaks => _t('Breaks', 'Kırım');
  static String get zenShards => _t('Shards', 'Parça');
  static String get zenSeconds => _t('Seconds', 'Saniye');

  // ── Badges Screen ─────────────────────────────────────────────────────────
  static String get badgesTitle => _t('BADGES', 'ROZETLER');
  static String breaksRequired(int count) =>
      _t('$count breaks', '$count kırım');

  // ── Settings Screen ───────────────────────────────────────────────────────
  static String get settingsTitle => _t('SETTINGS', 'AYARLAR');
  static String get soundHaptic => _t('SOUND & HAPTIC', 'SES & HAPTİK');
  static String get proFeatures => _t('PRO FEATURES', 'PRO ÖZELLİKLER');
  static String get account => _t('ACCOUNT', 'HESAP');
  static String get subscription => _t('SUBSCRIPTION', 'ABONELIK');
  static String get soundEffects => _t('Sound Effects', 'Ses Efektleri');
  static String get breakingSounds => _t('Breaking sounds', 'Kırılma sesleri');
  static String get hapticFeedback =>
      _t('Haptic Feedback', 'Haptik Geri Bildirim');
  static String get vibrationProfiles =>
      _t('Vibration profiles', 'Titreşim profilleri');
  static String get particleIntensity =>
      _t('Particle Intensity', 'Parçacık Yoğunluğu');
  static String get customBackground =>
      _t('Custom Background', 'Özel Arkaplan');
  static String get customImageSelected =>
      _t('Custom image selected', 'Özel görsel seçildi');
  static String get useYourOwnScreenshot =>
      _t('Use your own screenshot', 'Kendi ekran görüntünü kullan');
  static String get signInWithGoogle =>
      _t('Sign in with Google', 'Google ile Giriş Yap');
  static String get syncYourStats =>
      _t('Sync your statistics', 'İstatistiklerini senkronize et');
  static String get signOut => _t('Sign Out', 'Çıkış Yap');
  static String get restorePurchases =>
      _t('Restore Purchases', 'Satın Almaları Geri Yükle');
  static String get language => _t('LANGUAGE', 'DİL');
  static String get languageLabel => _t('Language', 'Dil');
  static String get english => _t('English', 'İngilizce');
  static String get turkish => _t('Turkish', 'Türkçe');
  static String get currentLanguage => _t('English', 'Türkçe');

  // ── Paywall Screen ────────────────────────────────────────────────────────
  static String get proActiveSnackTitle =>
      _t('🎉 PRO Active!', '🎉 PRO Aktif!');
  static String get proActiveSnackMessage => _t(
      'All features unlocked. Time to fully discharge!',
      'Tüm özellikler açıldı. Tam deşarj zamanı!');
  static String get proSubtitle => _t('Unlimited discharge. Unlimited power.',
      'Sınırsız deşarj. Sınırsız güç.');
  static String get unlimitedSessions =>
      _t('Unlimited Sessions', 'Sınırsız Seans');
  static String get customBackgrounds =>
      _t('Custom Backgrounds', 'Özel Arkaplanlar');
  static String get advancedParticleEffects =>
      _t('Advanced Particle Effects', 'Gelişmiş Parçacık Efektleri');
  static String get adFreeExperience =>
      _t('Ad-free Experience', 'Reklamsız Deneyim');
  static String get upgradeToProTest =>
      _t('Upgrade to PRO (Test)', 'PRO\'ya Yükselt (Test)');
  static String get transactionInProgress =>
      _t('Transaction in progress...', 'İşlem devam ediyor...');
  static String get proActive => _t('PRO Active!', 'PRO Aktif!');
  static String get restorePurchasesLink =>
      _t('Restore purchases', 'Satın alımları geri yükle');
  static String get legalText => _t(
        'Payment will be charged to your iTunes account. '
            'Subscription automatically renews unless cancelled at least 24 hours before the end of the current period.',
        'Ödeme iTunes hesabınızdan yapılır. '
            'Abonelik, süresi dolmadan 24 saat önce iptal edilmedikçe otomatik yenilenir.',
      );
  static String get noPackagesAvailable =>
      _t('No packages available currently.', 'Şu anda paket bulunamadı.');
  static String get proActiveTest => _t('PRO Active', 'PRO Aktif');
  static String get proActiveTestMessage => _t(
      'Test mode: PRO features unlocked.',
      'Test modu: PRO özellikleri açıldı.');

  // ── Controller Dialogs ────────────────────────────────────────────────────
  static String get completed => _t('✅ Completed', '✅ Tamamlandı');
  static String get error => _t('❌ Error', '❌ Hata');
  static String newBadge(String emoji) =>
      _t('$emoji New Badge!', '$emoji Yeni Rozet!');
  static String get awesome => _t('Awesome!', 'Harika!');
  static String get proFeature => _t('👑 PRO Feature', '👑 PRO Özellik');
  static String get proRequiredMessage => _t(
      'This feature requires a PRO plan. Upgrade to PRO to fully discharge!',
      'Bu özellik PRO plan gerektirir. Tam deşarj olmak için PRO\'ya yüksel!');
  static String get maybeLater => _t('Maybe Later', 'Belki Sonra');

  // ── Material Names ────────────────────────────────────────────────────────
  static String get digitalGlass => _t('Digital Glass', 'Dijital Cam');
  static String get porcelainVase => _t('Porcelain Vase', 'Porselen Vazo');
  static String get crtMonitor => _t('Old CRT Monitor', 'Eski CRT Monitör');
  static String get bubbleWrap => _t('Bubble Wrap', 'Balonlu Naylon');

  // ── Badge Titles & Descriptions ───────────────────────────────────────────
  static String get badgeFirstRageTitle => _t('First Rage', 'İlk Deşarj');
  static String get badgeFirstRageDesc => _t(
      'Completed your first rage session. This is a beginning.',
      'İlk rage seansını tamamladın. Burası bir başlangıç.');
  static String get badgeSyntaxSlayerTitle =>
      _t('Syntax Error Slayer', 'Syntax Error Slayer');
  static String get badgeSyntaxSlayerDesc => _t(
      'You broke 50 objects. The compiler would agree.',
      '50 nesneyi kırdın. Compiler sana hak verecek.');
  static String get badgeDeadlineTitle =>
      _t('Deadline Survivor', 'Deadline Survivor');
  static String get badgeDeadlineDesc => _t(
      'Survived 3 full sessions until the timer ran out.',
      '3 tam seansı zamanlayıcı bitene dek sürdürdün.');
  static String get badgeTubitakTitle =>
      _t('TÜBİTAK Warrior', 'TÜBİTAK Warrior');
  static String get badgeTubitakDesc => _t(
      '200 breaks under intense pressure. You\'re a warrior.',
      'Şiddetli baskı altında 200 kırım. Savaşçısın.');
  static String get badgeCenturyTitle =>
      _t('Century Destroyer', 'Century Destroyer');
  static String get badgeCenturyDesc => _t(
      '500 breaks. You\'re hitting the app, not the keyboard. Good.',
      '500 kırım. Klavyeye değil, uygulamaya vuruyorsun. İyi.');
  static String get badgeZenTitle => _t('Zen Master', 'Zen Master');
  static String get badgeZenDesc => _t(
      'Stayed in meditation mode for 60 seconds after a rage session.',
      'Rage seansından sonra meditasyon modunda 60 saniye kaldın.');
  static String get badgeProTitle => _t('PRO Ascension', 'PRO Yükselişi');
  static String get badgeProDesc => _t(
      'Activated your PRO membership. Full power unleashed.',
      'PRO üyeliğini etkinleştirdin. Tam güç serbest.');

  // ── Helper ────────────────────────────────────────────────────────────────
  static String _t(String en, String tr) =>
      _current == AppLanguage.en ? en : tr;
}
