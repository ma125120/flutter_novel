import 'dart:async';
import 'dart:convert';
import 'package:flutter_novel/components/loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter_novel/config/index.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

typedef RequestCallBack = void Function(Map data);

class HttpRequest {
  static String baseUrl = MyConfig.baseurl;

  static Dio dio = new Dio();

  static _addCache() {
    // Global options
    final options = CacheOptions(
      store: DbCacheStore(), // Required.
      policy: CachePolicy
          .requestFirst, // Default. Requests first and caches response.
      hitCacheOnErrorExcept: [
        401,
        403
      ], // Optional. Returns a cached response on error if available but for statuses 401 & 403.
      priority: CachePriority
          .normal, // Optional. Default. Allows 3 cache levels and ease cleanup.
      maxStale: const Duration(
          days:
              7), // Very optional. Overrides any HTTP directive to delete entry past this duration.
    );
    dio.interceptors.add(DioCacheInterceptor(options: options));
  }

  static init() {
    // dio.defa
    dio.options.connectTimeout = MyConfig.timeout;
    dio.options.receiveTimeout = MyConfig.timeout;

    _addCache();

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      return options;
    }, onResponse: (Response response) async {
      // int code = response.data['header']['code'];
      // print('状态码： $code');
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) async {
      MyLoading.hide('请求失败');

      // Do something with response error
      return e; //continue
    }));
  }

  static String getUrl(String url) {
    if (url.startsWith(('http'))) {
      return url;
    }
    return baseUrl + url;
  }

  static Future<dynamic> _request<T>(String uri,
      {String method,
      Map<String, String> params,
      Map<String, String> data,
      Map<String, String> headers,
      Map<String, dynamic> extra,
      bool needLoading}) async {
    try {
      String url = getUrl(uri);

      if (needLoading) {
        MyLoading.show(url);
      }
      Response<T> res = await dio.request(url,
          queryParameters: params,
          data: data,
          // options: Options(
          //   headers: headers,
          //   method: method,
          //   extra: {
          //     'needLoading': needLoading ?? true,
          //     ...(extra ?? {}),
          //   },
          // ),
          options: Options(
            headers: headers,
            method: method,
            extra: {
              'needLoading': needLoading ?? true,
              ...(CacheOptions(policy: CachePolicy.refresh).toExtra())
            },
          )
          //  buildCacheOptions(
          //   Duration(days: 7),
          //   forceRefresh: true,
          //   options: Options(
          //     headers: headers,
          //     method: method,
          //     extra: {
          //       'needLoading': needLoading ?? true,
          //       ...(extra ?? {}),
          //     },
          //   ),
          // ),
          );

      if (needLoading) {
        MyLoading.complete(url);
      }

      dynamic result = handleResponse(res);
      return result;
    } on Exception catch (e) {
      print('[uri=$uri]exception e=${e.toString()}');
      return null;
    }
  }

  static Future<dynamic> get<T>(String uri,
      {Map<String, String> params,
      Map<String, String> headers,
      Map<String, dynamic> extra,
      bool needLoading}) async {
    return _request(uri,
        method: 'GET',
        params: params,
        headers: headers,
        extra: extra,
        needLoading: needLoading);
  }

  static Future<dynamic> post<T>(String uri,
      {Map<String, String> params,
      Map<String, String> data,
      Map<String, String> headers,
      Map<String, dynamic> extra,
      bool needLoading}) async {
    return _request(uri,
        method: 'POST',
        data: data,
        params: params,
        headers: headers,
        extra: extra,
        needLoading: needLoading);
  }

  static handleResponse(Response response) {
    var res = response.data;
    if (res is String) return jsonDecode(res.replaceAll('},]', '}]'))['data'];

    return res['data'];
  }
}
