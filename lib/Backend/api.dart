import 'dart:convert';
import 'package:dainik_ujala/Backend/models.dart';
import 'package:http/http.dart' as http;

class FetchData {
  static String api = "https://dainikujala.live/wp-json/wp/v2/posts";

  // ?q=tesla&from=2022-11-21&sortBy=publishedAt&apiKey=

  static Future<Iterable<NewsArtical>> callApi(
      {int page = 1, category = 0, String? slug}) async {
    List<NewsArtical> dataToBeSent = <NewsArtical>[];
    try {
      String url;
      if (category == 0 && page > 0 && slug == null) {
        url = "$api?page=$page";
      } else {
        if (slug == null && page != 0) {
          url = "$api?categories=$category&page=$page";
        } else {
          url = "$api?slug=$slug";
        }
      }
      print(url);
      final response = await http.get(Uri.parse(url));

      final decodedData = jsonDecode(response.body);

      // var newsData = decodedData["articles"];
      print(decodedData);

      List<dynamic> data = List.from(decodedData);

      for (int i = 0; i < data.length; i++) {
        if (data[i] == null) {
          print("Something Skipped");
          continue;
        } else {
          NewsArtical item = NewsArtical(
            id: int.parse(data[i]["id"].toString()),
            author: data[i]["yoast_head_json"]["author"].toString(),
            title: data[i]["title"]["rendered"].toString(),
            content: data[i]["content"]["rendered"].toString(),
            url: data[i]["link"].toString(),
            urlToImage: data[i]["yoast_head_json"]["og_image"][0]["url"],
            publishedAt: data[i]["date"].toString(),
            categories: data[i]["categories"],
          );
          dataToBeSent.add(item);
        }
      }
      print("$page  ${dataToBeSent.length}    Data Fetched");
    } catch (e) {
      print(e.toString());
    }
    return dataToBeSent;
  }
}
