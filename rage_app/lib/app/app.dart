import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rage_app/app/routes/app_routes.dart';
import 'package:rage_app/app/theme/app_theme.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/core/di/injection.dart';
import 'package:rage_app/core/services/haptic_service.dart';
import 'package:rage_app/data/sources/firebase_source.dart';
import 'package:rage_app/domain/repositories/rage_session_repository_interface.dart'
    as repo_interface;
import 'package:rage_app/domain/usecases/save_session_usecase.dart';
import 'package:rage_app/domain/usecases/start_rage_session_usecase.dart';
import 'package:rage_app/presentation/blocs/monetization/monetization_cubit.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_bloc.dart';
import 'package:rage_app/presentation/controllers/rage_controller.dart';
import 'package:rage_app/presentation/providers/material_provider.dart';
import 'package:rage_app/presentation/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RageApp extends StatelessWidget {
  const RageApp({required this.prefs, super.key});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    ensureCoreDependenciesRegistered();

    // GetX controller'larını kaydet
    Get.put(RageController(hapticService: getIt<HapticServiceInterface>()));
    if (AppConstants.enableFirebase) {
      Get.put(getIt<FirebaseSource>());
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MaterialProvider>(
          create: (_) => MaterialProvider(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(prefs)..restoreLanguage(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RageSessionBloc>(
            create: (_) => RageSessionBloc(
              startSession: StartRageSessionUseCase(
                getIt<repo_interface.RageSessionRepositoryInterface>(),
              ),
              saveSession: SaveSessionUseCase(
                getIt<repo_interface.RageSessionRepositoryInterface>(),
              ),
            ),
          ),
          BlocProvider<MonetizationCubit>(
            // initialize() splash screen'de Firebase user ID ile çağrılır
            create: (_) => MonetizationCubit(),
          ),
        ],
        child: GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.rage,
          // GetX navigasyonu için initialRoute ve getPages
          initialRoute: AppConstants.routeSplash,
          getPages: AppRoutes.pages,
        ),
      ),
    );
  }
}
