import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class TextItem {
  final String text;
  vector.Vector3 position;
  vector.Vector3 velocity; // Yeni: Hız vektörü
  double scale;
  final Color color;

  TextItem({
    required this.text,
    required this.position,
    required this.velocity,
    required this.color,
    this.scale = 1.0,
  });
}

class GlobeOfText2 extends StatefulWidget {
  final double radius;
  final Color defaultTextColor;

  const GlobeOfText2({
    super.key,
    this.radius = 150.0,
    this.defaultTextColor = Colors.white,
  });

  @override
  State<GlobeOfText2> createState() => _GlobeOfText2State();
}

class _GlobeOfText2State extends State<GlobeOfText2>
    with SingleTickerProviderStateMixin {
  List<TextItem> textItems = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _initializeTexts();
    _setupAnimation();
  }

  void _initializeTexts() {
    const texts = ['0', '1'];
    const numberOfItems = 100; // Sayıların toplam adedi

    textItems = List.generate(numberOfItems, (index) {
      final text = texts[index % texts.length];

      final phi = math.acos(-1.0 + (2.0 * index) / numberOfItems);
      final theta = math.sqrt(numberOfItems * math.pi) * phi;

      final x = widget.radius * math.cos(theta) * math.sin(phi);
      final y = widget.radius * math.sin(theta) * math.sin(phi);
      final z = widget.radius * math.cos(phi);

      // Rastgele hız vektörü
      final velocity = vector.Vector3(
        (math.Random().nextDouble() - 0.5) * 40,
        (math.Random().nextDouble() - 0.5) * 40,
        (math.Random().nextDouble() - 0.5) * 40,
      );

      return TextItem(
        text: text,
        position: vector.Vector3(x, y, z),
        velocity: velocity,
        color: widget.defaultTextColor,
        scale: 1.0,
      );
    });
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(_performMovement);

    _controller.repeat();
  }

  void _performMovement() {
    if (!mounted || textItems.isEmpty) return;

    setState(() {
      for (var item in textItems) {
        // Pozisyonu hız vektörüne göre güncelle
        item.position += item.velocity;

        // Sınır kontrolü: Pozisyon kürenin dışına çıkmasın
        final magnitude = item.position.length;
        if (magnitude > widget.radius) {
          item.position = item.position.normalized() * widget.radius;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (textItems.isEmpty) {
      return SizedBox(
        width: widget.radius * 2,
        height: widget.radius * 2,
      );
    }

    return SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: CustomPaint(
        painter: TextCloudPainter(
          textItems: textItems,
          radius: widget.radius,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class TextCloudPainter extends CustomPainter {
  final List<TextItem> textItems;
  final double radius;

  TextCloudPainter({
    required this.textItems,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sortedTexts = List<TextItem>.from(textItems)
      ..sort((a, b) => b.position.z.compareTo(a.position.z));

    for (var item in sortedTexts) {
      final center = Offset(
        size.width / 2 + item.position.x,
        size.height / 2 + item.position.y,
      );

      final opacity = math.max(
          0.4, math.min(1.0, (item.position.z + radius) / (radius * 2)));

      final textPainter = TextPainter(
        text: TextSpan(
          text: item.text,
          style: TextStyle(
            fontSize: 24 * item.scale,
            color: item.color.withOpacity(opacity),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        center.translate(-textPainter.width / 2, -textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(TextCloudPainter oldDelegate) => true;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Globe of Moving Text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GlobeOfText2Example(),
    );
  }
}

class GlobeOfText2Example extends StatelessWidget {
  const GlobeOfText2Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moving 0 and 1 Globe'),
      ),
      body: Center(
        child: GlobeOfText2(
          radius: 200.0,
          defaultTextColor: Colors.greenAccent,
        ),
      ),
    );
  }
}
