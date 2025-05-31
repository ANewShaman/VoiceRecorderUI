import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ConcaveDecoration extends Decoration {
  final double borderWidth; 
  final double depression;
  final List<Color> colors;
  final double borderRadius;

  ConcaveDecoration({
    this.borderWidth = 4.0,
    required this.depression,
    this.colors = const [Colors.black87, Colors.white],
    this.borderRadius = 0.0, 
  })  : assert(depression >= 0),
        assert(colors.length == 2),
        assert(borderWidth >= 0);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _ConcaveDecorationPainter(borderWidth, depression, colors, borderRadius);

  @override
  EdgeInsetsGeometry get padding => EdgeInsets.all(borderWidth);
}

class _ConcaveDecorationPainter extends BoxPainter {
  final double borderWidth;
  final double depression;
  final List<Color> colors;
  final double borderRadius;

  _ConcaveDecorationPainter(
    this.borderWidth,
    this.depression,
    this.colors,
    this.borderRadius,
  );

  @override
  void paint(ui.Canvas canvas, ui.Offset offset, ImageConfiguration config) {
    final rect = offset & config.size!;
    final outerPath = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
    
    final innerPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        rect.deflate(borderWidth), 
        Radius.circular(borderRadius - borderWidth)
      ));

    final borderPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(outerPath, Offset.zero)
      ..addPath(innerPath, Offset.zero);


    final delta = 16 / rect.longestSide;
    final stops = [0.5 - delta, 0.5 + delta];

    final paint = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, depression)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.clipPath(outerPath);

    for (final alignment in [Alignment.topLeft, Alignment.bottomRight]) {
      final shaderRect = alignment.inscribe(
        Size.square(rect.longestSide), 
        rect,
      );

      paint.shader = ui.Gradient.linear(
        shaderRect.topLeft,
        shaderRect.bottomRight,
        colors,
        stops,
      );

      canvas.drawPath(borderPath, paint);
    }
    canvas.restore();
  }
}