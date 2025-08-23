import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'record_detail_chat_screen.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  // 더미 데이터
  final List<Map<String, dynamic>> gameRecords = [
    {
      'topic': '자유 주제',
      'participants': ['베이비쿼카', '플레이어2', '플레이어3'],
      'scoreChange': 15,
      'sentenceCount': 12,
      'bombCount': 2,
      'conversationAccuracy': 85.5,
      'grammarErrors': 1,
      'vocabularyErrors': 2,
      'date': '2024.01.15',
      'duration': '8분',
    },
    {
      'topic': '여행 계획',
      'participants': ['베이비쿼카', '플레이어4'],
      'scoreChange': -8,
      'sentenceCount': 15,
      'bombCount': 4,
      'conversationAccuracy': 72.3,
      'grammarErrors': 3,
      'vocabularyErrors': 1,
      'date': '2024.01.14',
      'duration': '10분',
    },
    {
      'topic': '음식 리뷰',
      'participants': ['베이비쿼카', '플레이어5', '플레이어6', '플레이어7'],
      'scoreChange': 22,
      'sentenceCount': 18,
      'bombCount': 1,
      'conversationAccuracy': 92.1,
      'grammarErrors': 0,
      'vocabularyErrors': 1,
      'date': '2024.01.13',
      'duration': '12분',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '기록',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 상단 통계 섹션
            _buildStatisticsSection(),
            const SizedBox(height: 24),

            // 전적 기록 제목
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '전적 기록',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 전적 기록 리스트
            ...gameRecords.map((record) => _buildRecordPost(record)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E4FF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '나의 통계',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // 점수 그래프와 폭탄 통계
          Row(
            children: [
              // 점수 원형 차트
              Expanded(child: _buildScoreChart()),
              const SizedBox(width: 20),
              // 평균 폭탄 수
              Expanded(child: _buildBombStatistics()),
            ],
          ),

          const SizedBox(height: 20),

          // 정확도 막대 그래프들
          _buildAccuracyBars(),
        ],
      ),
    );
  }

  Widget _buildScoreChart() {
    return Column(
      children: [
        const Text(
          '나의 점수',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: ScoreChartPainter(),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTierHexagon(1),
                  // const SizedBox(height: 4),
                  Text(
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
        ),
      ],
    );
  }

  Widget _buildTierHexagon(int tier) {
    Color tierColor = _getTierColor(tier);

    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: HexagonPainter(tierColor),
        child: Center(
          child: Text(
            tier.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
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

  Widget _buildBombStatistics() {
    return Column(
      children: [
        const Text(
          '평균 터진 폭탄',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.bomb, color: Colors.red[400], size: 20),
            const SizedBox(width: 4),
            const Text(
              '2.3',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccuracyBars() {
    final accuracyData = [
      {'label': '문장 정확도', 'value': 61.5, 'color': const Color(0xFF6366F1)},
      {'label': '어휘 정확도', 'value': 68.2, 'color': const Color(0xFF8B5CF6)},
      {'label': '문법 정확도', 'value': 50.1, 'color': const Color(0xFF06B6D4)},
    ];

    return Column(
      children: accuracyData.map((data) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['label'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${(data['value'] as double).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (data['value'] as double) / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: data['color'] as Color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecordPost(Map<String, dynamic> record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecordDetailChatScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단: 주제와 날짜
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      record['topic'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      record['date'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 참여자들
                Wrap(
                  spacing: 6,
                  children: (record['participants'] as List<String>).map((
                    participant,
                  ) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E4FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        participant,
                        style: const TextStyle(fontSize: 10, color: Colors.black87),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // 통계 정보
                Row(
                  children: [
                    // 점수 변화
                    Expanded(
                      child: _buildStatItem(
                        '점수',
                        '${record['scoreChange'] > 0 ? '+' : ''}${record['scoreChange']}',
                        record['scoreChange'] > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    // 문장 수
                    Expanded(
                      child: _buildStatItem(
                        '문장',
                        '${record['sentenceCount']}개',
                        Colors.blue,
                      ),
                    ),
                    // 폭탄 수
                    Expanded(
                      child: _buildStatItem(
                        '폭탄',
                        '${record['bombCount']}개',
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    // 회화 정확도
                    Expanded(
                      child: _buildStatItem(
                        '정확도',
                        '${record['conversationAccuracy']}%',
                        Colors.purple,
                      ),
                    ),
                    // 문법 오류
                    Expanded(
                      child: _buildStatItem(
                        '문법 오류',
                        '${record['grammarErrors']}개',
                        Colors.orange,
                      ),
                    ),
                    // 어휘 오류
                    Expanded(
                      child: _buildStatItem(
                        '어휘 오류',
                        '${record['vocabularyErrors']}개',
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class ScoreChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // 배경 원
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 진행률 호 (72% 가정)
    final progressPaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    const sweepAngle = 2 * math.pi * 0.72; // 72%
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // 시작 각도 (12시 방향)
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
      final x = center.dx + radius * 0.8 * math.cos(angle);
      final y = center.dy + radius * 0.8 * math.sin(angle);

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
