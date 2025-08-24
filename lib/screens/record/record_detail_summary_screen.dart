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
                      'Is it right to tell a white lie?',
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

              // // 탭 버튼들
              // Row(
              //   children: [
              //     Expanded(
              //       child: GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             selectedTabIndex = 0;
              //           });
              //         },
              //         child: Container(
              //           padding: const EdgeInsets.symmetric(vertical: 12),
              //           decoration: BoxDecoration(
              //             color: selectedTabIndex == 0
              //                 ? const Color(0xFFE8E4FF)
              //                 : Colors.white,
              //             borderRadius: BorderRadius.circular(8),
              //             border: Border.all(
              //               color: selectedTabIndex == 0
              //                   ? const Color(0xFFE8E4FF)
              //                   : const Color(0xFFE0E0E0),
              //             ),
              //           ),
              //           child: Center(
              //             child: Text(
              //               '문법 (5)',
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w600,
              //                 color: selectedTabIndex == 0
              //                     ? Colors.black
              //                     : const Color(0xFF9E9E9E),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             selectedTabIndex = 1;
              //           });
              //         },
              //         child: Container(
              //           padding: const EdgeInsets.symmetric(vertical: 12),
              //           decoration: BoxDecoration(
              //             color: selectedTabIndex == 1
              //                 ? const Color(0xFFE8E4FF)
              //                 : Colors.white,
              //             borderRadius: BorderRadius.circular(8),
              //             border: Border.all(
              //               color: selectedTabIndex == 1
              //                   ? const Color(0xFFE8E4FF)
              //                   : const Color(0xFFE0E0E0),
              //             ),
              //           ),
              //           child: Center(
              //             child: Text(
              //               '어휘 (12)',
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w600,
              //                 color: selectedTabIndex == 1
              //                     ? Colors.black
              //                     : const Color(0xFF9E9E9E),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 24),

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
                      if (selectedTabIndex == 0) ...[
                        // 문법 섹션 - 전체 요약
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '전체 요약',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '사용자는 \'선의의 거짓말\' 주제에서 의견을 논리적으로 제시하며 상황에 따른 태도의 차이를 설명했다.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 문법 섹션 - 하이라이트
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '주요 사항',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '• 공감과 친절을 강조하며 논리적 이유 제시',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• 질문에 맞게 일관된 답변 제공',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• 긍정적인 태도로 대화 지속',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 문법 섹션 - 개선점
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '개선 권장사항',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '• 같은 의미의 단어를 다양하게 활용해 어휘 폭을 넓힐 것',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• \'but\' 대신 다양한 연결어 사용 연습',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• 예시 상황을 더 구체적으로 제시해 설득력 강화',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // 어휘 섹션 - 미리보기
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '대화 미리보기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '주제에 맞게 논리적으로 답변했으며 친절과 정직의 균형을 강조함',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 어휘 섹션 - 어휘 분석
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '어휘 사용 분석',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '• 논리적 표현: 의견 제시, 상황 설명',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• 감정 표현: 공감, 친절, 긍정적',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• 연결어: but, and 등 기본 연결어 사용',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 어휘 섹션 - 어휘 확장 제안
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '어휘 확장 제안',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '• 연결어: however, moreover, furthermore',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• 감정 표현: empathetic, considerate, thoughtful',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• 논리적 표현: demonstrate, illustrate, exemplify',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                            'Practice with AI',
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
