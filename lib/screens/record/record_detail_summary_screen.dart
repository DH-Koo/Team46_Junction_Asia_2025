import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class RecordDetailSummaryScreen extends StatelessWidget {
  final RecordItem record;
  
  const RecordDetailSummaryScreen({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 성과 요약
          _buildPerformanceSummary(),
          
          const SizedBox(height: 24),
          
          // 강점과 개선점
          _buildStrengthsAndWeaknesses(),
          
          const SizedBox(height: 24),
          
          // 학습 팁
          _buildLearningTips(),
        ],
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MaterialSymbols.analytics,
                size: 24,
                color: Colors.purple[600],
              ),
              const SizedBox(width: 12),
              Text(
                '성과 요약',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 점수 분포
          Row(
            children: [
              Expanded(
                child: _buildScoreIndicator('정확성', 85, Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildScoreIndicator('유창성', 78, Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildScoreIndicator('자연스러움', 82, Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator(String label, int score, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthsAndWeaknesses() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MaterialSymbols.psychology,
                size: 24,
                color: Colors.blue[600],
              ),
              const SizedBox(width: 12),
              Text(
                '강점과 개선점',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 강점
          _buildStrengthWeaknessItem(
            '강점',
            [
              '음식 주문 관련 어휘를 잘 활용했습니다',
              '적절한 예의를 지켰습니다',
              '명확하게 의사를 표현했습니다',
            ],
            Colors.green,
            Icons.check_circle,
          ),
          
          const SizedBox(height: 16),
          
          // 개선점
          _buildStrengthWeaknessItem(
            '개선점',
            [
              '더 자연스러운 표현을 사용할 수 있습니다',
              '문맥에 맞지 않는 대화가 있었습니다',
              '발음의 정확성을 높일 수 있습니다',
            ],
            Colors.orange,
            Icons.info,
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthWeaknessItem(
    String title,
    List<String> points,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        ...points.map((point) => Padding(
          padding: const EdgeInsets.only(left: 28.0, bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  point,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildLearningTips() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MaterialSymbols.lightbulb,
                size: 24,
                color: Colors.yellow[700],
              ),
              const SizedBox(width: 12),
              Text(
                '학습 팁',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          _buildTipItem(
            '맥락 이해하기',
            '대화의 흐름을 파악하고 적절한 응답을 연습해보세요.',
            Icons.psychology,
            Colors.purple,
          ),
          
          const SizedBox(height: 16),
          
          _buildTipItem(
            '자연스러운 표현',
            '교과서적인 표현보다는 실제 상황에서 사용하는 표현을 학습하세요.',
            Icons.chat_bubble,
            Colors.blue,
          ),
          
          const SizedBox(height: 16),
          
          _buildTipItem(
            '정기적인 연습',
            '매일 조금씩이라도 꾸준히 연습하는 것이 중요합니다.',
            Icons.schedule,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecordItem {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String duration;
  final int score;
  final String category;

  RecordItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.duration,
    required this.score,
    required this.category,
  });
}
