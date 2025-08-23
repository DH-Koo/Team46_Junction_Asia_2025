import 'package:flutter/material.dart';
import 'record_detail_summary_screen.dart';

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
    ChatMessage(text: "I like watching baseball.", isFromUser: true),
    ChatMessage(text: "Oh, then would you want some coke?", isFromUser: false),

    ChatMessage(text: "Yes, I'd like a coke.", isFromUser: true),
    ChatMessage(text: "I'd like a coke.", isFromUser: false),

    ChatMessage(text: "I'd like a coke.", isFromUser: true),
  ];

  // 현재 단계 (사용자 대화 인덱스)
  int _currentStep = 0;

  // 사용자 대화의 인덱스들을 저장
  late List<int> _userMessageIndices;

  // 스크롤 컨트롤러 추가
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 사용자 메시지의 인덱스들을 찾아서 저장
    _userMessageIndices = _messages
        .asMap()
        .entries
        .where((entry) => entry.value.isFromUser)
        .map((entry) => entry.key)
        .toList();
  }

  // 현재 단계까지의 메시지만 표시
  List<ChatMessage> get _visibleMessages {
    if (_userMessageIndices.isEmpty) return _messages;

    int endIndex = _userMessageIndices[_currentStep];
    return _messages.take(endIndex + 1).toList();
  }

  // 다음 단계로 이동
  void _nextStep() {
    if (_currentStep < _userMessageIndices.length - 1) {
      setState(() {
        _currentStep++;
      });

      // 새로운 메시지가 추가된 후 자동으로 스크롤
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  // 이전 단계로 이동
  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // 현재 단계의 사용자 메시지 인덱스
  int? get _currentUserMessageIndex {
    if (_userMessageIndices.isEmpty ||
        _currentStep >= _userMessageIndices.length) {
      return null;
    }
    return _userMessageIndices[_currentStep];
  }

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
      child: Row(
        children: [
          // 뒤로가기 버튼
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
            style: IconButton.styleFrom(
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.all(8),
            ),
          ),
          //const SizedBox(width: 12),
          // 주제 박스
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[100],
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //   Text(
                  //     "Restaurant",
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.grey[600],
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  //   const SizedBox(height: 2),
                  Text(
                    "Ordering food at a restaurant",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: _visibleMessages.length,
      itemBuilder: (context, index) {
        final message = _visibleMessages[index];
        final isCurrentUserMessage = index == _currentUserMessageIndex;
        return _buildMessageBubble(message, isCurrentUserMessage);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isHighlighted) {
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
                  border: isHighlighted
                      ? Border.all(color: Colors.purple[300]!, width: 0.7)
                      : null,
                  boxShadow: isHighlighted
                      ? [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
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
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  'assets/image/ybm_2d-1.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 13,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: Image.asset(
              'assets/motion/motion6.gif',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          // 말풍선
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[400]!),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.1),
                //     spreadRadius: 1,
                //     blurRadius: 3,
                //     offset: const Offset(0, 1),
                //   ),
                // ],
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
                    "문맥에 맞지 않는 말이에요.\n이 경우엔 'Yes, i'll have a coke'\n와 같이 답변할 수 있어요.",
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
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final canGoPrev = _currentStep > 0;
    final isLastStep = _currentStep == _userMessageIndices.length - 1;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 이전 버튼
          Expanded(
            child: Container(
              height: 50,
              //   decoration: BoxDecoration(
              //     color: canGoPrev ? Color(0xFFE8E4FF) : Colors.grey[300],
              //     borderRadius: BorderRadius.circular(25),
              //   ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: canGoPrev ? _prevStep : null,
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "prev",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 단계 표시
          Text(
            '${_currentStep + 1} / ${_userMessageIndices.length}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.purple[700],
            ),
          ),

          const SizedBox(width: 16),

          // 다음/완료 버튼
          Expanded(
            child: Container(
              height: 50,
              //   decoration: BoxDecoration(
              //     color: isLastStep ? Colors.green[100] : Color(0xFFE8E4FF),
              //     borderRadius: BorderRadius.circular(25),
              //   ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: isLastStep ? _finishChat : _nextStep,
                  child: Center(
                    child: isLastStep
                        ? Text(
                            "Finish",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "next",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 채팅 완료 후 요약 화면으로 이동
  void _finishChat() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const RecordDetailSummaryScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final String? senderName;

  ChatMessage({required this.text, required this.isFromUser, this.senderName});
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
