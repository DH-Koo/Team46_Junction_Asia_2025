import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '../chat/practice_chat_screen.dart';
import '../chat/rank_chat_screen.dart';
import '../record/record_list_screen.dart';
import '../profile/profile_screen.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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

  // 게임 상태 관리
  bool isGameStarting = false;
  int countdown = 3;
  Timer? countdownTimer;

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
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void _showGameSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const GameSettingsDialog();
      },
    ).then((result) {
      if (result != null) {
        _startGame(result);
      }
    });
  }

  void _startGame(Map<String, dynamic> settings) {
    setState(() {
      isGameStarting = true;
      countdown = 3;
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });

      if (countdown <= 0) {
        timer.cancel();
        _navigateToGame(settings);
      }
    });
  }

  void _navigateToGame(Map<String, dynamic> settings) {
    final gameMode = settings['mode'];

    if (gameMode == 'practice') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PracticeChatScreen()),
      ).then((_) {
        setState(() {
          isGameStarting = false;
          countdown = 3;
        });
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RankChatScreen()),
      ).then((_) {
        setState(() {
          isGameStarting = false;
          countdown = 3;
        });
      });
    }
  }

  void _cancelGame() {
    countdownTimer?.cancel();
    setState(() {
      isGameStarting = false;
      countdown = 3;
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
                          const SizedBox(width: 10),
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
                  // 프로필 버튼
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecordScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF73BEFF).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Symbols.article, size: 40, color: Colors.grey[700]),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '자주 틀리는 문법',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'IBM님은 3인칭 단수 문법을 자주 틀려요.',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[700]),
                        ],
                      ),
                    ),
                  ),

              const Spacer(),

              // // 말풍선
              // GestureDetector(
              //   onTap: _changePhrase,
              //   child: Container(
              //     margin: const EdgeInsets.symmetric(horizontal: 20),
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       color: const Color(0xFFE8E4FF),
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           phrases[currentPhraseIndex]['korean']!,
              //           style: const TextStyle(
              //             fontSize: 12,
              //             color: Colors.black87,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         const SizedBox(height: 4),
              //         Text(
              //           phrases[currentPhraseIndex]['english']!,
              //           style: const TextStyle(
              //             fontSize: 12,
              //             color: Colors.black87,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 20),

              // 캐릭터 이미지
              SizedBox(
                width: 210,
                height: 210,
                child: Image.asset(
                  'assets/image/character.png',
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              // 하단 Play/Cancel 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: isGameStarting ? _cancelGame : _showGameSettingsDialog,
                  child: isGameStarting
                      ? Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cancel',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '$countdown',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 90,
                          child: Image.asset(
                            'assets/image/play_button.png',
                            fit: BoxFit.contain,
                          ),
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

class GameSettingsDialog extends StatefulWidget {
  const GameSettingsDialog({super.key});

  @override
  State<GameSettingsDialog> createState() => _GameSettingsDialogState();
}

class _GameSettingsDialogState extends State<GameSettingsDialog> {
  String selectedMode = 'practice'; // 'practice' or 'rank'
  String selectedTopic = '자유';
  int selectedPlayerCount = 2;

  final List<String> topics = ['자유', '재미', '학습'];
  final List<int> playerCounts = [2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            const Center(
              child: Text(
                '게임 설정',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 모드 선택
            const Text(
              '모드 선택',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildModeButton('연습', 'practice')),
                const SizedBox(width: 12),
                Expanded(child: _buildModeButton('랭크', 'rank')),
              ],
            ),

            const SizedBox(height: 20),

            // 주제 선택
            const Text(
              '주제 선택',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: topics.map((topic) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _buildTopicButton(topic),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // 인원 수 선택
            const Text(
              '인원 수',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: playerCounts.map((count) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _buildPlayerCountButton(count),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // 버튼들
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop({
                        'mode': selectedMode,
                        'topic': selectedTopic,
                        'playerCount': selectedPlayerCount,
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFFB8A9FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, String mode) {
    final isSelected = selectedMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB8A9FF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFB8A9FF) : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicButton(String topic) {
    final isSelected = selectedTopic == topic;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTopic = topic;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB8A9FF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFB8A9FF) : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            topic,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCountButton(int count) {
    final isSelected = selectedPlayerCount == count;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlayerCount = count;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB8A9FF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFB8A9FF) : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            '$count명',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
