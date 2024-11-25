import 'package:flutter/material.dart';
import 'package:flutter_application_1/icons_kure.dart';
import 'package:flutter_application_1/icons_kure_rast_gele.dart';

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

class GlobeOfTextExample extends StatelessWidget {
  const GlobeOfTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Globe of 0 and 1'),
      ),
      body: const Center(
        child: Column(
          children: [
            Expanded(
              child: GlobeOfText(
                radius: 200.0,
                defaultTextColor: Color.fromARGB(255, 255, 0, 225),
              ),
            ),
            Expanded(
              child: GlobeOfText2(
                radius: 200.0,
                defaultTextColor: Color.fromARGB(255, 255, 0, 225),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
