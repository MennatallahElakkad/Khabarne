import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  final FlutterTts flutterTts = FlutterTts(); // ✅ TTS

  @override
  void initState() {
    super.initState();

    // ✅ إعداد الأنيميشن
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // ✅ تشغيل الصوت الترحيبي
    _speakWelcome();

    // ✅ الانتقال بعد 8 ثواني
    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  Future<void> _speakWelcome() async {
    await flutterTts.setLanguage("ar");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);

    var result = await flutterTts.speak("مرحب بك في خبّرني");
    if (result == 1) {
      print("✅ تم تشغيل الصوت");
    } else {
      print("❌ فشل تشغيل الصوت");
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    flutterTts.stop(); // ✅ إيقاف الصوت عند الخروج
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ خلفية التطبيق
          Image.asset(
            'assets/splach2.png',
            fit: BoxFit.cover,
          ),

          // ✅ مؤشر التحميل مع الأنيميشن
          Positioned(
            bottom: 280, // يمكنك تعديل المسافة حسب التصميم
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: const Center(
                child: SpinKitFadingCube(
                  color: Colors.white,
                  size: 60.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
