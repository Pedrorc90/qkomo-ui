import 'package:flutter/material.dart';

/// Qkomo logo - A stylized leaf and bowl representing fresh food ingredients
class QkomoLogo extends StatelessWidget {
  const QkomoLogo({
    super.key,
    this.size = 40,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _QkomoLogoPainter(color: logoColor),
      ),
    );
  }
}

class _QkomoLogoPainter extends CustomPainter {
  _QkomoLogoPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw rounded square background with gradient effect
    final roundedRect = RRect.fromRectAndRadius(
      Rect.fromCircle(center: center, radius: radius * 0.85),
      Radius.circular(size.width * 0.25),
    );

    // Background with subtle gradient
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.08),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(roundedRect.outerRect);

    canvas.drawRRect(roundedRect, gradientPaint);

    // Draw stylized bowl (bottom half circle)
    final bowlRect = Rect.fromCircle(
      center: Offset(center.dx, center.dy + size.height * 0.08),
      radius: size.width * 0.35,
    );

    canvas.drawArc(
      bowlRect,
      0, // Start angle (0 = 3 o'clock)
      3.14159, // Sweep angle (pi = 180 degrees)
      false, // useCenter = false for arc
      strokePaint,
    );

    // Draw leaf/sprout above bowl
    final leafPath = Path();

    // Leaf stem
    final stemStart = Offset(center.dx, center.dy - size.height * 0.05);
    final stemEnd = Offset(center.dx, center.dy - size.height * 0.25);
    leafPath.moveTo(stemStart.dx, stemStart.dy);
    leafPath.lineTo(stemEnd.dx, stemEnd.dy);

    // Left leaf
    final leftLeafControl1 =
        Offset(center.dx - size.width * 0.18, center.dy - size.height * 0.2);
    final leftLeafControl2 =
        Offset(center.dx - size.width * 0.22, center.dy - size.height * 0.12);
    final leftLeafEnd =
        Offset(center.dx - size.width * 0.08, center.dy - size.height * 0.1);

    leafPath.moveTo(stemEnd.dx, stemEnd.dy - size.height * 0.02);
    leafPath.cubicTo(
      leftLeafControl1.dx,
      leftLeafControl1.dy,
      leftLeafControl2.dx,
      leftLeafControl2.dy,
      leftLeafEnd.dx,
      leftLeafEnd.dy,
    );

    // Right leaf
    final rightLeafControl1 =
        Offset(center.dx + size.width * 0.18, center.dy - size.height * 0.2);
    final rightLeafControl2 =
        Offset(center.dx + size.width * 0.22, center.dy - size.height * 0.12);
    final rightLeafEnd =
        Offset(center.dx + size.width * 0.08, center.dy - size.height * 0.1);

    leafPath.moveTo(stemEnd.dx, stemEnd.dy - size.height * 0.02);
    leafPath.cubicTo(
      rightLeafControl1.dx,
      rightLeafControl1.dy,
      rightLeafControl2.dx,
      rightLeafControl2.dy,
      rightLeafEnd.dx,
      rightLeafEnd.dy,
    );

    canvas.drawPath(leafPath, strokePaint);

    // Draw three small dots representing ingredients/particles
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dotRadius = size.width * 0.045;

    // Left dot
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.18, center.dy + size.height * 0.08),
      dotRadius,
      dotPaint,
    );

    // Center dot
    canvas.drawCircle(
      Offset(center.dx, center.dy + size.height * 0.12),
      dotRadius,
      dotPaint,
    );

    // Right dot
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.18, center.dy + size.height * 0.08),
      dotRadius,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _QkomoLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
