import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'api_config.dart';

class ChatWebSocketService {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  Function(int)? _onMatched;
  Function(String)? _onError;

  bool get isConnected => _isConnected;

  // 매칭 큐에 참가
  Future<void> joinMatchingQueue({
    required int userId,
    required int partySize,
    required Function(int) onMatched,
    required Function(String) onError,
  }) async {
    _onMatched = onMatched;
    _onError = onError;

    try {
      final uri = Uri.parse('ws://${ApiConfig.host}/ws/match/?user_id=$userId');
      print('uri: $uri');
      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          _onError?.call('웹소켓 연결 오류: $error');
        },
        onDone: () {
          _isConnected = false;
          _onError?.call('웹소켓 연결이 종료되었습니다.');
        },
      );

      // 큐에 참가하는 메시지 전송
      final joinMessage = {
        'type': 'join_queue',
        'user_id': userId,
        'party_size': partySize,
      };

      print('joinMessage: $joinMessage');

      _channel!.sink.add(jsonEncode(joinMessage));
      _isConnected = true;
    } catch (e) {
      _onError?.call('웹소켓 연결 실패: $e');
    }
  }

  // 메시지 처리
  void _handleMessage(dynamic message) {
    try {
      // 모든 서버 응답을 출력
      print('서버 응답: $message');
      
      final data = jsonDecode(message);

      if (data['event'] == 'matched') {
        final chatRoomId = data['chat_room_id'] as int;
        print('매칭 성공! 채팅방 ID: $chatRoomId');
        _onMatched?.call(chatRoomId);
        disconnect();
      } else if (data['event'] == 'error') {
        print('서버 오류: ${data['message'] ?? '알 수 없는 오류가 발생했습니다.'}');
        _onError?.call(data['message'] ?? '알 수 없는 오류가 발생했습니다.');
      } else {
        // 기타 이벤트들도 출력
        print('기타 이벤트: ${data['event']} - 데이터: $data');
      }
    } catch (e) {
      print('메시지 파싱 오류: $e');
      _onError?.call('메시지 파싱 오류: $e');
    }
  }

  // 매칭 큐에서 나가기
  void leaveMatchingQueue() {
    if (_isConnected && _channel != null) {
      final leaveMessage = {'type': 'leave_queue'};
      _channel!.sink.add(jsonEncode(leaveMessage));
    }
  }

  // 연결 해제
  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close(status.goingAway);
      _channel = null;
    }
    _isConnected = false;
  }

  // 리소스 정리
  void dispose() {
    disconnect();
  }
}
