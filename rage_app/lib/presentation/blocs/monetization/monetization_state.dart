// lib/presentation/blocs/monetization/monetization_state.dart
// RevenueCat monetization durumları.

import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class MonetizationState extends Equatable {
  const MonetizationState();

  @override
  List<Object?> get props => [];
}

/// İlk yükleme durumu.
class MonetizationInitial extends MonetizationState {
  const MonetizationInitial();
}

/// RevenueCat yükleniyor.
class MonetizationLoading extends MonetizationState {
  const MonetizationLoading();
}

/// Kullanıcı ücretsiz planda.
class MonetizationFree extends MonetizationState {
  const MonetizationFree({required this.offerings});

  final Offerings offerings;

  @override
  List<Object?> get props => [offerings];
}

/// Kullanıcı PRO plan sahibi.
class MonetizationPro extends MonetizationState {
  const MonetizationPro({required this.customerInfo});

  final CustomerInfo customerInfo;

  @override
  List<Object?> get props => [customerInfo];
}

/// Satın alma işlemi devam ediyor.
class MonetizationPurchasing extends MonetizationState {
  const MonetizationPurchasing();
}

/// Satın alma başarılı — PRO aktif.
class MonetizationPurchaseSuccess extends MonetizationState {
  const MonetizationPurchaseSuccess({required this.customerInfo});

  final CustomerInfo customerInfo;

  @override
  List<Object?> get props => [customerInfo];
}

/// Hata durumu.
class MonetizationError extends MonetizationState {
  const MonetizationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
