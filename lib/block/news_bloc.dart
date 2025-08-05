import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_event.dart';
import 'news_state.dart';
import '../services/news_service.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService newsService;

  NewsBloc(this.newsService) : super(NewsInitial()) {
    on<FetchNews>((event, emit) async {
      emit(NewsLoading());
      try {
        final articles = await newsService.fetchNews(
          country: event.country,
          keyword: event.keyword,
        );
        emit(NewsLoaded(articles));
      } catch (e) {
        emit(NewsError('فشل في جلب الأخبار'));
      }
    });
  }
}
