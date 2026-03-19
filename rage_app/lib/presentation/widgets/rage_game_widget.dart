// lib/presentation/widgets/rage_game_widget.dart
// Flame GameWidget sargısı — Forge2D oyununu BLoC ve haptic ile entegre eder.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/core/di/injection.dart';
import 'package:rage_app/core/services/haptic_service.dart';
import 'package:rage_app/game/rage_game.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_bloc.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_event.dart';
import 'package:rage_app/presentation/providers/material_provider.dart';

class RageGameWidget extends StatefulWidget {
  const RageGameWidget({super.key});

  @override
  State<RageGameWidget> createState() => _RageGameWidgetState();
}

class _RageGameWidgetState extends State<RageGameWidget> {
  late final RageGame _game;

  @override
  void initState() {
    super.initState();
    ensureCoreDependenciesRegistered();

    final bloc = context.read<RageSessionBloc>();
    final provider = context.read<MaterialProvider>();
    final haptic = getIt<HapticServiceInterface>();

    _game = RageGame(
      materialType: provider.selectedMaterial,
      onObjectBroken: (
          {required int shardCount, required RageMaterialType materialType}) {
        bloc.add(RageSessionObjectBroken(
          shardCount: shardCount,
          materialType: materialType,
        ));
        haptic.vibrateMaterial(materialType);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget<RageGame>(game: _game);
  }

  @override
  void dispose() {
    _game.paused = true;
    super.dispose();
  }
}
