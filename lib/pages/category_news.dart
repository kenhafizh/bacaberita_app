// ignore_for_file: prefer_const_constructors, must_be_immutable


import 'package:bacaberita_app/services/category_news_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';
import 'news_detail.dart';

class SelectedCategoryNews extends StatefulWidget {
  String category;
  SelectedCategoryNews({super.key, required this.category});

  @override
  State<SelectedCategoryNews> createState() => _SelectedCategoryNewsState();
}

class _SelectedCategoryNewsState extends State<SelectedCategoryNews> {
  
  List<Article> articles = [];
  bool isLoading = true;

  @override
    void initState(){
      getNews();
      super.initState();
    }
  

  getNews() async {
    CategoryNewsService newsService = CategoryNewsService();
    await newsService.getNews(widget.category);
    articles = newsService.news;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          widget.category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
            itemCount: articles.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final article = articles[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetail(newsModel: article),
                    ),
                  );
                  // if (article.url!=null) {
                  // _launcherUrl(Uri.parse(article.url!));
                  // } else {
                  //    ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('URL not available')),
                  //     );
                  // }
                },
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          article.urlToImage!,
                          height: 250,
                          width: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        article.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Divider(thickness: 2)
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

    Future<void> _launcherUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

}
