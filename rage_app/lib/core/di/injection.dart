// lib/core/di/injection.dart
// GetIt + Injectable ile Dependency Injection kurulumu.
// `flutter pub run build_runner build` ile injection.config.dart üretilir.

import 'package:get_it/get_it.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/core/services/haptic_service.dart';
import 'package:rage_app/data/repositories/local_rage_session_repository.dart';
import 'package:rage_app/data/repositories/rage_session_repository.dart';
import 'package:rage_app/data/sources/firebase_source.dart';
import 'package:rage_app/domain/repositories/rage_session_repository_interface.dart';

final GetIt getIt = GetIt.instance;

/// Core bağımlılıkları senkron şekilde güvenli biçimde kaydeder.
void ensureCoreDependenciesRegistered() {
	if (!getIt.isRegistered<HapticServiceInterface>()) {
		getIt.registerLazySingleton<HapticServiceInterface>(HapticService.new);
	}

	if (AppConstants.enableFirebase && !getIt.isRegistered<FirebaseSource>()) {
		getIt.registerLazySingleton<FirebaseSource>(FirebaseSource.new);
	}

	if (!getIt.isRegistered<RageSessionRepositoryInterface>()) {
		if (AppConstants.enableFirebase) {
			getIt.registerLazySingleton<RageSessionRepositoryInterface>(
				() => RageSessionRepository(getIt<FirebaseSource>()),
			);
		} else {
			getIt.registerLazySingleton<RageSessionRepositoryInterface>(
				LocalRageSessionRepository.new,
			);
		}
	}
}

/// Bağımlılıkları kayıt altına alır — main() içinde çağrılır.
Future<void> configureDependencies() async {
	ensureCoreDependenciesRegistered();
}
