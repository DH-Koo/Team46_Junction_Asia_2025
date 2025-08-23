import '../models/report.dart';
import 'api_service.dart';
import 'api_config.dart';

class ReportService {
  static final ReportService _instance = ReportService._internal();
  factory ReportService() => _instance;
  ReportService._internal();

  final ApiService _apiService = ApiService();

  /// 1. 리포트 생성
  /// POST /api/ai/report/
  /// 채팅이 끝나고 나서 그 대화 내용을 바탕으로 리포트를 만들어 저장할 때 사용
  Future<Report> createReport({
    required String chatRoomId,
    List<Map<String, dynamic>>? messages,
    Map<String, dynamic>? metadata,
    String? token,
  }) async {
    try {
      final request = CreateReportRequest(
        chatRoomId: chatRoomId,
        messages: messages,
        metadata: metadata,
      );

      final response = await _apiService.post(
        ApiConfig.report,
        body: request.toJson(),
        token: token,
      );

      return Report.fromJson(response);
    } catch (e) {
      throw Exception('리포트 생성에 실패했습니다: $e');
    }
  }

  /// 2. 리포트 메시지 목록 조회
  /// GET /api/ai/report/messages/
  /// 특정 채팅방에 쌓인 메시지 리스트를 가져오는 API
  Future<List<ReportMessage>> getReportMessages({
    required String chatRoomId,
    String? token,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.report}messages/?chat_room_id=$chatRoomId',
        token: token,
      );

      // API 응답이 배열 형태일 경우 results 키로 래핑되어 올 수 있음
      final List<dynamic> messagesData =
          response['results'] ?? response['messages'] ?? [];

      return messagesData
          .map((messageJson) => ReportMessage.fromJson(messageJson))
          .toList();
    } catch (e) {
      throw Exception('리포트 메시지 조회에 실패했습니다: $e');
    }
  }

  /// 3. 리포트 메시지 상세 조회
  /// GET /api/ai/report/message/<message_id>/
  /// 특정 메시지 하나를 상세히 조회하는 API
  Future<ReportMessage> getMessageDetail({
    required String messageId,
    String? token,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.report}message/$messageId/',
        token: token,
      );

      return ReportMessage.fromJson(response);
    } catch (e) {
      throw Exception('메시지 상세 조회에 실패했습니다: $e');
    }
  }

  /// 4. 리포트 결과 조회 (최종 보고서)
  /// GET /api/ai/report/report/
  /// 채팅방 전체 대화를 기반으로 생성된 최종 리포트를 조회하는 API
  Future<ReportAnalysis> getReportAnalysis({
    required String chatRoomId,
    String? token,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.report}report/?chat_room_id=$chatRoomId',
        token: token,
      );

      return ReportAnalysis.fromJson(response);
    } catch (e) {
      throw Exception('리포트 분석 결과 조회에 실패했습니다: $e');
    }
  }

  /// 전체 리포트 조회 (메시지 + 분석 결과 포함)
  /// 메시지 목록과 분석 결과를 함께 가져오는 헬퍼 메서드
  Future<Report> getFullReport({
    required String chatRoomId,
    String? token,
  }) async {
    try {
      // 메시지 목록과 분석 결과를 병렬로 가져오기
      final futures = await Future.wait([
        getReportMessages(chatRoomId: chatRoomId, token: token),
        getReportAnalysis(chatRoomId: chatRoomId, token: token),
      ]);

      final messages = futures[0] as List<ReportMessage>;
      final analysis = futures[1] as ReportAnalysis;

      // Report 객체 생성 (임시 ID 사용)
      return Report(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        chatRoomId: chatRoomId,
        messages: messages,
        analysis: analysis,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'completed',
      );
    } catch (e) {
      throw Exception('전체 리포트 조회에 실패했습니다: $e');
    }
  }

  /// 리포트 생성 상태 확인
  /// 리포트 생성이 완료되었는지 확인하는 폴링용 메서드
  Future<String> checkReportStatus({
    required String reportId,
    String? token,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.report}$reportId/status/',
        token: token,
      );

      return response['status'] ?? 'processing';
    } catch (e) {
      throw Exception('리포트 상태 확인에 실패했습니다: $e');
    }
  }

  /// 채팅방별 모든 리포트 목록 조회
  Future<List<Report>> getAllReports({
    String? chatRoomId,
    String? token,
  }) async {
    try {
      String endpoint = '${ApiConfig.report}list/';
      if (chatRoomId != null) {
        endpoint += '?chat_room_id=$chatRoomId';
      }

      final response = await _apiService.get(endpoint, token: token);

      final List<dynamic> reportsData =
          response['results'] ?? response['reports'] ?? [];

      return reportsData
          .map((reportJson) => Report.fromJson(reportJson))
          .toList();
    } catch (e) {
      throw Exception('리포트 목록 조회에 실패했습니다: $e');
    }
  }
}
