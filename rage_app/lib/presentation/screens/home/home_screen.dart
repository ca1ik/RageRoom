// lib/presentation/screens/home/home_screen.dart
// Ana menü ekranı — materyal seçimi, istatistikler, rozet önizlemesi.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rage_app/app/theme/app_theme.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/presentation/blocs/monetization/monetization_cubit.dart';
import 'package:rage_app/presentation/blocs/monetization/monetization_state.dart';
import 'package:rage_app/presentation/controllers/rage_controller.dart';
import 'package:rage_app/presentation/providers/material_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkSurface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent(context)),
            _buildStartButton(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RAGE ROOM',
                style: TextStyle(
                  color: AppTheme.electricBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'Developer Stress Relief',
                style: TextStyle(
                  color: Color(0x60FFFFFF),
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.emoji_events_outlined,
                    color: AppTheme.electricBlue),
                onPressed: () => Get.toNamed<void>(AppConstants.routeBadges),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined,
                    color: AppTheme.electricBlue),
                onPressed: () => Get.toNamed<void>(AppConstants.routeSettings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProBanner(context),
          const SizedBox(height: 24),
          const Text(
            'MATERYAL SEÇ',
            style: TextStyle(
              color: Color(0x80FFFFFF),
              fontSize: 11,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          _buildMaterialGrid(context),
          const SizedBox(height: 24),
          _buildStatsCard(context),
        ],
      ),
    );
  }

  Widget _buildProBanner(BuildContext context) {
    return BlocBuilder<MonetizationCubit, MonetizationState>(
      builder: (context, state) {
        final cubit = context.read<MonetizationCubit>();
        if (cubit.isPro) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => Get.toNamed<void>(AppConstants.routePaywall),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A0080), Color(0xFFC2185B)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Text('👑', style: TextStyle(fontSize: 24)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRO\'ya Yüksel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'CRT Monitör, Porselen Vazo ve daha fazlası',
                        style: TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
      },
    );
  }

  Widget _buildMaterialGrid(BuildContext context) {
    const materials = RageMaterialType.values;
    final provider = context.watch<MaterialProvider>();
    final cubit = context.read<MonetizationCubit>();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        final isSelected = provider.selectedMaterial == material;
        final isPro = material.isPro;
        final hasAccess = !isPro || cubit.isPro;

        return GestureDetector(
          onTap: () {
            if (!hasAccess) {
              Get.find<RageController>().showProRequiredDialog();
              return;
            }
            provider.selectMaterial(material);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.electricBlue.withValues(alpha: 0.15)
                  : AppTheme.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.electricBlue : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _materialEmoji(material),
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        material.displayName,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.electricBlue
                              : Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (isPro && !hasAccess)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        )
            .animate(delay: Duration(milliseconds: index * 80))
            .fadeIn()
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
      },
    );
  }

  String _materialEmoji(RageMaterialType type) {
    return switch (type) {
      RageMaterialType.digitalGlass => '🪟',
      RageMaterialType.porcelainVase => '🏺',
      RageMaterialType.crtMonitor => '🖥️',
      RageMaterialType.bubbleWrap => '🫧',
    };
  }

  Widget _buildStatsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 İSTATİSTİKLER',
            style: TextStyle(
              color: Color(0x80FFFFFF),
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'Toplam Kırım', value: '0', emoji: '💥'),
              _StatItem(label: 'Seanslar', value: '0', emoji: '⏱️'),
              _StatItem(label: 'Rozetler', value: '0', emoji: '🏅'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => Get.toNamed<void>(AppConstants.routeRage),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.rageCrimson,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            '💥  3 DAKİKA DEŞARJ OL',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0);
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.emoji,
  });

  final String label;
  final String value;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0x60FFFFFF),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
