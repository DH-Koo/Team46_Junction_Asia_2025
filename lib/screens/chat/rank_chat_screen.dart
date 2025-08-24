import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'dart:async';

class RankChatScreen extends StatefulWidget {
  const RankChatScreen({super.key});

  @override
  State<RankChatScreen> createState() => _RankChatScreenState();
}

class _RankChatScreenState extends State<RankChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Can you help me?", isFromUser: false, senderName: "구구"),
    ChatMessage(text: "How can I help you?", isFromUser: true),
    ChatMessage(
      text: "What is the most popular food in the restaruant?",
      isFromUser: false,
      senderName: "장원영",
    ),
    ChatMessage(
      text: "We have korean fried chicken.",
      isFromUser: false,
      senderName: "구구",
    ),
    ChatMessage(text: "I like watching baseball.", isFromUser: true),
  ];

  // 카운트다운 관련 변수들
  bool _isCountdownActive = true;
  bool _isGameStarted = false;
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
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          // 시간 종료 처리
        }
      });
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
                    "Ordering food at a restaurant.",
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
                    widthFactor: 0.65, // 65% 진행률
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[300],
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
                  name: "베이비쿼카",
                  score: "2991",
                  medalColor: Colors.orange[700]!,
                  borderColor: Colors.grey[500]!,
                  borderWidth: 1,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: CharacterCard(
                  rank: 2,
                  name: "구구",
                  score: "1246",
                  medalColor: Colors.grey[400]!,
                  borderColor: Colors.purple[200]!,
                  borderWidth: 2,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: CharacterCard(
                  rank: 1,
                  name: "장원영",
                  score: "3321",
                  medalColor: Colors.yellow[700]!,
                  borderColor: Colors.grey[500]!,
                  borderWidth: 1,
                ),
              ),
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
        return _buildMessageBubble(message);
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
      // 구구 메시지 (왼쪽 정렬)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아바타
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  message.senderName ?? "구구",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderName ?? "구구",
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
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 전송 버튼
          const Icon(Icons.send, color: Colors.black, size: 30),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _countdownController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final String? senderName;

  ChatMessage({required this.text, required this.isFromUser, this.senderName});
}

class CharacterCard extends StatelessWidget {
  final int rank;
  final String name;
  final String score;
  final Color medalColor;
  final Color borderColor;
  final double borderWidth;

  const CharacterCard({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
    required this.medalColor,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Column(
        children: [
          //   // 메달
          //   Container(
          //     width: 32,
          //     height: 32,
          //     decoration: BoxDecoration(
          //       color: medalColor,
          //       shape: BoxShape.circle,
          //     ),
          //     child: Center(
          //       child: Text(
          //         rank.toString(),
          //         style: TextStyle(
          //           color: rank == 1 ? Colors.black : Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),

          //   const SizedBox(height: 8),

          // 캐릭터 이미지
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset(
              'assets/image/character.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 8),

          // 이름
          Text(
            name,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),

          //const SizedBox(height: 4),
          // 점수
          Text(
            score,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
