// lib/presentation/blocs/monetization/monetization_cubit.dart
// PRO üyelik satın alma ve durum yönetimi için Cubit.
// RevenueCat entegrasyonu — stres anında anlık satış psikolojisi!

import 'package:bloc/bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/presentation/blocs/monetization/monetization_state.dart';

class MonetizationCubit extends Cubit<MonetizationState> {
  MonetizationCubit() : super(const MonetizationInitial());

  bool _localProUnlocked = false;

  bool get _isOfflineMode => !AppConstants.enableFirebase;

  /// RevenueCat'i başlatır ve mevcut abonelik durumunu kontrol eder.
  Future<void> initialize(String userId) async {
    if (_isOfflineMode) {
      emit(const MonetizationInitial());
      return;
    }

    emit(const MonetizationLoading());
    try {
      await Purchases.configure(
        PurchasesConfiguration(AppConstants.revenueCatApiKeyAndroid)
          ..appUserID = userId,
      );
      await checkSubscriptionStatus();
    } on Exception catch (e) {
      emit(MonetizationError('Monetization başlatılamadı: $e'));
    }
  }

  /// Mevcut abonelik durumunu sorgular.
  Future<void> checkSubscriptionStatus() async {
    if (_isOfflineMode) {
      emit(const MonetizationInitial());
      return;
    }

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final isPro = customerInfo.entitlements.active.containsKey(
        AppConstants.proEntitlementId,
      );

      if (isPro) {
        emit(MonetizationPro(customerInfo: customerInfo));
      } else {
        // Teklifleri de yükle
        final offerings = await Purchases.getOfferings();
        emit(MonetizationFree(offerings: offerings));
      }
    } on Exception catch (e) {
      emit(MonetizationError('Abonelik durumu alınamadı: $e'));
    }
  }

  /// Belirli bir ürünü satın al.
  /// Kullanıcı tam deşarj olmak isterken anlık PRO ekranı açılır.
  Future<void> purchasePackage(Package package) async {
    if (_isOfflineMode) {
      _localProUnlocked = true;
      emit(const MonetizationInitial());
      return;
    }

    emit(const MonetizationPurchasing());
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      final customerInfo = purchaseResult.customerInfo;
      final isPro = customerInfo.entitlements.active.containsKey(
        AppConstants.proEntitlementId,
      );

      if (isPro) {
        emit(MonetizationPurchaseSuccess(customerInfo: customerInfo));
        emit(MonetizationPro(customerInfo: customerInfo));
      } else {
        emit(const MonetizationError('Satın alma doğrulanamadı.'));
      }
    } on PurchasesErrorCode catch (errorCode) {
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        // Kullanıcı iptal etti — sessizce geri dön
        await checkSubscriptionStatus();
      } else {
        emit(MonetizationError('Satın alma hatası: ${errorCode.name}'));
      }
    } on Exception catch (e) {
      emit(MonetizationError('Satın alma başarısız: $e'));
    }
  }

  /// Önceki satın almaları geri yükle.
  Future<void> restorePurchases() async {
    if (_isOfflineMode) {
      emit(const MonetizationInitial());
      return;
    }

    emit(const MonetizationLoading());
    try {
      final customerInfo = await Purchases.restorePurchases();
      final isPro = customerInfo.entitlements.active.containsKey(
        AppConstants.proEntitlementId,
      );

      if (isPro) {
        emit(MonetizationPro(customerInfo: customerInfo));
      } else {
        final offerings = await Purchases.getOfferings();
        emit(MonetizationFree(offerings: offerings));
      }
    } on Exception catch (e) {
      emit(MonetizationError('Geri yükleme başarısız: $e'));
    }
  }

  bool get isPro =>
      _localProUnlocked ||
      state is MonetizationPro ||
      state is MonetizationPurchaseSuccess;

  void activateLocalPro() {
    _localProUnlocked = true;
    emit(const MonetizationInitial());
  }
}
