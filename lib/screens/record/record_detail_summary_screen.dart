import 'package:flutter/material.dart';
import 'package:team46_junction_asia_2025/screens/chat/practice_chat_screen.dart';

class RecordDetailSummaryScreen extends StatefulWidget {
  const RecordDetailSummaryScreen({super.key});

  @override
  State<RecordDetailSummaryScreen> createState() =>
      _RecordDetailSummaryScreenState();
}

class _RecordDetailSummaryScreenState extends State<RecordDetailSummaryScreen> {
  int selectedTabIndex = 0; // 0: 문법, 1: 어휘

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 16),
                  // "Cheer up!" 텍스트와 박수 이모지
                  Row(
                    children: [
                      const Text(
                        'Cheer up!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('👏', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  SizedBox(width: 16),
                  Image.asset(
                    'assets/motion/motion4.gif',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(width: 16),
                  // 캐릭터 이미지
                ],
              ),

              const SizedBox(height: 24),

              // 제목 입력 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title',
                      style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ordering food at a restaurant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 탭 버튼들
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 0
                              ? const Color(0xFFE8E4FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedTabIndex == 0
                                ? const Color(0xFFE8E4FF)
                                : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '문법 (5)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selectedTabIndex == 0
                                  ? Colors.black
                                  : const Color(0xFF9E9E9E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 1
                              ? const Color(0xFFE8E4FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedTabIndex == 1
                                ? const Color(0xFFE8E4FF)
                                : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '어휘 (12)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selectedTabIndex == 1
                                  ? Colors.black
                                  : const Color(0xFF9E9E9E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 내용 영역
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: ListView(
                    children: [
                      // 문법 섹션 1
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1. ${selectedTabIndex == 0 ? '문법' : '어휘'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '예문예문예문예문예문예문예문예문예문예문',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '예문예문예문예문예문예문예문예문예문예문',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 문법 섹션 2
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2. ${selectedTabIndex == 0 ? '문법' : '어휘'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '예문예문예문예문예문예문예문예문예문예문',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '예문예문예문예문예문예문예문예문예문예문',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 하단 버튼들
              Row(
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
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E4FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'AI와 연습하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E4FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
