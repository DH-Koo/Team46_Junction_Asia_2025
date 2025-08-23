import 'dart:math';
import 'package:flutter/material.dart';
import '../chat/practice_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTopicIndex = 0;
  final List<String> topics = ['자유', '재미', '학습'];
  int currentTier = 1; // 현재 티어 (1-4)
  int currentPhraseIndex = 0; // 현재 문구 인덱스

  // 더미 문구 데이터
  final List<Map<String, String>> phrases = [
    {
      'korean': '난 보통 공원에서 강아지들을 산책시켜.',
      'english': 'I usually walk my dogs at the park',
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
      'korean': '매일 아침 요가를 하며 하루를 시작해.',
      'english': 'I start my day with yoga every morning',
    },
    {
      'korean': '주말엔 항상 새로운 요리에 도전해봐.',
      'english': 'I always try new recipes on weekends',
    },
    {
      'korean': '책을 읽으며 커피 한 잔 마시는 걸 좋아해.',
      'english': 'I love reading books while having coffee',
    },
    {
      'korean': '자전거를 타고 도시를 둘러보는 중이야.',
      'english': 'I am exploring the city by bicycle',
    },
    {
      'korean': '음악을 들으며 그림을 그리고 있어.',
      'english': 'I am drawing while listening to music',
    },
  ];

  void _changePhrase() {
    setState(() {
      int newIndex;
      do {
        newIndex = Random().nextInt(phrases.length);
      } while (newIndex == currentPhraseIndex && phrases.length > 1);
      currentPhraseIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 상단 헤더
              SizedBox(height: 20),
              Row(
                children: [
                  // 닉네임과 점수 박스
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E4FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '베이비쿼카',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          // 티어 육각형
                          _buildTierHexagon(currentTier),
                          const SizedBox(width: 4),
                          const Text(
                            '360',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  // 트로피 박스
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // 말풍선
              GestureDetector(
                onTap: _changePhrase,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E4FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phrases[currentPhraseIndex]['korean']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        phrases[currentPhraseIndex]['english']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 캐릭터 이미지
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/image/character.png',
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              // 주제 선택 토글
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(topics.length, (index) {
                  final isSelected = selectedTopicIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTopicIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey[700] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[400]!, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getTopicIcon(index),
                            size: 16,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            topics[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // 하단 버튼들
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PracticeChatScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8A9FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              '연습',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8A9FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            '랭크',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierHexagon(int tier) {
    Color tierColor = _getTierColor(tier);

    return Container(
      width: 28,
      height: 28,
      child: CustomPaint(
        painter: HexagonPainter(tierColor),
        child: Center(
          child: Text(
            tier.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getTierColor(int tier) {
    switch (tier) {
      case 1:
        return const Color(0xFFCD7F32); // 브론즈
      case 2:
        return const Color(0xFFC0C0C0); // 실버
      case 3:
        return const Color(0xFFFFD700); // 골드
      case 4:
        return const Color(0xFF50C878); // 에메랄드
      default:
        return const Color(0xFFCD7F32); // 기본 브론즈
    }
  }

  IconData _getTopicIcon(int index) {
    switch (index) {
      case 0:
        return Icons.chat_outlined;
      case 1:
        return Icons.sports_esports_outlined;
      case 2:
        return Icons.school_outlined;
      default:
        return Icons.chat_outlined;
    }
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;

  HexagonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 육각형 그리기
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (3.14159 / 180); // 60도씩 회전
      final x = center.dx + radius * 0.8 * cos(angle);
      final y = center.dy + radius * 0.8 * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
