import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class TextItem {
  final String text;
  vector.Vector3 position;
  double scale;
  final Color color;

  TextItem({
    required this.text,
    required this.position,
    required this.color,
    this.scale = 1.0,
  });
}

class GlobeOfText extends StatefulWidget {
  final double radius;
  final Color defaultTextColor;

  const GlobeOfText({
    super.key,
    this.radius = 150.0,
    this.defaultTextColor = Colors.white,
  });

  @override
  State<GlobeOfText> createState() => _GlobeOfTextState();
}

class _GlobeOfTextState extends State<GlobeOfText> with SingleTickerProviderStateMixin {
  List<TextItem> textItems = [];
  late AnimationController _controller;
  double _lastControllerValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeTexts();
    _setupAnimation();
  }

  void _initializeTexts() {
    const texts = ['0', '1'];
    const numberOfItems = 300; // Sayıların toplam adedi

    textItems = List.generate(numberOfItems, (index) {
      final text = texts[index % texts.length]; // 0 ve 1 arasında dönüşümlü olarak seçiliyor.

      final phi = math.acos(-1.0 + (2.0 * index) / numberOfItems);
      final theta = math.sqrt(numberOfItems * math.pi) * phi;

      final x = widget.radius * math.cos(theta) * math.sin(phi);
      final y = widget.radius * math.sin(theta) * math.sin(phi);
      final z = widget.radius * math.cos(phi);

      return TextItem(
        text: text,
        position: vector.Vector3(x, y, z),
        color: widget.defaultTextColor,
        scale: 1.0,
      );
    });
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(_performAutoRotation);

    _controller.repeat();
  }

  void _performAutoRotation() {
    if (!mounted || textItems.isEmpty) return;

    setState(() {
      final currentValue = _controller.value;
      final deltaValue = currentValue - _lastControllerValue;

      final adjustedDelta =
          deltaValue.abs() > 0.5 ? deltaValue.sign * (1 - deltaValue.abs()) : deltaValue;

      if (adjustedDelta.abs() > 0.0001) {
        final deltaRotation = adjustedDelta * 2 * math.pi * 0.1;

        final deltaRotationMatrix = vector.Matrix4.rotationY(deltaRotation);

        for (var item in textItems) {
          final transformed = deltaRotationMatrix.transform3(item.position);
          item.position
            ..x = transformed.x
            ..y = transformed.y
            ..z = transformed.z;
        }
      }

      _lastControllerValue = currentValue;
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

      final opacity = math.max(0.4, math.min(1.0, (item.position.z + radius) / (radius * 2)));

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
