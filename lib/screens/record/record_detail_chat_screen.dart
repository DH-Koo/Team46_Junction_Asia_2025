import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class RecordDetailChatScreen extends StatefulWidget {
  const RecordDetailChatScreen({super.key});

  @override
  State<RecordDetailChatScreen> createState() => _RecordDetailChatScreenState();
}

class _RecordDetailChatScreenState extends State<RecordDetailChatScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Are you ready to order?",
      isFromUser: false,
      senderName: "구구",
    ),
    ChatMessage(
      text: "Yes. Can I have a cheeseburger and fries, please?",
      isFromUser: true,
    ),
    ChatMessage(
      text: "Sure. Would you like a drink?",
      isFromUser: false,
      senderName: "구구",
    ),
    ChatMessage(
      text: "I like watching baseball.",
      isFromUser: true,
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
            Expanded(
              child: _buildChatMessages(),
            ),
            
            // 피드백 섹션
            _buildFeedbackSection(),
            
            // 이전/다음 버튼
            _buildNavigationButtons(),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildFeedbackSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 말풍선
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
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
                      Text(
                        "Bad",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text("😢", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "이것은 맥락에 맞지 않습니다. 이 경우에는 '네, 콜라 한 잔 주세요'와 같이 대답할 수 있습니다.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 캐릭터 (말풍선이 가리키는 부분)
          Stack(
            alignment: Alignment.center,
            children: [
              // 말풍선 꼬리
              Positioned(
                left: -8,
                top: 20,
                child: CustomPaint(
                  size: const Size(20, 20),
                  painter: SpeechBubbleTailPainter(),
                ),
              ),
              
              // 캐릭터
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.purple[200],
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    // 캐릭터 기본 모양
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.purple[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            "Y",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // 선글라스
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        width: 30,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    
                    // 망토
                    Positioned(
                      bottom: 0,
                      left: 10,
                      child: Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
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

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 이전 버튼
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  "prev",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 다음 버튼
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  "next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final String? senderName;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    this.senderName,
  });
}

class SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // 테두리
    final borderPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}