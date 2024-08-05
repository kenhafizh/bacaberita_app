import 'dart:convert';

import 'package:bacaberita_app/models/article.dart';
import 'package:http/http.dart' as http;

class NewsService{
  List<Article> news = [];

  Future<void> getNews() async {

      String url = "https://newsapi.org/v2/everything?q=keyword&apiKey=e0cb040a8971451ab24f47ccaa84352d";
      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);

      if (jsonData['status']==['ok']) {
        jsonData["articles"].forEach((element){
            if (element["urlToImage"]!=null && element['description']!=null) {
              Article newsModel = Article(
                title: element["title"],
                description: element["description"],
                url: element["url"],
                urlToImage: element["urlToImage"],
                content: element["content"],
                author: element["author"]
              );
              news.add(newsModel);
            }
        });
      }

  }


}