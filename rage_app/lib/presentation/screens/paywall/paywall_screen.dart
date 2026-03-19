// lib/presentation/screens/paywall/paywall_screen.dart
// PRO abonelik satın alma ekranı — RevenueCat entegrasyonu.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rage_app/app/theme/app_theme.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/core/l10n/app_strings.dart';
import 'package:rage_app/presentation/blocs/monetization/monetization_cubit.dart';
import 'package:rage_app/presentation/blocs/monetization/monetization_state.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white54),
          onPressed: () => Get.back<void>(),
        ),
      ),
      body: BlocConsumer<MonetizationCubit, MonetizationState>(
        listener: (context, state) {
          if (state is MonetizationPurchaseSuccess) {
            Get.back<void>();
            Get.snackbar(
              AppStrings.proActiveSnackTitle,
              AppStrings.proActiveSnackMessage,
              backgroundColor: const Color(0xFF1B5E20),
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(12),
            );
          } else if (state is MonetizationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.rageCrimson,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),

                  // Başlık
                  const Text(
                    '👑',
                    style: TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'RAGE ROOM PRO',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.proSubtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // PRO Özellikleri
                  _buildFeature(
                      Icons.all_inclusive, AppStrings.unlimitedSessions),
                  _buildFeature(
                      Icons.palette_outlined, AppStrings.customBackgrounds),
                  _buildFeature(Icons.monitor, 'CRT Monitor & Bubble Wrap'),
                  _buildFeature(
                      Icons.auto_awesome, AppStrings.advancedParticleEffects),
                  _buildFeature(
                      Icons.ad_units_outlined, AppStrings.adFreeExperience),

                  const Spacer(flex: 2),

                  // Paketler
                  if (!AppConstants.enableFirebase) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<MonetizationCubit>().activateLocalPro();
                          Get.back<void>();
                          Get.snackbar(
                            AppStrings.proActiveTest,
                            AppStrings.proActiveTestMessage,
                            backgroundColor: const Color(0xFF1B5E20),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(12),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          AppStrings.upgradeToProTest,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ] else if (state is MonetizationFree) ...[
                    _buildPackageList(context, state.offerings),
                  ] else if (state is MonetizationPurchasing) ...[
                    const CircularProgressIndicator(color: Colors.amber),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.transactionInProgress,
                      style: const TextStyle(color: Colors.white38),
                    ),
                  ] else if (state is MonetizationPro) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.proActive,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Geri yükle
                  if (AppConstants.enableFirebase)
                    TextButton(
                      onPressed: () {
                        context.read<MonetizationCubit>().restorePurchases();
                      },
                      child: Text(
                        AppStrings.restorePurchasesLink,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Yasal linkler
                  Text(
                    AppStrings.legalText,
                    style: const TextStyle(color: Colors.white24, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageList(BuildContext context, Offerings offerings) {
    final current = offerings.current;
    if (current == null) {
      return Text(
        AppStrings.noPackagesAvailable,
        style: const TextStyle(color: Colors.white38),
      );
    }

    return Column(
      children: current.availablePackages.map((package) {
        final product = package.storeProduct;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<MonetizationCubit>().purchasePackage(package);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.priceString,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
