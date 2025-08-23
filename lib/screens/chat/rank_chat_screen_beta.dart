import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../services/api_config.dart';

class RankChatScreenBeta extends StatefulWidget {
  final int roomId;
  final int userId;

  const RankChatScreenBeta({
    super.key,
    required this.roomId,
    required this.userId,
  });

  @override
  State<RankChatScreenBeta> createState() => _RankChatScreenBetaState();
}

class _RankChatScreenBetaState extends State<RankChatScreenBeta>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  // 웹소켓 관련 변수들
  WebSocketChannel? _channel;
  bool _isConnected = false;

  // 메시지 애니메이션 관련 변수들
  List<AnimationController> _messageControllers = [];
  List<Animation<double>> _messageAnimations = [];

  // 폭탄 인디케이터 관련 변수들
  double _bombProgress = 1.0; // 진행 바 값 (1.0 = 100%, 0.0 = 0%)
  Timer? _bombTimer;
  bool _isBombActive = false;

  // 캐릭터 하이라이트 관련 변수들
  int _highlightedCharacterIndex = -1; // 하이라이트된 캐릭터 인덱스 (-1 = 없음)
  bool _isBombExploded = false; // 폭탄이 터졌는지 상태

  // 게임 재시작 시 타이머 상태 저장
  int _savedRemainingSeconds = 180; // 저장된 남은 시간

  // 카운트다운 관련 변수들
  bool _isCountdownActive = true;
  bool _isGameStarted = false;
  int _countdownNumber = 3;
  String _countdownText = "3";

  // 타이머 관련 변수들
  Timer? _timer;
  int _remainingSeconds = 180; // 3분 = 180초

  // 애니메이션 컨트롤러
  late AnimationController _countdownController;
  late Animation<double> _countdownAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _countdownController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _countdownAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _countdownController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _countdownController, curve: Curves.easeInOut),
    );

    // 카운트다운 시작
    _startCountdown();
  }

  void _startCountdown() async {
    // 3초 카운트다운
    for (int i = 3; i >= 1; i--) {
      setState(() {
        _countdownNumber = i;
        _countdownText = i.toString();
      });

      _countdownController.reset();
      _countdownController.forward();

      await Future.delayed(const Duration(seconds: 1));
    }

    // START! 표시
    setState(() {
      _countdownText = "START!";
    });

    _countdownController.reset();
    _countdownController.forward();

    await Future.delayed(const Duration(seconds: 1));

    // 카운트다운 완료, 게임 시작
    setState(() {
      _isCountdownActive = false;
      _isGameStarted = true;
    });

    // 타이머 시작
    _startTimer();

    // 웹소켓 연결
    _connectWebSocket();
  }

  // 웹소켓 연결
  void _connectWebSocket() {
    try {
      final uri = Uri.parse(
        'ws://${ApiConfig.host}/ws/chat/${widget.roomId}/${widget.userId}/',
      );
      print('웹소켓 연결 시도: $uri');

      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (message) {
          _handleWebSocketMessage(message);
        },
        onError: (error) {
          print('웹소켓 오류: $error');
          _showErrorSnackBar('웹소켓 연결 오류: $error');
        },
        onDone: () {
          print('웹소켓 연결 종료');
          setState(() {
            _isConnected = false;
          });
        },
      );

      setState(() {
        _isConnected = true;
      });

      print('웹소켓 연결 성공');
    } catch (e) {
      print('웹소켓 연결 실패: $e');
      _showErrorSnackBar('웹소켓 연결 실패: $e');
    }
  }

  // 웹소켓 메시지 처리
  void _handleWebSocketMessage(dynamic message) {
    try {
      print('수신된 메시지: $message');

      final data = jsonDecode(message);

      if (data['event'] == 'message') {
        final text = data['text'] as String;
        final sender = data['sender'] as int;
        final images = data['images'] as List<dynamic>?;
        final imgUrls = data['img_urls'] as List<dynamic>?;
        final isFromUser = sender == 2; // sender가 1인 경우 유저 메시지로 간주

        // 로컬에서 보낸 메시지가 아닌 경우에만 메시지 추가
        if (!isFromUser) {
          final chatMessage = ChatMessage(
            text: text,
            isFromUser: isFromUser,
            senderName: "Student1",
            imgIds: images?.cast<int>() ?? [],
          );

          _addMessage(chatMessage);

          // 상대방 메시지 수신 시 왼쪽 카드 하이라이트
          setState(() {
            _highlightedCharacterIndex = 0; // IBM (왼쪽)
          });

          // 폭탄 인디케이터 시작
          _resetBombIndicator();
        }
      } else if (data['type'] == 'read') {
        // 읽음 확인 처리
        final msgId = data['msg_id'] as int;
        print('메시지 읽음 확인: $msgId');
      }
    } catch (e) {
      print('메시지 파싱 오류: $e');
    }
  }

  // 메시지 추가
  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });

    // 메시지 애니메이션 컨트롤러 추가
    final controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    final animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    _messageControllers.add(controller);
    _messageAnimations.add(animation);

    // 애니메이션 시작
    controller.forward();
  }

  // 메시지 전송
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || !_isConnected) return;

    try {
      final message = {
        'type': 'message',
        'text': text,
        'room_id': widget.roomId,
        'user_id': widget.userId,
      };

      _channel!.sink.add(jsonEncode(message));

      // 내 메시지 추가 (로컬에서 즉시 표시)
      final chatMessage = ChatMessage(text: text, isFromUser: true, imgIds: []);

      _addMessage(chatMessage);

      // 내 메시지 전송 시 오른쪽 카드 하이라이트
      setState(() {
        _highlightedCharacterIndex = 1; // Student1 (오른쪽)
      });

      // 입력 필드 초기화
      _messageController.clear();

      // 폭탄 인디케이터 시작
      _resetBombIndicator();
    } catch (e) {
      print('메시지 전송 오류: $e');
      _showErrorSnackBar('메시지 전송 실패: $e');
    }
  }

  // 읽음 확인 전송
  void _sendReadConfirmation(int msgId) {
    if (!_isConnected) return;

    try {
      final readMessage = {
        'event': 'read',
        'msg_id': msgId,
        'user_id': widget.userId,
        'read_count': _messages.length,
      };

      _channel!.sink.add(jsonEncode(readMessage));
    } catch (e) {
      print('읽음 확인 전송 오류: $e');
    }
  }

  // 에러 스낵바 표시
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _resetBombIndicator() {
    // 기존 타이머 취소
    _bombTimer?.cancel();

    // 폭탄 터짐 상태 초기화
    setState(() {
      _bombProgress = 1.0;
      _isBombActive = true;
      _isBombExploded = false;
    });

    // 진행 바가 점점 줄어들도록 타이머 시작
    _bombTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_bombProgress > 0.0) {
          _bombProgress -= 0.005; // 1.5초 동안 0%까지 줄어들도록
        } else {
          _bombProgress = 0.0;
          _isBombActive = false;
          _isBombExploded = true; // 폭탄이 터짐
          timer.cancel();

          // motion5.gif가 한번 진행된 후 게임 재시작
          Future.delayed(const Duration(milliseconds: 5500), () {
            _restartGame();
          });
        }
      });
    });
  }

  void _restartGame() {
    // 기존 타이머들 취소
    _timer?.cancel();
    _bombTimer?.cancel();

    // 웹소켓 연결 해제
    _disconnectWebSocket();

    // 상태 초기화
    setState(() {
      _isGameStarted = false;
      _isCountdownActive = true;
      _countdownNumber = 3;
      _countdownText = "3";
      _remainingSeconds = _savedRemainingSeconds; // 저장된 시간에서 시작
      _messages.clear();
      _highlightedCharacterIndex = -1;
      _isBombExploded = false;
      _bombProgress = 1.0;
      _isBombActive = false;
    });

    // 메시지 애니메이션 컨트롤러들 리셋
    for (var controller in _messageControllers) {
      controller.dispose();
    }
    _messageControllers.clear();
    _messageAnimations.clear();

    // 카운트다운 다시 시작
    _startCountdown();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          // 현재 남은 시간을 저장 (게임 재시작 시 사용)
          _savedRemainingSeconds = _remainingSeconds;
        } else {
          timer.cancel();
          // 시간 종료 처리
        }
      });
    });
  }

  // 웹소켓 연결 해제
  void _disconnectWebSocket() {
    if (_channel != null) {
      _channel!.sink.close(status.goingAway);
      _channel = null;
    }
    setState(() {
      _isConnected = false;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 메인 콘텐츠
          SafeArea(
            child: Column(
              children: [
                // 상단 헤더
                _buildHeader(),

                // 캐릭터 이미지들
                _buildCharacterRow(),

                // 채팅 메시지 영역
                Expanded(child: _buildChatMessages()),

                // 추천 응답 및 입력 영역
                _buildBottomSection(),
              ],
            ),
          ),

          // 카운트다운 오버레이
          if (_isCountdownActive)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: AnimatedBuilder(
                  animation: _countdownController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _countdownAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          _countdownText,
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.1),
          //     spreadRadius: 1,
          //     blurRadius: 3,
          //     offset: const Offset(0, 1),
          //   ),
        ],
      ),
      child: Row(
        children: [
          // 레스토랑 컨텍스트
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[100],
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //   Text(
                  //     "Restaurant",
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.grey[600],
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  //   const SizedBox(height: 2),
                  Text(
                    "Is it right to tell a white lie?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 시간
          Column(
            children: [
              Text(
                "Time",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _isGameStarted ? _formatTime(_remainingSeconds) : "3:00",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        children: [
          // 폭탄 아이콘과 진행바
          Row(
            children: [
              const Icon(Symbols.bomb, color: Colors.black, size: 30, fill: 1),

              const SizedBox(width: 8),

              // 진행바
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _bombProgress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isBombActive
                            ? Colors.red[400]!
                            : Colors.green[300]!,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 캐릭터 카드들
          Row(
            children: [
              Expanded(
                child: CharacterCard(
                  rank: 3,
                  name: "IBM (Me)",
                  score: "2991",
                  medalColor: Colors.orange[700]!,
                  borderColor: Colors.grey[500]!,
                  borderWidth: 1,
                  isHighlighted: _highlightedCharacterIndex == 0,
                  isBombExploded:
                      _isBombExploded && _highlightedCharacterIndex == 0,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: CharacterCard(
                  rank: 2,
                  name: "Student1",
                  score: "1246",
                  medalColor: Colors.grey[400]!,
                  borderColor: Colors.grey[500]!,
                  borderWidth: 1,
                  isHighlighted: _highlightedCharacterIndex == 1,
                  isBombExploded:
                      _isBombExploded && _highlightedCharacterIndex == 1,
                ),
              ),

              //   const SizedBox(width: 12),

              //   Expanded(
              //     child: CharacterCard(
              //       rank: 1,
              //       name: "Student2",
              //       score: "3321",
              //       medalColor: Colors.yellow[700]!,
              //       borderColor: Colors.grey[500]!,
              //       borderWidth: 1,
              //       isHighlighted: _highlightedCharacterIndex == 2,
              //       isBombExploded: _isBombExploded && _highlightedCharacterIndex == 2,
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final animationIndex = index < _messageAnimations.length ? index : 0;

        return AnimatedBuilder(
          animation: _messageAnimations[animationIndex],
          builder: (context, child) {
            final animationValue = _messageAnimations[animationIndex].value
                .clamp(0.0, 1.0);
            return Transform.scale(
              scale: animationValue,
              child: Opacity(
                opacity: animationValue,
                child: _buildMessageBubble(message),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isFromUser) {
      // 사용자 메시지 (오른쪽 정렬)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFE8E4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Student1 메시지 (왼쪽 정렬)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/image/ybm_2d-1.png', width: 40, height: 40),

            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderName ?? "Student1",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          // 입력 필드
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 전송 버튼
          GestureDetector(
            onTap: _sendMessage,
            child: const Icon(Icons.send, color: Colors.black, size: 30),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _countdownController.dispose();
    _timer?.cancel();
    _bombTimer?.cancel();
    _disconnectWebSocket();
    for (var controller in _messageControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final String? senderName;
  final List<int> imgIds;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    this.senderName,
    this.imgIds = const [],
  });
}

class CharacterCard extends StatelessWidget {
  final int rank;
  final String name;
  final String score;
  final Color medalColor;
  final Color borderColor;
  final double borderWidth;
  final bool isHighlighted;
  final bool isBombExploded;

  const CharacterCard({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
    required this.medalColor,
    required this.borderColor,
    required this.borderWidth,
    this.isHighlighted = false,
    this.isBombExploded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? Colors.orange : borderColor,
          width: isHighlighted ? 3.0 : borderWidth,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // 캐릭터 이미지 (폭탄 터짐 시 motion5.gif, 하이라이트 시 motion3.gif, 일반 시 PNG)
          SizedBox(
            width: 60,
            height: 60,
            child: isBombExploded && isHighlighted
                ? Image.asset('assets/motion/motion5.gif', fit: BoxFit.contain)
                : isHighlighted
                ? Image.asset('assets/motion/motion3.gif', fit: BoxFit.contain)
                : Image.asset(
                    'assets/image/character.png',
                    fit: BoxFit.contain,
                  ),
          ),

          const SizedBox(height: 8),

          // 이름
          Text(
            name,
            style: TextStyle(
              fontSize: 15,
              color: isHighlighted ? Colors.orange[700] : Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),

          //   // 점수
          //   Text(
          //     score,
          //     style: TextStyle(
          //       fontSize: 18,
          //       color: isHighlighted ? Colors.orange[700] : Colors.black,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
        ],
      ),
    );
  }
}
