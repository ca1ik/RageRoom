// lib/presentation/screens/rage/rage_screen.dart
// 3 dakikalık yıkım seansı ekranı.
// Flame/Forge2D oyun motoru + BLoC timer + haptic geri bildirim.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rage_app/app/theme/app_theme.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/core/l10n/app_strings.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_bloc.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_event.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_state.dart';
import 'package:rage_app/presentation/providers/material_provider.dart';
import 'package:rage_app/presentation/widgets/rage_game_widget.dart';
import 'package:rage_app/presentation/widgets/timer_widget.dart';

class RageScreen extends StatefulWidget {
  const RageScreen({super.key});

  @override
  State<RageScreen> createState() => _RageScreenState();
}

class _RageScreenState extends State<RageScreen> {
  @override
  void initState() {
    super.initState();
    _startSession();
  }

  void _startSession() {
    final bloc = context.read<RageSessionBloc>();
    final provider = context.read<MaterialProvider>();
    // Anonim kullanıcı ID - gerçek projede Firebase UID kullanılır
    bloc.add(
      RageSessionStarted(
        userId: 'anonymous',
        materialType: provider.selectedMaterial,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RageSessionBloc, RageSessionState>(
      listener: (context, state) {
        if (state.isZen) {
          // Seans bitti — zen moduna geç
          Get.offNamed<void>(AppConstants.routeZen);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.darkSurface,
        body: Stack(
          children: [
            // Fizik oyun alanı — tam ekran
            const RageGameWidget(),

            // Üst UI katmanı
            _buildTopOverlay(),

            // Alt UI katmanı — break sayacı
            _buildBottomOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopOverlay() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Geri tuşu
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white54),
              onPressed: () {
                context.read<RageSessionBloc>().add(const RageSessionEnded());
                Get.back<void>();
              },
            ),
            const Spacer(),
            // 3 dakika zamanlayıcı
            const TimerWidget(),
            const Spacer(),
            // Materyal ikonu
            BlocBuilder<RageSessionBloc, RageSessionState>(
              builder: (context, state) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _materialEmoji(
                        context.read<MaterialProvider>().selectedMaterial),
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomOverlay() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: BlocBuilder<RageSessionBloc, RageSessionState>(
        builder: (context, state) {
          return Column(
            children: [
              // Son 10 saniye uyarısı
              if (state.isCriticalTime)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.rageCrimson.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppStrings.lastChance,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              // Kırım sayaçı
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CountBadge(
                    label: AppStrings.breaks,
                    value: state.totalBreaks.toString(),
                    color: AppTheme.rageCrimson,
                  ),
                  const SizedBox(width: 12),
                  _CountBadge(
                    label: AppStrings.shards,
                    value: state.totalShards.toString(),
                    color: AppTheme.electricBlue,
                  ),
                ],
              ),
            ],
          );
        },
      ),
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
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
