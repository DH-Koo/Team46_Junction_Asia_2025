import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // HTTP 클라이언트 인스턴스
  final http.Client _client = http.Client();

  // GET 요청
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final requestHeaders = headers ?? ApiConfig.getAuthHeaders(token);
      print('ApiService requestHeaders: $requestHeaders');
      print('ApiService url: $url');
      final response = await _client
          .get(url, headers: requestHeaders)
          .timeout(Duration(milliseconds: ApiConfig.connectTimeout));

      print('ApiService response: ${response.body}');
      if (url.toString().contains('chat')) {
        logLong(response.body, prefix: '[GET ${response.statusCode}]');
      }
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  // POST 요청
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final requestHeaders = headers ?? ApiConfig.getAuthHeaders(token);
      final requestBody = body != null ? jsonEncode(body) : null;
      print('ApiService url: $url');
      print('ApiService requestBody: $requestBody');
      print('ApiService requestHeaders: $requestHeaders');
      final response = await _client
          .post(url, headers: requestHeaders, body: requestBody)
          .timeout(Duration(milliseconds: ApiConfig.connectTimeout));
      print('ApiService response: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  // PUT 요청
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final requestHeaders = headers ?? ApiConfig.getAuthHeaders(token);
      final requestBody = body != null ? jsonEncode(body) : null;
      print('Put ApiService url: $url');
      print('Put ApiService requestBody: $requestBody');
      final response = await _client
          .put(url, headers: requestHeaders, body: requestBody)
          .timeout(Duration(milliseconds: ApiConfig.connectTimeout));
      print('PutApiService response: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  // PATCH 요청
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final requestHeaders = headers ?? ApiConfig.getAuthHeaders(token);
      final requestBody = body != null ? jsonEncode(body) : null;

      print('ApiService url: $url');
      print('ApiService requestBody: $requestBody');

      final response = await _client
          .patch(url, headers: requestHeaders, body: requestBody)
          .timeout(Duration(milliseconds: ApiConfig.connectTimeout));
      print('ApiService response: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  // DELETE 요청 (추가 기능)
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final requestHeaders = headers ?? ApiConfig.getAuthHeaders(token);
      print('Delete ApiService url: $url');

      final response = await _client
          .delete(url, headers: requestHeaders)
          .timeout(Duration(milliseconds: ApiConfig.connectTimeout));
      print('Delete ApiService response: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  // multipart/form-data POST 요청 (파일 업로드)
  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, String> fields, // 텍스트 필드
    required List<http.MultipartFile> files, // 파일 리스트
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final request = http.MultipartRequest('POST', url);
      // 헤더 설정
      final requestHeaders = headers ?? ApiConfig.getAuthHeaders(token);
      request.headers.addAll(requestHeaders);
      // 디버깅: 요청 정보 출력
      // print('[postMultipart] URL: $url');
      // print('[postMultipart] Headers: ${request.headers}');
      // print('[postMultipart] Fields: $fields');
      // print('[postMultipart] Files count: ${files.length}');
      // for (var f in files) {
      //   //  print(
      //   //    '[postMultipart] File field: ${f.field}, filename: ${f.filename}, length: ${f.length}',
      //   //  );
      // }
      // 텍스트 필드 추가
      request.fields.addAll(fields);
      // 파일 추가
      request.files.addAll(files);
      // 요청 전송
      final streamedResponse = await request.send().timeout(
        Duration(milliseconds: ApiConfig.connectTimeout),
      );
      // print('[postMultipart] Response status: ${streamedResponse.statusCode}');
      final response = await http.Response.fromStream(streamedResponse);
      // print('[postMultipart] Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      // print('[postMultipart] Exception: $e');
      throw _handleException(e);
    }
  }

  // multipart/form-data PUT 요청 (파일 업로드)
  Future<Map<String, dynamic>> putMultipart(
    String endpoint, {
    required Map<String, String> fields, // 텍스트 필드
    required List<http.MultipartFile> files, // 파일 리스트
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final request = http.MultipartRequest('PATCH', url);
      // 헤더 설정
      final requestHeaders = headers ?? ApiConfig.getAuthHeaders(token);
      request.headers.addAll(requestHeaders);
      // 디버깅: 요청 정보 출력
      // print('[putMultipart] URL: $url');
      // print('[putMultipart] Headers: ${request.headers}');
      // print('[putMultipart] Fields: $fields');
      // print('[putMultipart] Files count: ${files.length}');
      // for (var f in files) {
      //   //  print(
      //   //    '[putMultipart] File field: ${f.field}, filename: ${f.filename}, length: ${f.length}',
      //   //  );
      // }
      // 텍스트 필드 추가
      request.fields.addAll(fields);
      // 파일 추가
      request.files.addAll(files);
      // 요청 전송
      final streamedResponse = await request.send().timeout(
        Duration(milliseconds: ApiConfig.connectTimeout),
      );
      // print('[putMultipart] Response status: ${streamedResponse.statusCode}');
      final response = await http.Response.fromStream(streamedResponse);
      // print('[putMultipart] Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      // print('[putMultipart] Exception: $e');
      throw _handleException(e);
    }
  }

  // multipart/form-data PATCH 요청 (파일 업로드)
  Future<Map<String, dynamic>> patchMultipart(
    String endpoint, {
    required Map<String, String> fields, // 텍스트 필드
    required List<http.MultipartFile> files, // 파일 리스트
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final request = http.MultipartRequest('PATCH', url);
      // 헤더 설정
      final requestHeaders = headers ?? ApiConfig.getAuthHeaders(token);
      request.headers.addAll(requestHeaders);
      // 디버깅: 요청 정보 출력
      // print('[patchMultipart] URL: $url');
      // print('[patchMultipart] Headers: ${request.headers}');
      // print('[patchMultipart] Fields: $fields');
      // print('[patchMultipart] Files count: ${files.length}');
      // for (var f in files) {
      //   //  print(
      //   //    '[patchMultipart] File field: ${f.field}, filename: ${f.filename}, length: ${f.length}',
      //   //  );
      // }
      // 텍스트 필드 추가
      request.fields.addAll(fields);
      // 파일 추가
      request.files.addAll(files);
      // 요청 전송
      final streamedResponse = await request.send().timeout(
        Duration(milliseconds: ApiConfig.connectTimeout),
      );
      // print('[patchMultipart] Response status: ${streamedResponse.statusCode}');
      final response = await http.Response.fromStream(streamedResponse);
      // print('[patchMultipart] Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      // print('[patchMultipart] Exception: $e');
      throw _handleException(e);
    }
  }

  // 응답 처리
  Map<String, dynamic> _handleResponse(http.Response response) {
    // print('ApiService response: ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        try {
          if (response.body.isEmpty) {
            return {'statusCode': response.statusCode};
          }

          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            // 원래 형태 유지
            decoded['statusCode'] = response.statusCode;
            return decoded;
          } else if (decoded is List) {
            // ✅ 배열 응답은 'results'로 감싸서 반환
            return {'statusCode': response.statusCode, 'results': decoded};
          } else {
            // 그 외 타입(문자열/숫자 등) 대비
            return {'statusCode': response.statusCode, 'data': decoded};
          }
        } catch (e) {
          throw Exception('문제가 발생하였습니다.\n\n네트워크 상태를 확인해주세요.');
        }
      case 400:
        throw Exception('잘못된 요청입니다.');
      case 401:
        throw Exception(ApiConfig.unauthorizedError);
      case 403:
        throw Exception(ApiConfig.forbiddenError);
      case 404:
        throw Exception(ApiConfig.notFoundError);
      case 500:
        throw Exception(ApiConfig.serverError);
      default:
        throw Exception('문제가 발생하였습니다.\n\n네트워크 상태를 확인해주세요.');
    }
  }

  // 예외 처리
  Exception _handleException(dynamic error) {
    if (error is Exception) {
      return error;
    }

    if (error.toString().contains('SocketException')) {
      return Exception(ApiConfig.networkError);
    }

    if (error.toString().contains('TimeoutException')) {
      return Exception(ApiConfig.timeoutError);
    }

    return Exception('알 수 없는 오류가 발생했습니다.');
  }

  // 리소스 정리
  void dispose() {
    _client.close();
  }
}

// API 응답 모델
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJson(json['data']) : null,
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }
}

String _prettyJson(String s) {
  try {
    final obj = jsonDecode(s);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(obj);
  } catch (_) {
    return s;
  }
}

void logLong(String text, {int chunkSize = 700, String? prefix}) {
  final pretty = _prettyJson(text);
  for (int i = 0; i < pretty.length; i += chunkSize) {
    // final end = min(i + chunkSize, pretty.length);
    // final head = prefix != null ? '$prefix ' : '';
  }
}
