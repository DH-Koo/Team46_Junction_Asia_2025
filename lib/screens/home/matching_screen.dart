import 'dart:math';
import 'package:flutter/material.dart';
import '../chat/rank_chat_screen.dart';
import '../../services/chat_websocket_service.dart';

class MatchingScreen extends StatefulWidget {
  final Map<String, dynamic> gameSettings;

  const MatchingScreen({super.key, required this.gameSettings});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen>
    with TickerProviderStateMixin {
  int currentPhraseIndex = 0;
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;
  
  // 웹소켓 서비스
  final ChatWebSocketService _webSocketService = ChatWebSocketService();
  bool _isMatching = false;
  String? _matchingError;

  // 한국어/영어 더미 데이터
  final List<Map<String, String>> phrases = [
    {
      'korean': '안녕하세요! 오늘 날씨가 정말 좋네요.',
      'english': 'Hello! The weather is really nice today.',
    },
    {
      'korean': '대화를 시작할 준비가 되었나요?',
      'english': 'Are you ready to start the conversation?',
    },
    {
      'korean': '함께 즐거운 시간을 보내봐요!',
      'english': 'Let\'s have a great time together!',
    },
    {
      'korean': '상대방을 기다리고 있어요.',
      'english': 'I\'m waiting for the other player.',
    },
    {
      'korean': '곧 매칭이 완료될 거예요.',
      'english': 'The matching will be completed soon.',
    },
    {
      'korean': '오늘은 어떤 주제로 이야기할까요?',
      'english': 'What topic shall we talk about today?',
    },
    {
      'korean': '새로운 친구를 만날 수 있어서 기뻐요!',
      'english': 'I\'m excited to meet a new friend!',
    },
    {
      'korean': '언어 교환을 통해 많이 배우고 싶어요.',
      'english': 'I want to learn a lot through language exchange.',
    },
    {
      'korean': '난 보통 공원에서 강아지들을 산책시켜!',
      'english': 'I usually walk my dogs at the park!',
    },
    {
      'korean': '오늘 새로운 언어를 배우고 있어.',
      'english': 'I am learning a new language today',
    },
    {
      'korean': '친구들과 함께 영화를 보러 갈 예정이야.',
      'english': 'I plan to go watch a movie with friends',
    },
    {
      'korean': '매일 아침 요가를 하며 하루를 시작해!',
      'english': 'I start my day with yoga every morning!',
    },
    {
      'korean': '주말엔 항상 새로운 요리에 도전해봐!',
      'english': 'I always try new recipes on weekends!',
    },
    {
      'korean': '책을 읽으며 커피 한 잔 마시는 걸 좋아해.',
      'english': 'I love reading books while having coffee',
    },
    {
      'korean': '자전거를 타고 도시를 둘러보는 중이야!',
      'english': 'I am exploring the city by bicycle!',
    },
    {
      'korean': '음악을 들으며 그림을 그리고 있어.',
      'english': 'I am drawing while listening to music',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bubbleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.elasticOut),
    );

    _bubbleController.forward();
    _startPhraseRotation();
    
    // 웹소켓으로 매칭 큐에 참가
    _startMatching();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _webSocketService.dispose();
    super.dispose();
  }

  void _startPhraseRotation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _changePhrase();
        _startPhraseRotation();
      }
    });
  }

  void _changePhrase() {
    setState(() {
      int newIndex;
      do {
        newIndex = Random().nextInt(phrases.length);
      } while (newIndex == currentPhraseIndex && phrases.length > 1);
      currentPhraseIndex = newIndex;
    });

    _bubbleController.reset();
    _bubbleController.forward();
  }

  // 매칭 시작
  void _startMatching() async {
    setState(() {
      _isMatching = true;
      _matchingError = null;
    });

    try {
      await _webSocketService.joinMatchingQueue(
        userId: 1, // 실제로는 사용자 ID를 동적으로 가져와야 함
        partySize: widget.gameSettings['party_size'] ?? 2,
        onMatched: _onMatched,
        onError: _onMatchingError,
      );
    } catch (e) {
      setState(() {
        _matchingError = '매칭 시작 실패: $e';
        _isMatching = false;
      });
    }
  }

  // 매칭 완료 처리
  void _onMatched(int chatRoomId) {
    setState(() {
      _isMatching = false;
    });
    
    // 매칭 완료 후 채팅 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RankChatScreen(),
      ),
    );
  }

  // 매칭 오류 처리
  void _onMatchingError(String error) {
    setState(() {
      _matchingError = error;
      _isMatching = false;
    });
  }

  void _cancelMatching() {
    // 웹소켓 연결 해제
    _webSocketService.leaveMatchingQueue();
    _webSocketService.disconnect();
    Navigator.of(context).pop();
  }

  void _navigateToRankChat() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RankChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // 개발용 이동 버튼들 (상단에 추가)
              Expanded(
                child: ElevatedButton(
                  onPressed: _navigateToRankChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '[개발용] 랭크 채팅',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 매칭 제목
              const Text(
                '상대방을 찾고 있어요...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 60),

              // 말풍선 (고정 크기)
              AnimatedBuilder(
                animation: _bubbleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _bubbleAnimation.value,
                    child: Container(
                      width: 280, // 고정 너비
                      height: 120, // 고정 높이 (한국어 2줄 + 영어 2줄)
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E4FF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            phrases[currentPhraseIndex]['english']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            phrases[currentPhraseIndex]['korean']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // 말풍선 꼬리
              Container(
                margin: const EdgeInsets.only(left: 40),
                child: CustomPaint(
                  size: const Size(20, 15),
                  painter: BubbleTailPainter(),
                ),
              ),

              const SizedBox(height: 20),

              // 캐릭터 애니메이션 (중앙에 크게)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/motion/motion1.gif',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E4FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.black54,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const Spacer(),

              // 매칭 상태 표시
              if (_matchingError != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[400], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _matchingError!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (_isMatching)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFB8A9FF),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '매칭 중...',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                )
              else
                const Text(
                  '매칭 대기 중...',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

              const SizedBox(height: 40),

              // 오류 발생 시 재시도 버튼
              if (_matchingError != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _startMatching,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8A9FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '재시도',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 취소 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _cancelMatching,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// 말풍선 꼬리를 그리는 CustomPainter
class BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8E4FF)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.3, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
