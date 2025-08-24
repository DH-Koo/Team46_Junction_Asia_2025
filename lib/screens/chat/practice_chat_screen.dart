import 'package:flutter/material.dart';
import 'dart:async';

class PracticeChatScreen extends StatefulWidget {
  const PracticeChatScreen({super.key});

  @override
  State<PracticeChatScreen> createState() => _PracticeChatScreenState();
}

class _PracticeChatScreenState extends State<PracticeChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _showRecommendations = false; // 추천 응답 표시 여부를 제어하는 상태 변수
  final Map<int, bool> _showTranslations = {}; // 각 메시지의 번역 표시 여부를 제어하는 상태 변수
  final Map<int, bool> _messageVisibility = {}; // 각 메시지의 표시 여부를 제어하는 상태 변수
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "I think white lies is sometimes okay.",
      isFromUser: true,
    ),
    ChatMessage(
      text: "Almost correct! Try again: \"I think white lies are sometimes okay.\" Can you repeat?",
      isFromUser: false,
      senderName: "AI",
      koreanTranslation: "거의 맞았어요! 다시 시도해보세요: \"I think white lies are sometimes okay.\" 반복해볼 수 있나요?",
    ),
    ChatMessage(
      text: "I think white lies are sometimes okay.",
      isFromUser: true,
    ),
    ChatMessage(
      text: "Great! Now, why do you think so?",
      isFromUser: false,
      senderName: "AI",
      koreanTranslation: "훌륭해요! 이제, 왜 그렇게 생각하나요?",
    ),
    // ChatMessage(
    //   text: "Because it can protect someone's feeling.",
    //   isFromUser: true,
    // ),
    // ChatMessage(
    //   text: "Good try! Small correction: \"someone's feelings\" (plural). Please say the full sentence again.",
    //   isFromUser: false,
    //   senderName: "AI",
    //   koreanTranslation: "좋은 시도예요! 작은 수정: \"someone's feelings\" (복수형). 전체 문장을 다시 말해보세요.",
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _startMessageAnimation();
  }

  void _startMessageAnimation() {
    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          final currentIndex = _messageVisibility.length;
          if (currentIndex < _messages.length) {
            _messageVisibility[currentIndex] = true;
          } else {
            timer.cancel();
          }
        });
      }
    });
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
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.1),
          //     spreadRadius: 1,
          //     blurRadius: 3,
          //     offset: const Offset(0, 1),
          //   ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black87),
          ),
          const SizedBox(width: 4),
          // 레스토랑 컨텍스트
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
                    "White lies",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // const SizedBox(width: 16),

          // // 시간
          // Column(
          //   children: [
          //     Text(
          //       "Time",
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: Colors.grey[600],
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     const SizedBox(height: 2),
          //     Text(
          //       "2:37",
          //       style: TextStyle(
          //         fontSize: 14,
          //         color: Colors.grey[800],
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ],
          // ),
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
        // 메시지가 표시되어야 하는지 확인
        if (_messageVisibility[index] != true) {
          return const SizedBox.shrink(); // 메시지가 아직 표시되지 않으면 빈 공간
        }
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isFromUser) {
      // 사용자 메시지 (오른쪽 정렬)
      return AnimatedOpacity(
        opacity: _messageVisibility[_messages.indexOf(message)] == true ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Padding(
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
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // AI 메시지 (왼쪽 정렬)
      final messageIndex = _messages.indexOf(message);
      final isVisible = _messageVisibility[messageIndex] == true;
      
      return AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아바타
              Image.asset(
                'assets/image/character.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),

              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.senderName ?? "AI",
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
                                // 로딩 중일 때는 로딩 인디케이터 표시
                                if (!isVisible) ...[
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.grey[600]!,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "AI is typing...",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  // 메시지가 표시될 때는 실제 텍스트 표시
                                  Text(
                                    message.text,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // 한국어 번역 (전구 아이콘 클릭 시에만 표시)
                                  if (_showTranslations[messageIndex] == true &&
                                      message.koreanTranslation != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      message.koreanTranslation!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 전구 아이콘 (번역 토글 기능) - 메시지가 표시된 후에만 보임
                        if (isVisible)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showTranslations[messageIndex] =
                                    !(_showTranslations[messageIndex] ?? false);
                              });
                            },
                            child: Icon(
                              _showTranslations[messageIndex] == true
                                  ? Icons.lightbulb
                                  : Icons.lightbulb_outline,
                              color: _showTranslations[messageIndex] == true
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
                  _buildRecommendationButton("Because it can protect someone's feelings."),
                  const SizedBox(width: 8),
                  _buildRecommendationButton("If my friend asks about clothes, I say they look good."),
                  const SizedBox(width: 8),
                  _buildRecommendationButton("White lies are used to avoid hurting someone."),
                  const SizedBox(width: 8),
                  _buildRecommendationButton("Honesty is not always the best choice."),
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
    return GestureDetector(
      onTap: () {
        _addMessageFromRecommendation(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  void _addMessageFromRecommendation(String messageText) {
    // 사용자 메시지 추가
    setState(() {
      _messages.add(ChatMessage(
        text: messageText,
        isFromUser: true,
      ));
      _messageVisibility[_messages.length - 1] = true;
    });

    // AI 응답을 위한 로딩 표시
    setState(() {
      _messages.add(ChatMessage(
        text: "Perfect! Can you give me one example?",
        isFromUser: false,
        senderName: "AI",
        koreanTranslation: "완벽해요! 예시를 하나 들어볼 수 있나요?",
      ));
      _messageVisibility[_messages.length - 1] = false; // 처음에는 숨김
    });

    // 1초 후 AI 응답 표시
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messageVisibility[_messages.length - 1] = true;
        });
      }
    });
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
