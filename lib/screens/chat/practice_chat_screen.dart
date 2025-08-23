import 'package:flutter/material.dart';

class PracticeChatScreen extends StatefulWidget {
  const PracticeChatScreen({super.key});

  @override
  State<PracticeChatScreen> createState() => _PracticeChatScreenState();
}

class _PracticeChatScreenState extends State<PracticeChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _showRecommendations = false; // 추천 응답 표시 여부를 제어하는 상태 변수
  final Map<int, bool> _showTranslations = {}; // 각 메시지의 번역 표시 여부를 제어하는 상태 변수
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Are you ready to order?",
      isFromUser: false,
      senderName: "구구",
      koreanTranslation: "주문 준비되셨나요?",
    ),
    ChatMessage(
      text: "Yes. Can I have a cheeseburger and fries, please?",
      isFromUser: true,
    ),
    ChatMessage(
      text: "Sure. Would you like a drink?",
      isFromUser: false,
      senderName: "구구",
      koreanTranslation: "물론이죠, 음료 필요하세요?",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            _buildHeader(),

            // 채팅 메시지 영역
            Expanded(child: _buildChatMessages()),

            // 추천 응답 및 입력 영역
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // 레스토랑 컨텍스트
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Restaurant",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Ordering food at a restaurant.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 시간
          Column(
            children: [
              Text(
                "Time",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "2:37",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isFromUser) {
      // 사용자 메시지 (오른쪽 정렬)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFE8E4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // 구구 메시지 (왼쪽 정렬)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아바타
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  message.senderName ?? "구구",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderName ?? "구구",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                IntrinsicWidth(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              // 한국어 번역 (전구 아이콘 클릭 시에만 표시)
                              if (_showTranslations[_messages.indexOf(
                                        message,
                                      )] ==
                                      true &&
                                  message.koreanTranslation != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  message.koreanTranslation!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 전구 아이콘 (번역 토글 기능)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            final messageIndex = _messages.indexOf(message);
                            _showTranslations[messageIndex] =
                                !(_showTranslations[messageIndex] ?? false);
                          });
                        },
                        child: Icon(
                          _showTranslations[_messages.indexOf(message)] == true
                              ? Icons.lightbulb
                              : Icons.lightbulb_outline,
                          color:
                              _showTranslations[_messages.indexOf(message)] ==
                                  true
                              ? Colors.amber
                              : Colors.amber[600],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          // 추천 응답 영역 (전구 아이콘 클릭 시에만 표시)
          if (_showRecommendations) ...[
            // 추천 응답 헤더
            Row(
              children: [
                Text(
                  "✨ Recommend for you",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.purple[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 추천 응답 버튼들
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildRecommendationButton("Yes, I'll have a cola."),
                  const SizedBox(width: 8),
                  _buildRecommendationButton("No, thanks."),
                  const SizedBox(width: 8),
                  _buildRecommendationButton(
                    "Could you recommend something else?",
                  ),
                  const SizedBox(width: 8),
                  _buildRecommendationButton("I'd like to see the menu."),
                  const SizedBox(width: 8),
                  _buildRecommendationButton("What's your specialty?"),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],

          const SizedBox(height: 16),

          // 메시지 입력 영역
          Row(
            children: [
              // 전구 아이콘 (클릭 가능)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showRecommendations = !_showRecommendations;
                  });
                },
                child: Icon(
                  _showRecommendations
                      ? Icons.lightbulb
                      : Icons.lightbulb_outline,
                  color: _showRecommendations
                      ? Colors.amber
                      : Colors.amber[600],
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // 입력 필드
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 전송 버튼
              const Icon(Icons.send, color: Colors.black, size: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          textAlign: TextAlign.start,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final String? senderName;
  final String? koreanTranslation; // 한국어 번역 추가

  ChatMessage({
    required this.text,
    required this.isFromUser,
    this.senderName,
    this.koreanTranslation,
  });
}
