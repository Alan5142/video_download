import 'package:flutter/material.dart';
import 'package:video_downlad/home_page.dart';
import 'package:provider/provider.dart';
import 'package:video_downlad/providers/my_download_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video App',
      home: ChangeNotifierProvider(
        create: (context) => MyDownloadProvider()..fileExists(),
        child: HomePage(),
      ),
    );
  }
}
