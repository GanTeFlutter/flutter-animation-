
import 'package:flutter/material.dart';
import 'package:flutter_application_1/animation-1/icons_kure.dart';
import 'package:flutter_application_1/animation-1/icons_kure_rast_gele.dart';

class GlobeOfTextExample extends StatelessWidget {
  const GlobeOfTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
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