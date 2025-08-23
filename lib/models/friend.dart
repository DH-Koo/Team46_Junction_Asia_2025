class Friend {
  final String id;
  final String name;
  final String? clan;
  final String? description;
  final int score;
  final String? badge;
  final String? avatar;
  final bool isOnline;

  Friend({
    required this.id,
    required this.name,
    this.clan,
    this.description,
    required this.score,
    this.badge,
    this.avatar,
    this.isOnline = false,
  });

  static List<Friend> getMockFriends() {
    return [
      Friend(id: '1', name: '김윤데', score: 10000, badge: '🏆', isOnline: true),
      Friend(
        id: '2',
        name: '현의솔렌',
        clan: '왕기모찌',
        score: 9899,
        badge: '🎯',
        isOnline: true,
      ),
      Friend(
        id: '3',
        name: '슈퍼둥준',
        clan: 'TeamRED',
        score: 8913,
        badge: '⚔️',
        isOnline: false,
      ),
      Friend(
        id: '4',
        name: '부욱부욱',
        clan: '아둔토라이...',
        score: 8122,
        badge: '🎯',
        isOnline: true,
      ),
      Friend(id: '5', name: '뿌헌좀', score: 6342, badge: '🎯', isOnline: false),
      Friend(
        id: '6',
        name: '클래식 로얄젤리',
        score: 5274,
        badge: '🏅',
        isOnline: false,
      ),
    ];
  }
}
