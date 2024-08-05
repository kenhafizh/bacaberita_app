// ignore_for_file: avoid_print, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bacaberita_app/pages/category_news.dart';
// import 'package:bacaberita_app/services/category_news_service.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../const/const.dart';
import '../models/article.dart';
import '../models/category.dart';

class HomepageNews extends StatefulWidget {
  const HomepageNews({super.key});

  @override
  State<HomepageNews> createState() => _HomepageNewsState();
}

class _HomepageNewsState extends State<HomepageNews> {
  final Dio dio = Dio();

  List<Article> articles = [];
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    _getNews();
    categories= getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BeritaSatu'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _listCategory(),
          SizedBox(height: 5),
          Flexible(
            child: _buildUInewVersion(),
          )
        ],
      ),
    );
  }

  Widget _listCategory() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedCategoryNews(category: category.categoryName!)));
              },
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.grey),
                  child: Center(
                    child: Text(
                      category.categoryName!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildUInewVersion() {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: GestureDetector(
              onTap: () {
                _launcherUrl(Uri.parse(article.url!));
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        article.urlToImage ?? PLACEHOLDER_IMAGE_LINK,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    // width: MediaQuery.of(context).size.width / 1.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          article.title ?? "",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        Text(
                          article.publishedAt ?? "",
                          style: GoogleFonts.inter(fontSize: 12),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _getNews() async {
    final response = await dio.get(
      'https://newsapi.org/v2/everything?q=keyword&apiKey=${NEWS_API_KEY}',
    );
    final articlesJson = response.data["articles"] as List;
    setState(() {
      List<Article> newsArticle =
          articlesJson.map((a) => Article.fromJson(a)).toList();
      articles = articles.where((a) => a.title != "[Removed]").toList();
      articles = newsArticle;
    });
  }

  Future<void> _launcherUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
