import 'dart:convert';
import 'package:bacaberita_app/models/article.dart';
import 'package:http/http.dart' as http; 

// import 'package:bacaberita_app/services/news_service.dart';

import '../const/const.dart';

class CategoryNewsService {

  List<Article> news = [];

  Future<void> getNews(String category) async{

    Uri url = Uri.parse("https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=${NEWS_API_KEY}");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null) {
          Article newsModel = Article(
            title: element['title'], // name must be same fron api
            urlToImage: element['urlToImage'],
            description: element['description'],
            author: element['author'],
            content: element['content'],
          );
          news.add(newsModel);
        }
      });
    }

  }

}