import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}
class FetchNews extends NewsEvent {
  final String country;
  final String? keyword;
  final String? category; // ✅ أضيفي هذا السطر

  const FetchNews({
    required this.country,
    this.keyword,
    this.category, // ✅ أضيفي هذا السطر أيضاً
  });
}

