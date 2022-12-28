class NewsArtical {
  late final int id;
  late final String author;
  late final String title;
  late final String url;
  late final String urlToImage;
  late final String publishedAt;
  late final String content;
  late final List<dynamic> categories;
  late final List<String> categoriesStr;

  NewsArtical({
    required this.id,
    required this.author,
    required this.title,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.categories,
  }) {
    invokeCategory();
  }

  invokeCategory() {
    categoriesStr = <String>[];

    if (categories.contains(4)) {
      categoriesStr.add("प्रदेश");
    }
    if (categories.contains(6)) {
      categoriesStr.add("खेल");
    }
    if (categories.contains(5)) {
      categoriesStr.add("देश-विदेश");
    }
    if (categories.contains(3)) {
      categoriesStr.add("बृज समाचार");
    }
  }
}
