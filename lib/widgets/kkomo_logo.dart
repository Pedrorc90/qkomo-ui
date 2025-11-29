import 'package:flutter/material.dart';

/// Vector logo for qkomo: a plate/camera motif with double K initials.
class qkomoLogo extends StatelessWidget {
  const qkomoLogo({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _qkomoLogoPainter()),
    );
  }
}

class _qkomoLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Plate + lens gradient ring.
    final plateGradient = const SweepGradient(
      colors: [Color(0xFFFF9F1C), Color(0xFFFF5F6D), Color(0xFFFF9F1C)],
      startAngle: -0.5,
      endAngle: 5.8,
    );
    final ring = Paint()
      ..shader = plateGradient
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.16
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius * 0.85, ring);

    // Inner plate.
    final plate = Paint()
      ..color = const Color(0xFFFDF6F0)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.6, plate);

    // Highlight arc (like a lens sheen).
    final highlight = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.5),
      -0.6,
      1.4,
      false,
      highlight,
    );

    // Two stylized Ks suggesting utensils/arcs.
    final kPaint = Paint()
      ..color = const Color(0xFF0D1B2A)
      ..strokeWidth = size.width * 0.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void drawK(double x, double tilt) {
      final yTop = size.height * 0.3;
      final yMid = size.height * 0.5;
      final yBottom = size.height * 0.7;
      final offset = size.width * 0.18;
      canvas.drawLine(Offset(x, yTop), Offset(x, yBottom), kPaint);
      canvas.drawLine(Offset(x, yMid), Offset(x + offset, yTop + tilt), kPaint);
      canvas.drawLine(
          Offset(x, yMid), Offset(x + offset, yBottom - tilt), kPaint);
    }

    drawK(size.width * 0.36, -size.width * 0.06);
    drawK(size.width * 0.6, size.width * 0.06);

    // Small scan dash to nod to barcode scanning.
    final dash = Paint()
      ..color = const Color(0xFF0D1B2A)
      ..strokeWidth = size.width * 0.04
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.82),
      Offset(size.width * 0.72, size.height * 0.82),
      dash,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
