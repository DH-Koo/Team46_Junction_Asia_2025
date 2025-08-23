class ApiConfig {
  // 기본 API URL 설정
  static const String baseUrl = 'http://172.30.1.53:8000/api'; // HTTP로 변경
  static const String serverUrl = 'http://172.30.1.53:8000'; // 서버 기본 URL

  // API 엔드포인트들
  static const String report = '/ai/report/';

  // HTTP 요청 설정
  static const int connectTimeout = 30000; // 30초
  static const int receiveTimeout = 30000; // 30초

  // 기본 헤더 설정
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 인증 토큰을 포함한 헤더 생성
  static Map<String, String> getAuthHeaders(String? token) {
    Map<String, String> headers = Map.from(defaultHeaders);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Token $token';
    }
    return headers;
  }

  // 이미지 URL 처리 유틸리티 함수
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // 이미 전체 URL인 경우 그대로 반환
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    // 상대 경로인 경우 서버 URL과 결합
    return '$serverUrl$imagePath';
  }

  // 에러 메시지
  static const String networkError = '네트워크 연결을 확인해주세요.';
  static const String serverError = '서버 오류가 발생했습니다.';
  static const String timeoutError = '요청 시간이 초과되었습니다.';
  static const String unauthorizedError = '인증이 필요합니다.';
  static const String forbiddenError = '접근 권한이 없습니다.';
  static const String notFoundError = '요청한 리소스를 찾을 수 없습니다.';
}
