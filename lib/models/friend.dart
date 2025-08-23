import 'package:flutter/material.dart';

class Friend {
  final String id;
  final String name;
  final int score;
  final String? avatar;
  final bool isOnline;

  Friend({
    required this.id,
    required this.name,
    required this.score,
    this.avatar,
    this.isOnline = false,
  });

  // 점수에 따른 육각형 티어 계산
  int get tier {
    if (score < 400) return 1;
    if (score < 800) return 2;
    if (score < 1200) return 3;
    return 4;
  }

  // 티어 이름 반환
  String get tierName {
    switch (tier) {
      case 1:
        return 'Bronze';
      case 2:
        return 'Silver';
      case 3:
        return 'Gold';
      case 4:
        return 'Diamond';
      default:
        return 'Bronze';
    }
  }

  // 티어별 색상 반환
  Color get tierColor {
    switch (tier) {
      case 1:
        return const Color(0xFFCD7F32); // Bronze
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFFFD700); // Gold
      case 4:
        return const Color(0xFF00CED1); // Diamond
      default:
        return const Color(0xFFCD7F32);
    }
  }

  static List<Friend> getMockFriends() {
    return [
      // Tier 4 (Diamond) - 1200+ 점수
      Friend(
        id: '1',
        name: 'YBM',
        score: 1850,
        avatar: 'assets/image/ybm_2d-1.png',
        isOnline: true,
      ),
      Friend(
        id: '2',
        name: '마이크로소프트',
        score: 1420,
        avatar: 'assets/image/ybm_2d-2.png',
        isOnline: false,
      ),

      // Tier 3 (Gold) - 800-1199 점수
      Friend(
        id: '3',
        name: '업스테이지',
        score: 1050,
        avatar: 'assets/image/ybm_2d-3.png',
        isOnline: true,
      ),
      Friend(
        id: '4',
        name: '산군',
        score: 890,
        avatar: 'assets/image/ybm_2d-1.png',
        isOnline: false,
      ),

      // Tier 2 (Silver) - 400-799 점수
      Friend(
        id: '5',
        name: '경상북도',
        score: 650,
        avatar: 'assets/image/ybm_2d-5.png',
        isOnline: true,
      ),
      Friend(
        id: '6',
        name: '포스텍',
        score: 520,
        avatar: 'assets/image/ybm_2d-6.png',
        isOnline: false,
      ),
    ];
  }
}
