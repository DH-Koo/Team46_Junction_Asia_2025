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
      'scoreChange': 60,
      'currentScore': 400, // 게임 후 점수
      'previousScore': 340, // 게임 전 점수
      'tier': 2,
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
      'scoreChange': -20,
      'currentScore': 340, // 게임 후 점수
      'previousScore': 360, // 게임 전 점수
      'tier': 1,
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
      'scoreChange': 80,
      'currentScore': 360, // 게임 후 점수
      'previousScore': 280, // 게임 전 점수
      'tier': 1,
      'sentenceCount': 18,
      'bombCount': 1,
      'conversationAccuracy': 92.1,
      'grammarErrors': 0,
      'vocabularyErrors': 1,
      'date': '2024.01.13',
      'duration': '12분',
    },
    {
      'topic': '영화 토론',
      'participants': ['베이비쿼카', '플레이어8', '플레이어9'],
      'scoreChange': 60,
      'currentScore': 280, // 게임 후 점수
      'previousScore': 220, // 게임 전 점수
      'tier': 1,
      'sentenceCount': 22,
      'bombCount': 0,
      'conversationAccuracy': 100.0,
      'grammarErrors': 0,
      'vocabularyErrors': 0,
      'date': '2024.01.12',
      'duration': '15분',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('전적 기록'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  _buildTierHexagon(2),
                  // const SizedBox(height: 4),
                  Text(
                    '400',
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
            Icon(Symbols.bomb, color: Colors.black, size: 20, fill: 1),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E4FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        participant,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // 통계 정보 - 새로운 레이아웃
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 왼쪽: 티어, 점수, 점수 변화
                    Expanded(flex: 1, child: _buildScoreSection(record)),
                    const SizedBox(width: 16),
                    // 오른쪽: 막대 그래프들
                    Expanded(flex: 2, child: _buildStatsBars(record)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSection(Map<String, dynamic> record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 티어와 점수
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTierHexagon(record['tier']),
            const SizedBox(width: 8),
            Text(
              '${record['currentScore']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 점수 변화
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: record['scoreChange'] > 0
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: record['scoreChange'] > 0 ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Text(
            '${record['scoreChange'] > 0 ? '+' : ''}${record['scoreChange']}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: record['scoreChange'] > 0 ? Colors.green : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBars(Map<String, dynamic> record) {
    final statsData = [
      {
        'label': '정확도',
        'value': record['sentenceCount'],
        'maxValue': 20,
        'color': const Color(0xFF6366F1),
        'accuracy': record['conversationAccuracy'],
      },
      {
        'label': '터진 폭탄',
        'value': record['bombCount'],
        'maxValue': 5,
        'color': Colors.red[400],
      },
      {
        'label': '문법 오류',
        'value': record['grammarErrors'],
        'maxValue': 5,
        'color': Colors.orange[400],
      },
      {
        'label': '어휘 오류',
        'value': record['vocabularyErrors'],
        'maxValue': 5,
        'color': Colors.orange[600],
      },
    ];

    return Column(
      children: statsData.map((data) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['label'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      if (data['accuracy'] != null) ...[
                        // 정확도 항목의 경우 (문장 개수) 퍼센트 순서로 표시
                        Text(
                          '(총 문장 ${data['value']}개)',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(data['accuracy'] as double).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ] else ...[
                        // 다른 항목들은 기존 방식
                        Text(
                          '${data['value']}개',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ],
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
                  widthFactor: data['accuracy'] != null
                      ? (data['accuracy'] as double) /
                            100 // 정확도는 퍼센트 기준
                      : (data['value'] as int) / (data['maxValue'] as int),
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

    // 진행률 호 (5% 가정)
    final progressPaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    const sweepAngle = 2 * math.pi * 0.05; // 5%
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
