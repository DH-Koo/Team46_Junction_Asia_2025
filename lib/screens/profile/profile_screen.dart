import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          '프로필 정보',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 닉네임
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '베이비쿼카',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, size: 20, color: Colors.grey),
                ],
              ),

              const SizedBox(height: 30),

              // 통계 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('출석 시간', '24h 35m'),
                  _buildStatItem('연속 학습일', '0d'),
                  _buildStatItem('누적 학습일', '98d'),
                ],
              ),

              const SizedBox(height: 40),

              // 리그 포인트 섹션
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '리그 포인트',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '리그 대회 →',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Total Point
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Text(
                      'Total Point',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '--',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 카테고리 목록
              _buildCategoryItem('여행', '--'),
              _buildCategoryItem('음식', '--'),
              _buildCategoryItem('리스닝', '--'),
              _buildCategoryItem('회화 표현', '--'),
              _buildCategoryItem('발음 구별', '--'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String title, String points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.circle, color: Colors.grey[500], size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Text(points, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// 말풍선 꼬리 그리기
class SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6B7280)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(15, 0);
    path.lineTo(7, 15);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// 리본 그리기
class RibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9B7EFF)
      ..style = PaintingStyle.fill;

    // 왼쪽 리본
    final leftRibbon = Path();
    leftRibbon.moveTo(5, 10);
    leftRibbon.lineTo(20, 5);
    leftRibbon.lineTo(20, 25);
    leftRibbon.lineTo(0, 30);
    leftRibbon.close();

    // 오른쪽 리본
    final rightRibbon = Path();
    rightRibbon.moveTo(30, 5);
    rightRibbon.lineTo(45, 10);
    rightRibbon.lineTo(50, 30);
    rightRibbon.lineTo(30, 25);
    rightRibbon.close();

    canvas.drawPath(leftRibbon, paint);
    canvas.drawPath(rightRibbon, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
