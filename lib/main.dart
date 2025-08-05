import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'services/news_service.dart';
import 'block/news_bloc.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsBloc(NewsService()),
      child: MaterialApp(
        title: 'خبّرني',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: const SplashScreen(), // ✅ شاشة البداية الجديدة
      ),
    );
  }
}
