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
    final center = Offset(size.width / 2, size.height * 0.47);
    final radius = size.width * 0.35;

    // 1. Draw the "Q" Plate background
    final platePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final plateShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.015;

    canvas.drawCircle(center, radius, platePaint);
    canvas.drawCircle(center, radius, plateShadowPaint);

    // Q-tail (plate detail) - Bottom Right
    final tailPaint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035
      ..strokeCap = StrokeCap.round;

    // Draw the "palo" of the Q (stalk)
    canvas.drawLine(
      Offset(center.dx + radius * 0.65, center.dy + radius * 0.75),
      Offset(center.dx + radius * 0.95, center.dy + radius * 1.05),
      tailPaint,
    );

    // 2. Draw the "Q" outer ring (Forest Green)
    final forestPaint = Paint()
      ..color = const Color(0xFF2D5016)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius * 1.15);
    // Gap at bottom right (from approx 40 deg to 80 deg)
    // Start at 1.4 radians and sweep 5.1
    canvas.drawArc(rect, 1.4, 5.1, false, forestPaint);

    // 3. Draw the "K" elements
    final kStemPaint = Paint()
      ..color = const Color(0xFF2D5016)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    // K Vertical Stem (Fork)
    final stemX = center.dx - radius * 0.3;
    canvas.drawLine(
      Offset(stemX, center.dy - radius * 0.6),
      Offset(stemX, center.dy + radius * 0.6),
      kStemPaint,
    );

    // Fork Tines
    final tinesPaint = Paint()
      ..color = const Color(0xFF2D5016)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(stemX - 10, center.dy - radius * 0.7),
        Offset(stemX - 10, center.dy - radius * 0.55), tinesPaint);
    canvas.drawLine(Offset(stemX, center.dy - radius * 0.7),
        Offset(stemX, center.dy - radius * 0.55), tinesPaint);
    canvas.drawLine(Offset(stemX + 10, center.dy - radius * 0.7),
        Offset(stemX + 10, center.dy - radius * 0.55), tinesPaint);

    // K Upper Arm (Carrot - Coral)
    final coralPaint = Paint()
      ..color = const Color(0xFFFF6F3C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final carrotPath = Path();
    carrotPath.moveTo(stemX, center.dy);
    carrotPath.quadraticBezierTo(
      center.dx + radius * 0.2,
      center.dy - radius * 0.1,
      center.dx + radius * 0.6,
      center.dy - radius * 0.5,
    );
    canvas.drawPath(carrotPath, coralPaint);

    // Carrot Greens (Fresh Green)
    final freshGreenPaint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx + radius * 0.5, center.dy - radius * 0.45),
      Offset(center.dx + radius * 0.65, center.dy - radius * 0.6),
      freshGreenPaint,
    );

    // K Lower Arm (Leaf - Fresh Green)
    final leafPaint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final leafPath = Path();
    leafPath.moveTo(stemX, center.dy);
    leafPath.quadraticBezierTo(
      center.dx + radius * 0.2,
      center.dy + radius * 0.2,
      center.dx + radius * 0.6,
      center.dy + radius * 0.6,
    );
    canvas.drawPath(leafPath, leafPaint);

    // Leaf Detail
    final leafDetailPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx + radius * 0.6, center.dy + radius * 0.6),
      Offset(center.dx + radius * 0.4, center.dy + radius * 0.4),
      leafDetailPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _QkomoLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
