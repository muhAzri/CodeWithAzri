// coverage:ignore-file
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class DioInterceptor {
  final Dio _dio = Dio();
  static final DioInterceptor _singleton = DioInterceptor._internal();

  factory DioInterceptor() {
    return _singleton;
  }

  DioInterceptor._internal() {
    _dio.options.baseUrl = const String.fromEnvironment("BASE_URL");
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveDataWhenStatusError = true;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await FirebaseAuth.instance.currentUser?.getIdToken();
        if (token != null) {
          options.headers['Authorization'] = "Bearer $token";
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          Navigator.pushNamedAndRemoveUntil(
              globalNavigatorKey.currentState!.context,
              AppRoutes.onboardScreen,
              (route) => false);
        }

        handler.reject(error);
      },
    ));
  }

  Future<Response> apiPost(String endPoint, {dynamic data}) async {
    return _dio.post(endPoint, data: data);
  }

  Future<Response> apiGet(String endPoint, {dynamic data}) async {
    return _dio.get(endPoint, queryParameters: data);
  }

  Future<Response> apiDelete(String endPoint, {dynamic data}) async {
    return _dio.delete(endPoint, data: data);
  }

  Future<Response> apiPut(String endPoint, {dynamic data}) async {
    return _dio.put(endPoint, data: data);
  }

  Future<Response> apiPatch(String endPoint, {dynamic data}) async {
    return _dio.patch(endPoint, data: data);
  }
}
