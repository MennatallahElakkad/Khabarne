import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/article_model.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  void _initTTS() async {
    await flutterTts.setLanguage("ar");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak() async {
    String text =
        "${widget.article.title ?? ''}. ${widget.article.description ?? ''}";
    await flutterTts.speak(text);
    setState(() {
      isSpeaking = true;
    });
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '📰 تفاصيل الخبر',
          style: GoogleFonts.tajawal(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xfffaae7b), // Purple
              Color(0xff432371), // Orange
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      article.imageUrl!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/news.png',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  article.title ?? 'بدون عنوان',
                  style: GoogleFonts.tajawal(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.pubDate ?? '',
                  style: GoogleFonts.tajawal(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  article.description ?? 'لا يوجد وصف.',
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(isSpeaking ? Icons.stop : Icons.volume_up),
                    label: Text(isSpeaking ? 'إيقاف الصوت' : 'اسمع الخبر'),
                    onPressed: isSpeaking ? _stop : _speak,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (article.link != null)
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () => _launchUrl(article.link!),
                      icon: const Icon(Icons.open_in_browser, color: Colors.black),
                      label: const Text(
                        'اقرأ الخبر كاملاً',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}