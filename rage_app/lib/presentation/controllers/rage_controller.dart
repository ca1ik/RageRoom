// lib/presentation/controllers/rage_controller.dart
// GetX Controller — hızlı routing, global dialog/snackbar yönetimi,
// anlık yıkım efektleri sırasında UI geri bildirimleri için.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/core/l10n/app_strings.dart';
import 'package:rage_app/core/services/haptic_service.dart';
// flutter/material.dart ve app_constants.dart aynı anda kullanılır.
// Çakışma yoktur: Flutter'ın MaterialType'ı, bizimki RageMaterialType.

class RageController extends GetxController {
  RageController({required HapticServiceInterface hapticService})
      : _haptic = hapticService;

  final HapticServiceInterface _haptic;

  // ── Gözlemlenebilir değişkenler ───────────────────────────────────────────

  /// Seçili materyal tipi — Provider ile senkronize edilir.
  final Rx<RageMaterialType> selectedMaterial =
      RageMaterialType.digitalGlass.obs;

  /// Oyun aktif mi?
  final RxBool isGameActive = false.obs;

  /// Anlık kırım ateş efekti tetikleyicisi — UI animasyonu için.
  final RxInt breakFeedbackTrigger = 0.obs;

  // ── Metotlar ──────────────────────────────────────────────────────────────

  /// Materyal değiştirilir; haptic ile doğrulama sesi çalınır.
  void selectMaterial(RageMaterialType type) {
    selectedMaterial.value = type;
    _haptic.vibrateImpact(intensity: 80);
  }

  /// Nesne kırılma geri bildirimi — fizik motoru her kırımda çağırır.
  Future<void> onObjectBroken(RageMaterialType type) async {
    breakFeedbackTrigger.value++;
    await _haptic.vibrateMaterial(type);
  }

  /// PRO özellik denendi — uygulama içi paywall göster.
  void showPaywall() {
    Get.toNamed<void>(AppConstants.routePaywall);
  }

  /// Genel başarı snackbar'ı.
  void showSuccessSnack(String message) {
    Get.snackbar(
      AppStrings.completed,
      message,
      backgroundColor: const Color(0xFF1B5E20).withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
    );
  }

  /// Hata snackbar'ı.
  void showErrorSnack(String message) {
    Get.snackbar(
      AppStrings.error,
      message,
      backgroundColor: const Color(0xFFB71C1C).withValues(alpha: 0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Yeni rozet kazanıldığında dialog göster.
  void showBadgeEarnedDialog(String badgeTitle, String badgeEmoji) {
    Get.dialog<void>(
      AlertDialog(
        backgroundColor: const Color(0xFF1A0A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppStrings.newBadge(badgeEmoji),
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          badgeTitle,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: Text(AppStrings.awesome,
                style: const TextStyle(color: Colors.amber)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// PRO özellik uyarısı — kullanıcıyı paywall'a yönlendirir.
  void showProRequiredDialog() {
    Get.dialog<void>(
      AlertDialog(
        backgroundColor: const Color(0xFF1A0A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppStrings.proFeature,
          style:
              const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          AppStrings.proRequiredMessage,
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: Text(
              AppStrings.maybeLater,
              style: const TextStyle(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back<void>();
              showPaywall();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: Text(AppStrings.upgradeToPro),
          ),
        ],
      ),
    );
  }
}
