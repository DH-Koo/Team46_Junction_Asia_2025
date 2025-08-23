import 'package:flutter/foundation.dart';
import '../models/report.dart';
import '../services/report_service.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();

  // 현재 리포트 상태
  Report? _currentReport;
  List<ReportMessage> _messages = [];
  ReportAnalysis? _analysis;

  // 리포트 목록
  List<Report> _reports = [];

  // 로딩 상태
  bool _isLoading = false;
  bool _isCreatingReport = false;
  bool _isLoadingMessages = false;
  bool _isLoadingAnalysis = false;

  // 에러 상태
  String? _error;

  // Getters
  Report? get currentReport => _currentReport;
  List<ReportMessage> get messages => _messages;
  ReportAnalysis? get analysis => _analysis;
  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  bool get isCreatingReport => _isCreatingReport;
  bool get isLoadingMessages => _isLoadingMessages;
  bool get isLoadingAnalysis => _isLoadingAnalysis;
  String? get error => _error;

  /// 1. 리포트 생성
  /// rank_chat_screen에서 대화가 끝난 후 호출
  Future<void> createReport({
    required String roomId,
    required String userId,
  }) async {
    _isCreatingReport = true;
    _error = null;
    notifyListeners();

    try {
      final report = await _reportService.createReport(
        roomId: roomId,
        userId: userId,
      );

      _currentReport = report;

      // 리포트 목록에 추가
      _reports.insert(0, report);

      _isCreatingReport = false;
      notifyListeners();

      // 리포트 생성 후 메시지 목록 자동 로드
      await loadReportMessages(chatRoomId: roomId);
    } catch (e) {
      _error = e.toString();
      _isCreatingReport = false;
      notifyListeners();
      debugPrint('리포트 생성 실패: $e');
      rethrow;
    }
  }

  /// 2. 리포트 메시지 목록 조회
  /// record_detail_chat_screen에서 호출
  Future<void> loadReportMessages({required String chatRoomId}) async {
    _isLoadingMessages = true;
    _error = null;
    notifyListeners();

    try {
      final messages = await _reportService.getReportMessages(
        chatRoomId: chatRoomId,
      );

      _messages = messages;
      _isLoadingMessages = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingMessages = false;
      notifyListeners();
      debugPrint('메시지 목록 로드 실패: $e');
    }
  }

  /// 3. 특정 메시지 상세 조회
  Future<ReportMessage?> getMessageDetail({required String messageId}) async {
    try {
      final message = await _reportService.getMessageDetail(
        messageId: messageId,
      );
      return message;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      debugPrint('메시지 상세 조회 실패: $e');
      return null;
    }
  }

  /// 4. 리포트 분석 결과 조회
  /// record_detail_summary_screen에서 호출
  Future<void> loadReportAnalysis({
    required String chatRoomId,
    String? userId,
  }) async {
    _isLoadingAnalysis = true;
    _error = null;
    notifyListeners();

    try {
      final analysis = await _reportService.getReportAnalysis(
        chatRoomId: chatRoomId,
        userId: userId,
      );

      _analysis = analysis;

      // 현재 리포트에 분석 결과 업데이트
      if (_currentReport != null) {
        _currentReport = Report(
          id: _currentReport!.id,
          chatRoomId: _currentReport!.chatRoomId,
          messages: _currentReport!.messages,
          analysis: analysis,
          createdAt: _currentReport!.createdAt,
          updatedAt: DateTime.now(),
          status: 'completed',
        );
      }

      _isLoadingAnalysis = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingAnalysis = false;
      notifyListeners();
      debugPrint('분석 결과 로드 실패: $e');
    }
  }

  /// 전체 리포트 조회 (메시지 + 분석 결과)
  Future<void> loadFullReport({
    required String chatRoomId,
    String? userId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final report = await _reportService.getFullReport(
        chatRoomId: chatRoomId,
        userId: userId,
      );

      _currentReport = report;
      _messages = report.messages;
      _analysis = report.analysis;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('전체 리포트 로드 실패: $e');
    }
  }

  /// 모든 리포트 목록 조회
  Future<void> loadAllReports({String? chatRoomId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final reports = await _reportService.getAllReports(
        chatRoomId: chatRoomId,
      );

      _reports = reports;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('리포트 목록 로드 실패: $e');
    }
  }

  /// 리포트 생성 상태 확인 (폴링)
  Future<void> checkReportStatus({required String reportId}) async {
    try {
      final status = await _reportService.checkReportStatus(reportId: reportId);

      // 현재 리포트 상태 업데이트
      if (_currentReport != null && _currentReport!.id == reportId) {
        _currentReport = Report(
          id: _currentReport!.id,
          chatRoomId: _currentReport!.chatRoomId,
          messages: _currentReport!.messages,
          analysis: _currentReport!.analysis,
          createdAt: _currentReport!.createdAt,
          updatedAt: DateTime.now(),
          status: status,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('리포트 상태 확인 실패: $e');
    }
  }

  /// 특정 리포트 선택
  void setCurrentReport(Report report) {
    _currentReport = report;
    _messages = report.messages;
    _analysis = report.analysis;
    notifyListeners();
  }

  /// 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 상태 초기화
  void clear() {
    _currentReport = null;
    _messages = [];
    _analysis = null;
    _reports = [];
    _isLoading = false;
    _isCreatingReport = false;
    _isLoadingMessages = false;
    _isLoadingAnalysis = false;
    _error = null;
    notifyListeners();
  }

  /// 메시지 추가 (실시간 업데이트용)
  void addMessage(ReportMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  /// 메시지 업데이트
  void updateMessage(String messageId, ReportMessage updatedMessage) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = updatedMessage;
      notifyListeners();
    }
  }

  /// 메시지 삭제
  void removeMessage(String messageId) {
    _messages.removeWhere((msg) => msg.id == messageId);
    notifyListeners();
  }
}
