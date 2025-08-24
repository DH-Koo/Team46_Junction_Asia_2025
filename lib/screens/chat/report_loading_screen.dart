import 'package:flutter/material.dart';
import '../record/record_detail_chat_screen.dart';

class ReportLoadingScreen extends StatefulWidget {
  const ReportLoadingScreen({
    super.key,
    required this.roomId,
    required this.userId,
  });
  final int roomId;
  final int userId;

  @override
  State<ReportLoadingScreen> createState() => _ReportLoadingScreenState();
}

class _ReportLoadingScreenState extends State<ReportLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // 4초 후에 record_detail_chat_screen으로 이동
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RecordDetailChatScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/motion/motion7.gif'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 로딩 문구
              const Text(
                '리포트를 작성하는 중이에요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // 추가 설명 문구
              const Text(
                '잠시만 기다려주세요...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
