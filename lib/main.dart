import 'package:flutter/material.dart';
import 'package:flutter_application_1/animation-1/animation1_home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Globe of Text Demo',
      home: GlobeOfTextExample(),
    );
  }
}


///Hangi animasyonu görmek istiyorsanız onu seçin.Home ekleyin

/// Animation 1
// GlobeOfTextExample(),