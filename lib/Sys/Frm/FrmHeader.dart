// import 'package:adidas_concept/constant.dart';
import 'package:flutter/material.dart';
import 'package:face_apps/sys.dart';
/*
Application use
 Widget _circularBackground() {
    return new Container(
      height: double.infinity,
      width: double.infinity,
      child: new CustomPaint(
        painter: new CircularBackgroundPainter(),
      ),
    );
  }
*/

class CircularBackgroundPainter extends CustomPainter {
  final Paint mainPaint;
  final Paint middlePaint;
  final Paint lowerPaint;

  CircularBackgroundPainter()
      : mainPaint = new Paint(),
        middlePaint = new Paint(),
        lowerPaint = new Paint() {
    mainPaint.color = sys.theme;
    mainPaint.isAntiAlias = true;
    mainPaint.style = PaintingStyle.fill;

    middlePaint.color = sys.theme[300]!;
    middlePaint.isAntiAlias = true;
    middlePaint.style = PaintingStyle.fill;

    lowerPaint.color = sys.theme[200]!;
    lowerPaint.isAntiAlias = true;
    lowerPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    drawBellAndLeg(canvas, size);
    canvas.restore();
  }

  void drawBellAndLeg(canvas, Size size) {
    Path upperPath = new Path();
    upperPath.addRect(Rect.fromLTRB(0, 0, size.width, size.height - 40));
    upperPath.addArc(Rect.fromLTRB(-140, 40, size.width + 150, size.height), 0.1, 30);

    Path middlePath = new Path();
    middlePath.addRect(Rect.fromLTRB(0, 0, size.width, size.height - 70));
    middlePath.addArc(Rect.fromLTRB(-140, 0, size.width + 150, size.height - 15), 0.1, 30);

    Path lowerPath = new Path();
    //path1.lineTo(size.width, 0);
    //path1.lineTo(size.width, size.height / 3);
    //path1.addOval(Rect.fromLTRB(-150, 100, size.width + 50, size.height / 2));
    lowerPath.addRect(Rect.fromLTRB(0, 0, size.width, size.height - 90));
    lowerPath.addArc(Rect.fromLTRB(-140, -70, size.width + 150, size.height - 30), 0.1, 30);

    //path1.quadraticBezierTo(0, size.height / 3, size.width, size.height / 3);

    canvas.drawPath(upperPath, lowerPaint);
    canvas.drawPath(middlePath, middlePaint);
    canvas.drawPath(lowerPath, mainPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
