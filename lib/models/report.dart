// 리포트 메시지 모델
class ReportMessage {
  final String id;
  final String content;
  final String sender; // 'user' 또는 'ai'
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ReportMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.metadata,
  });

  factory ReportMessage.fromJson(Map<String, dynamic> json) {
    return ReportMessage(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? '',
      sender: json['sender'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

// 리포트 분석 결과 모델
class ReportAnalysis {
  final String grammarFeedback;
  final String summary;
  final int score;
  final List<String> improvements;
  final Map<String, dynamic>? additionalData;

  ReportAnalysis({
    required this.grammarFeedback,
    required this.summary,
    required this.score,
    required this.improvements,
    this.additionalData,
  });

  factory ReportAnalysis.fromJson(Map<String, dynamic> json) {
    return ReportAnalysis(
      grammarFeedback: json['grammar_feedback'] ?? '',
      summary: json['summary'] ?? '',
      score: json['score'] ?? 0,
      improvements: List<String>.from(json['improvements'] ?? []),
      additionalData: json['additional_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grammar_feedback': grammarFeedback,
      'summary': summary,
      'score': score,
      'improvements': improvements,
      'additional_data': additionalData,
    };
  }
}

// 메인 리포트 모델
class Report {
  final String id;
  final String chatRoomId;
  final List<ReportMessage> messages;
  final ReportAnalysis? analysis;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status; // 'processing', 'completed', 'failed'

  Report({
    required this.id,
    required this.chatRoomId,
    required this.messages,
    this.analysis,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id']?.toString() ?? '',
      chatRoomId: json['chat_room_id']?.toString() ?? '',
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((msg) => ReportMessage.fromJson(msg))
              .toList() ??
          [],
      analysis: json['analysis'] != null
          ? ReportAnalysis.fromJson(json['analysis'])
          : null,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'processing',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_room_id': chatRoomId,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'analysis': analysis?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
    };
  }

  // 리포트 완료 여부 확인
  bool get isCompleted => status == 'completed';

  // 리포트 처리 중 여부 확인
  bool get isProcessing => status == 'processing';

  // 리포트 실패 여부 확인
  bool get isFailed => status == 'failed';
}

// 리포트 생성 요청 모델
class CreateReportRequest {
  final String chatRoomId;
  final List<Map<String, dynamic>>? messages;
  final Map<String, dynamic>? metadata;

  CreateReportRequest({required this.chatRoomId, this.messages, this.metadata});

  Map<String, dynamic> toJson() {
    return {
      'chat_room_id': chatRoomId,
      if (messages != null) 'messages': messages,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
