// lib/core/network/api_client.dart
// Dinamik arkaplan şablonları için soyut REST/JSON API istemcisi.
// Dio interceptor + retry mantığı ile güvenli HTTP katmanı.

import 'package:dio/dio.dart';
import 'package:rage_app/core/constants/app_constants.dart';

/// API yanıtlarını temsil eden jenerik wrapper.
class ApiResult<T> {
  const ApiResult.success(this.data) : error = null;
  const ApiResult.failure(this.error) : data = null;

  final T? data;
  final String? error;

  bool get isSuccess => error == null;
}

/// Arkaplan şablon modeli.
class BackgroundTemplate {
  const BackgroundTemplate({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.fullUrl,
    required this.isPro,
    required this.tags,
  });

  factory BackgroundTemplate.fromJson(Map<String, dynamic> json) {
    return BackgroundTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      fullUrl: json['full_url'] as String,
      isPro: json['is_pro'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
    );
  }

  final String id;
  final String name;
  final String thumbnailUrl;
  final String fullUrl;
  final bool isPro;
  final List<String> tags;
}

/// Soyut API istemci arayüzü — bağımlılık tersine çevirme için.
abstract interface class ApiClientInterface {
  Future<ApiResult<List<BackgroundTemplate>>> fetchBackgroundTemplates();
  Future<ApiResult<BackgroundTemplate>> fetchTemplateById(String id);
}

/// Dio tabanlı gerçek API istemcisi.
class ApiClient implements ApiClientInterface {
  ApiClient() : _dio = _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        headers: {'Accept': 'application/json'},
      ),
    );

    // Logging interceptor (DEBUG build'de çalışır)
    dio.interceptors.add(
      LogInterceptor(
        logPrint: (_) {}, // Üretimde print yoktur
      ),
    );

    // Yeniden deneme interceptor'ı
    dio.interceptors.add(_RetryInterceptor(dio));

    return dio;
  }

  @override
  Future<ApiResult<List<BackgroundTemplate>>> fetchBackgroundTemplates() async {
    try {
      final response = await _dio.get<List<dynamic>>('/templates');
      final templates = (response.data ?? [])
          .map((e) => BackgroundTemplate.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(templates);
    } on DioException catch (e) {
      return ApiResult.failure(
        e.response?.statusMessage ?? e.message ?? 'Bilinmeyen ağ hatası',
      );
    }
  }

  @override
  Future<ApiResult<BackgroundTemplate>> fetchTemplateById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/templates/$id');
      return ApiResult.success(BackgroundTemplate.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(
        e.response?.statusMessage ?? e.message ?? 'Bilinmeyen ağ hatası',
      );
    }
  }
}

/// Basit exponential back-off retry interceptor'ı.
class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(this._dio);

  final Dio _dio;
  static const int _maxRetries = 3;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retryCount = (extra['retryCount'] as int?) ?? 0;

    final shouldRetry = retryCount < _maxRetries &&
        err.type == DioExceptionType.connectionError;

    if (shouldRetry) {
      final delay = Duration(milliseconds: 300 * (retryCount + 1));
      await Future<void>.delayed(delay);
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      try {
        final response = await _dio.fetch<dynamic>(err.requestOptions);
        handler.resolve(response);
        return;
      } on DioException catch (retryErr) {
        handler.next(retryErr);
        return;
      }
    }

    handler.next(err);
  }
}

/// Test ve offline senaryoları için stub implementasyon.
class StubApiClient implements ApiClientInterface {
  @override
  Future<ApiResult<List<BackgroundTemplate>>> fetchBackgroundTemplates() async {
    return const ApiResult.success([]);
  }

  @override
  Future<ApiResult<BackgroundTemplate>> fetchTemplateById(String id) async {
    return const ApiResult.failure('Stub: şablon yok');
  }
}
