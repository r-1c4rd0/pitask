import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../common/custom_trace.dart';
import '../exceptions/network_exceptions.dart';

const Duration _defaultConnectTimeout = Duration(minutes: 1);
const Duration _defaultReceiveTimeout = Duration(minutes: 1);

class DioClient {
  final String baseUrl;
  late final Dio _dio;
  late final CacheOptions cacheOptions;
  late final Options _optionsNetwork;
  late final Options _optionsCache;
  final List<Interceptor> interceptors;
  final RxList<String> _progress = <String>[].obs;

  /// 🔹 Expor `optionsNetwork` e `optionsCache`
  Options get optionsNetwork => _optionsNetwork;
  Options get optionsCache => _optionsCache;

  DioClient(
      this.baseUrl,
      Dio dio, {
        required this.interceptors,
      }) {
    _dio = dio;
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: _defaultConnectTimeout,
      receiveTimeout: _defaultReceiveTimeout,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Requested-With': 'XMLHttpRequest',
        'Accept-Language': 'en',
      },
    );

    // 🔹 Configuração do Cache usando CacheOptions
    cacheOptions = CacheOptions(
      store: HiveCacheStore('./cache/'),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.high,
    );

    // 🔹 Definição das opções de cache e rede
    _optionsNetwork = Options(headers: _dio.options.headers);
    _optionsCache = cacheOptions.toOptions();

    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    _dio.interceptors.addAll(interceptors);

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          error: true,
          requestBody: true,
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }
  }

  // 🔹 Método GET otimizado
  Future<Response<T>> get<T>(String uri, {Options? options}) async {
    return _request(
          () => _dio.get<T>(uri, options: options ?? _optionsNetwork),
      CustomTrace(StackTrace.current, message: 'GET $uri'),
    );
  }

  // 🔹 Método GET URI otimizado
  Future<Response<T>> getUri<T>(Uri uri, {Options? options}) async {
    return _request(
          () => _dio.getUri<T>(uri, options: options ?? _optionsCache),
      CustomTrace(StackTrace.current, message: 'GET URI $uri'),
    );
  }

  // 🔹 Método POST otimizado
  Future<Response<T>> post<T>(String uri, {dynamic data, Options? options}) async {
    return _request(
          () => _dio.post<T>(uri, data: data, options: options ?? _optionsNetwork),
      CustomTrace(StackTrace.current, message: 'POST $uri'),
    );
  }

  // 🔹 Método POST URI otimizado (RESTAURADO)
  Future<Response<T>> postUri<T>(Uri uri, {dynamic data, Options? options}) async {
    return _request(
          () => _dio.postUri<T>(uri, data: data, options: options ?? _optionsNetwork),
      CustomTrace(StackTrace.current, message: 'POST URI $uri'),
    );
  }

  // 🔹 Método PUT otimizado
  Future<Response<T>> put<T>(String uri, {dynamic data, Options? options}) async {
    return _request(
          () => _dio.put<T>(uri, data: data, options: options ?? _optionsNetwork),
      CustomTrace(StackTrace.current, message: 'PUT $uri'),
    );
  }

  // 🔹 Método PUT URI otimizado (RESTAURADO)
  Future<Response<T>> putUri<T>(Uri uri, {dynamic data, Options? options}) async {
    return _request(
          () => _dio.putUri<T>(uri, data: data, options: options ?? _optionsNetwork),
      CustomTrace(StackTrace.current, message: 'PUT URI $uri'),
    );
  }

  // 🔹 Método DELETE otimizado
  Future<Response<T>> delete<T>(String uri, {dynamic data, Options? options}) async {
    return _request(
          () => _dio.delete<T>(uri, data: data, options: options ?? _optionsNetwork),
      CustomTrace(StackTrace.current, message: 'DELETE $uri'),
    );
  }

  // 🔹 Método DELETE URI otimizado (RESTAURADO)

  Future<Response<T>> deleteUri<T>(Uri uri, {dynamic data, Options? options}) async {
    return _request(
          () => _dio.deleteUri<T>(uri, data: data, options: options ?? _optionsNetwork),
      CustomTrace(StackTrace.current, message: 'DELETE URI $uri'),
    );
  }

  Future<Response<T>> patchUri<T>(Uri uri, {dynamic data, Options? options}) async {
    return _request(
          () => _dio.patchUri<T>(uri, data: data, options: options ?? _optionsNetwork),
      CustomTrace(StackTrace.current, message: 'PATCH URI $uri'),
    );
  }

  // 🔹 Tratamento de execução com logging
  Future<Response<T>> _request<T>(
      Future<Response<T>> Function() request,
      CustomTrace trace,
      ) async {
    try {
      _startProgress(trace);
      final response = await request();
      return response;
    } on SocketException {
      throw Exception("No internet connection");
    } on FormatException {
      throw Exception("Unable to process the data");
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    } finally {
      _endProgress(trace);
    }
  }
  void _startProgress(CustomTrace trace) => _progress.add(trace.callerFunctionName);

  void _endProgress(CustomTrace trace) => _progress.remove(trace.callerFunctionName);

  bool isLoading( {String? task, List<String>? tasks}) => _progress.contains(task);
}
