// lib/presentation/screens/settings/settings_screen.dart
// Uygulama ayarları: ses, haptic, özel arkaplan (PRO), hesap.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rage_app/app/theme/app_theme.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/core/l10n/app_strings.dart';
import 'package:rage_app/data/sources/firebase_source.dart';
import 'package:rage_app/presentation/blocs/monetization/monetization_cubit.dart';
import 'package:rage_app/presentation/providers/material_provider.dart';
import 'package:rage_app/presentation/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkSurface,
      appBar: AppBar(
        title: Text(AppStrings.settingsTitle),
        backgroundColor: AppTheme.darkSurface,
        foregroundColor: AppTheme.electricBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(AppStrings.soundHaptic, [
            _buildSoundToggle(context),
            _buildHapticToggle(context),
            _buildParticleSlider(context),
          ]),
          const SizedBox(height: 24),
          _buildSection(AppStrings.proFeatures, [
            _buildCustomBackgroundTile(context),
          ]),
          const SizedBox(height: 24),
          if (AppConstants.enableFirebase) ...[
            _buildSection(AppStrings.account, [
              _buildGoogleSignInTile(context),
              _buildSignOutTile(context),
            ]),
            const SizedBox(height: 24),
          ],
          _buildSection(AppStrings.subscription, [
            _buildRestorePurchasesTile(context),
          ]),
          const SizedBox(height: 24),
          _buildSection(AppStrings.language, [
            _buildLanguageToggle(context),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0x60FFFFFF),
              fontSize: 11,
              letterSpacing: 3,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _buildSoundToggle(BuildContext context) {
    final provider = context.watch<MaterialProvider>();
    return SwitchListTile(
      title: Text(AppStrings.soundEffects,
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(AppStrings.breakingSounds,
          style: const TextStyle(color: Colors.white38)),
      value: provider.soundEnabled,
      onChanged: (v) => provider.toggleSound(enabled: v),
      activeThumbColor: AppTheme.electricBlue,
    );
  }

  Widget _buildHapticToggle(BuildContext context) {
    final provider = context.watch<MaterialProvider>();
    return SwitchListTile(
      title: Text(AppStrings.hapticFeedback,
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(AppStrings.vibrationProfiles,
          style: const TextStyle(color: Colors.white38)),
      value: provider.hapticEnabled,
      onChanged: (v) => provider.toggleHaptic(enabled: v),
      activeThumbColor: AppTheme.electricBlue,
    );
  }

  Widget _buildParticleSlider(BuildContext context) {
    final provider = context.watch<MaterialProvider>();
    return ListTile(
      title: Text(AppStrings.particleIntensity,
          style: const TextStyle(color: Colors.white)),
      subtitle: Slider(
        value: provider.particleIntensity,
        min: 0.5,
        max: 2,
        divisions: 6,
        activeColor: AppTheme.electricBlue,
        onChanged: provider.setParticleIntensity,
      ),
    );
  }

  Widget _buildCustomBackgroundTile(BuildContext context) {
    final cubit = context.watch<MonetizationCubit>();
    final settingsProvider = context.watch<SettingsProvider>();

    return ListTile(
      leading: const Icon(Icons.image_outlined, color: AppTheme.electricBlue),
      title: Text(AppStrings.customBackground,
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        settingsProvider.customBackgroundPath != null
            ? AppStrings.customImageSelected
            : AppStrings.useYourOwnScreenshot,
        style: const TextStyle(color: Colors.white38, fontSize: 12),
      ),
      trailing: cubit.isPro
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w900),
              ),
            ),
      onTap: cubit.isPro ? () => _pickCustomBackground(context) : null,
    );
  }

  Future<void> _pickCustomBackground(BuildContext context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    if (context.mounted) {
      await context.read<SettingsProvider>().setCustomBackgroundPath(file.path);
    }
  }

  Widget _buildGoogleSignInTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_circle_outlined,
          color: AppTheme.electricBlue),
      title: Text(AppStrings.signInWithGoogle,
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(AppStrings.syncYourStats,
          style: const TextStyle(color: Colors.white38, fontSize: 12)),
      onTap: () async {
        final source = Get.find<FirebaseSource>();
        await source.signInWithGoogle();
      },
    );
  }

  Widget _buildSignOutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.white38),
      title: Text(AppStrings.signOut,
          style: const TextStyle(color: Colors.white38)),
      onTap: () async {
        final source = Get.find<FirebaseSource>();
        await source.signOut();
      },
    );
  }

  Widget _buildRestorePurchasesTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.restore, color: AppTheme.electricBlue),
      title: Text(AppStrings.restorePurchases,
          style: const TextStyle(color: Colors.white)),
      onTap: () async {
        await context.read<MonetizationCubit>().restorePurchases();
      },
    );
  }

  Widget _buildLanguageToggle(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final currentLang = settingsProvider.language;
    return ListTile(
      leading: const Icon(Icons.language, color: AppTheme.electricBlue),
      title: Text(AppStrings.languageLabel,
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        AppStrings.currentLanguage,
        style: const TextStyle(color: Colors.white38, fontSize: 12),
      ),
      trailing: Switch(
        value: currentLang == AppLanguage.tr,
        activeColor: AppTheme.electricBlue,
        onChanged: (isTurkish) {
          final newLang = isTurkish ? AppLanguage.tr : AppLanguage.en;
          settingsProvider.setLanguage(newLang);
        },
      ),
    );
  }
}
