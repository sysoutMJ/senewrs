// Holds data of retrieved news from API
class News {
  const News({
    required this.newsTitle,
    required this.description,
    required this.author,
    required this.source,
    required this.imgLink,
    required this.url,
    required this.datePublished,
  });

  final newsTitle;
  final description;
  final author;
  final source;
  final imgLink;
  final url;
  final datePublished;

  // Returns instance of News from HTTP response
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsTitle: json["title"] ?? "title",
      description: json["description"] ?? "description",
      author: json["author"] ?? "author",
      source: json["source"] ?? "source",
      imgLink: json["image"] ?? "image",
      url: json["url"] ?? "url",
      datePublished: json["datePublished"] ?? "date",
    );
  }
}
