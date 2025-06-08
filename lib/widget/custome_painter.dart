import 'package:flutter/material.dart';

class CustomBeatsOnFireContainer extends StatelessWidget {
  const CustomBeatsOnFireContainer({super.key});

  @override
  Widget build(BuildContext context) {
    const double containerHeight = 70.0;
    const double containerWidth = 220.0;
    const double iconSize = 30.0;
    // const double globeContainerSize = 70.0;

    return SizedBox(
      height: containerHeight,
      width: containerWidth,
      child: Stack(
        children: [
          // White Border
          CustomPaint(
            painter: HoverboardBorderPainter(),
            size: const Size(containerWidth, containerHeight),
          ),

          // Clipped Hoverboard Shape
          ClipPath(
            clipper: HoverboardClipper(),
            child: Container(
              color: Colors.white24,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Globe Circle Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          // color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Container(
                            width: 90,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF26522),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/image/logo_remove.png',
                                  width: 125,
                                  height: 108,
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Fire & Rocket Icons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.red,
                        size: iconSize,
                      ),
                      const SizedBox(width: 15),
                      Icon(
                        Icons.rocket_launch,
                        color: Colors.grey.shade300,
                        size: iconSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoverboardBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Path path = HoverboardClipper().getClip(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HoverboardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 40.0;
    const double indentDepth = 25.0;
    final double indentWidth = size.width * 0.25;

    final double startDipX = (size.width - indentWidth) / 2;
    final double endDipX = startDipX + indentWidth;

    Path path = Path();

    path.moveTo(radius, 0);
    path.quadraticBezierTo(0, 0, 0, radius);
    path.lineTo(0, size.height - radius);
    path.quadraticBezierTo(0, size.height, radius, size.height);
    path.lineTo(startDipX, size.height);

    path.cubicTo(
      startDipX + indentWidth * 0.25,
      size.height,
      startDipX + indentWidth * 0.25,
      size.height - indentDepth,
      startDipX + indentWidth * 0.5,
      size.height - indentDepth,
    );
    path.cubicTo(
      endDipX - indentWidth * 0.25,
      size.height - indentDepth,
      endDipX - indentWidth * 0.25,
      size.height,
      endDipX,
      size.height,
    );

    path.lineTo(size.width - radius, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - radius);
    path.lineTo(size.width, radius);
    path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
    path.lineTo(endDipX, 0);

    path.cubicTo(
      endDipX - indentWidth * 0.25,
      0,
      endDipX - indentWidth * 0.25,
      indentDepth,
      startDipX + indentWidth * 0.5,
      indentDepth,
    );
    path.cubicTo(
      startDipX + indentWidth * 0.25,
      indentDepth,
      startDipX + indentWidth * 0.25,
      0,
      startDipX,
      0,
    );

    path.lineTo(radius, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
