import 'package:flutter/material.dart';
import 'parallax_page.dart';

void main() {
  runApp(const ParallaxApp());
}

class ParallaxApp extends StatelessWidget {
  const ParallaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black, // Background gelap sesuai desain [cite: 2]
      ),
      home: const DefaultTabController(
        length: 5,
        child: ParallaxPage(),
      ),
    );
  }
}