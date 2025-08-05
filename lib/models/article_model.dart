class Article {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? link;
  final String? pubDate;

  Article({
    this.title,
    this.description,
    this.imageUrl,
    this.link,
    this.pubDate,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      link: json['link'],
      pubDate: json['pubDate'],
    );
  }
}
