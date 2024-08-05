// import 'package:bacaberita_app/pages/favorite_pages.dart';
// import 'package:bacaberita_app/pages/homepage.dart';
import 'package:flutter/material.dart';

import 'pages/homepage_news.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomepageNews(),
    );
  }
}