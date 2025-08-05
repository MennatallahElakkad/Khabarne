import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../block/news_bloc.dart';
import '../block/news_event.dart';
import '../block/news_state.dart';
import '../models/article_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCountry = 'eg';
  String dailyTip = '';
  final FlutterTts flutterTts = FlutterTts();

  final List<String> dailyTips = [
    "لا تنسَ أن تبتسم، فالحياة تُحب من يبتسم لها."
    "اعمل لدنياك كأنك تعيش أبداً، واعمل لآخرتك كأنك تموت غداً.",
    "القوة لا تعني عدم الشعور بالخوف، بل في مواجهة الخوف رغم وجوده.",
    "لا يمكنك أن تعبر البحر بمجرد الوقوف على الشاطئ والتحديق فيه.",
    "كلما تعلمت أكثر، أدركت كم أنك لا تعلم.",
    "إذا أحببت فأخلص، وإذا وعدت فصدق.",
    "كل شيء عظيم بدأ بخطوة صغيرة، فلا تستهِن بالبدايات.",

    "النجاح لا يُقاس بما تحققه، بل بالعقبات التي تغلبت عليها.",
    "أعظم رحلة هي تلك التي تبدأ من داخلك.",
    "لا تبرر كثيرًا، من يفهمك لا يحتاج، ومن لا يفهمك لن يقتنع.",
    "تقبّل ذاتك، فالعالم كله لن يُعوّضك عن فقدانك لنفسك.",
    "كل سقوط هو خطوة في اتجاه النهوض.",
    "كل صباح هو فرصة جديدة لتبدأ من جديد.",




    "كل يوم جديد هو هدية، فلا تُضيّعها في الندم على الأمس.",
    "توقف عن إرضاء الجميع، فأنت لست نسخة تجريبية للعالم.",
    "اختر نفسك، في كل مرة تشعر فيها بأنك الخيار الأخير.",
    "ساعات ربنا بيأخر الحاجة عشان يديك أحسن منها… ما تستعجلش.",
    "اللي بيرتاح مع نفسه… محدش يقدر يهدّه.",
    "الدنيا مش دايمًا وردي، بس في كل يوم حلوة صغيرة مستخبية… دور عليها.",
    "إذا أردت أن تكون قويًا، فتعلم كيف تحارب وحدك.",
    "الوقت هو أعظم ثروة يمتلكها الإنسان، لكنه لا يراه.",
    "الحياة قصيرة، فلا تقضِها في الشكوى.",
  ];

  final Map<String, String> countries = {
    'eg': 'مصر',
    'sa': 'السعودية',
    'ae': 'الإمارات',
    'us': 'أمريكا',
    'gb': 'بريطانيا',
  };

  @override
  void initState() {
    super.initState();
    _setRandomTip();
    context.read<NewsBloc>().add(const FetchNews(country: 'eg'));
  }

  void _setRandomTip() {
    final random = Random();
    setState(() {
      dailyTip = dailyTips[random.nextInt(dailyTips.length)];
    });
  }

  void _onSearch() {
    context.read<NewsBloc>().add(
      FetchNews(
        country: selectedCountry,
        keyword: _searchController.text.trim(),
      ),
    );
  }

  void _speakTip() async {
    await flutterTts.setLanguage("ar");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(dailyTip);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'خبّرني',
          style: GoogleFonts.amiri(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff432371), Color(0xfffaae7b)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'ابحث عن الأخبار...',
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                          ),
                          onSubmitted: (_) => _onSearch(),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
              SizedBox(
                height: screenHeight * 0.4,
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is NewsLoaded) {
                      if (state.articles.isEmpty) {
                        return const Center(child: Text('لا توجد نتائج'));
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: state.articles.map((article) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(article: article),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: article.imageUrl != null
                                        ? NetworkImage(article.imageUrl!)
                                        : const AssetImage('assets/news.png') as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title ?? 'بدون عنوان',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.amiri(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            article.pubDate ?? '',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else if (state is NewsError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('ابدأ بالبحث عن الأخبار'));
                    }
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'نصيحة اليوم',
                        style: GoogleFonts.amiri(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:  Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        dailyTip,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiri(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _speakTip,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.volume_up),
                        label: const Text('استمع '),
                      ),
                    ],

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
