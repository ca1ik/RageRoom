// lib/presentation/screens/zen/zen_screen.dart
// Seans sonrası meditasyon / toparlanma ekranı.
// Koyu mor, sakinleştirici UI — tam tersi geçiş.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rage_app/app/theme/app_theme.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/core/l10n/app_strings.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_bloc.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_event.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_state.dart';

class ZenScreen extends StatefulWidget {
  const ZenScreen({super.key});

  @override
  State<ZenScreen> createState() => _ZenScreenState();
}

class _ZenScreenState extends State<ZenScreen> {
  int _zenSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startZenTimer();
  }

  void _startZenTimer() {
    _runZenLoop();
  }

  Future<void> _runZenLoop() async {
    while (mounted) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) break;
      setState(() => _zenSeconds++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.zen,
      child: Scaffold(
        backgroundColor: const Color(0xFF080612),
        body: BlocBuilder<RageSessionBloc, RageSessionState>(
          builder: (context, state) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Emoji animasyonu
                      const Text('🧘', style: TextStyle(fontSize: 80))
                          .animate()
                          .scale(duration: 800.ms, curve: Curves.elasticOut),

                      const SizedBox(height: 32),

                      Text(
                        AppStrings.breathe,
                        style: const TextStyle(
                          color: AppTheme.zenLavender,
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 8,
                        ),
                      ).animate(delay: 400.ms).fadeIn(duration: 600.ms),

                      const SizedBox(height: 8),

                      Text(
                        AppStrings.zenMessage,
                        style: const TextStyle(
                          color: Color(0x80FFFFFF),
                          fontSize: 14,
                          height: 1.7,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ).animate(delay: 600.ms).fadeIn(duration: 500.ms),

                      const SizedBox(height: 40),

                      // Seans özeti
                      _buildSessionSummary(state),

                      const SizedBox(height: 40),

                      // Yeni seans veya ana menü
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                context.read<RageSessionBloc>().add(
                                      const RageSessionReset(),
                                    );
                                Get.offAllNamed<void>(AppConstants.routeHome);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.zenLavender,
                                side: const BorderSide(
                                  color: AppTheme.zenLavender,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(AppStrings.homeMenu),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<RageSessionBloc>().add(
                                      const RageSessionReset(),
                                    );
                                Get.offNamed<void>(AppConstants.routeRage);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.zenPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(AppStrings.playAgain),
                            ),
                          ),
                        ],
                      ).animate(delay: 900.ms).fadeIn().slideY(begin: 0.2),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSessionSummary(RageSessionState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF110E20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.zenLavender.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ZenStat(
              emoji: '💥',
              value: state.totalBreaks,
              label: AppStrings.zenBreaks),
          _ZenStat(
              emoji: '✨',
              value: state.totalShards,
              label: AppStrings.zenShards),
          _ZenStat(
            emoji: '⏱️',
            value: AppConstants.sessionDurationSeconds - state.remainingSeconds,
            label: AppStrings.zenSeconds,
          ),
        ],
      ),
    ).animate(delay: 700.ms).fadeIn().scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
        );
  }
}

class _ZenStat extends StatelessWidget {
  const _ZenStat({
    required this.emoji,
    required this.value,
    required this.label,
  });

  final String emoji;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0x60FFFFFF),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
