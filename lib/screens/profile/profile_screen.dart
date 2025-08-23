import 'package:flutter/material.dart';
import '../../models/friend.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friends = Friend.getMockFriends();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '프로필',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings, color: Colors.black),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '베이비쿼카',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.edit, color: Colors.grey[500], size: 24),
            ],
          ),
          // 친구 초대 버튼
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '친구 초대',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 순위표 헤더
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF2A3454),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              '순위표',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // 친구 목록
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF2A3454),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return _buildFriendItem(friend, index + 1);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendItem(Friend friend, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3C4B6B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4A5568), width: 1),
      ),
      child: Row(
        children: [
          // 아바타
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF6B7B9A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),

          const SizedBox(width: 12),

          // 클랜 배지 (있는 경우)
          if (friend.clan != null) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getClanColor(friend.clan!),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],

          // 이름과 클랜 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (friend.clan != null)
                  Text(
                    friend.clan!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),

          // 배지
          if (friend.badge != null) ...[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _getBadgeColor(friend.badge!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  friend.badge!,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // 트로피와 점수
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                friend.score.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getClanColor(String clan) {
    switch (clan) {
      case 'TeamRED':
        return Colors.red;
      case '왕기모찌':
        return Colors.pink;
      case '아둔토라이...':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Color _getBadgeColor(String badge) {
    switch (badge) {
      case '🏆':
        return Colors.orange;
      case '🎯':
        return Colors.red;
      case '⚔️':
        return Colors.grey;
      case '🏅':
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }
}
