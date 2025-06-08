import 'package:flutter/material.dart';

class AiImageCard extends StatelessWidget {
  final String image;
  final VoidCallback? onTap;

  const AiImageCard({
    super.key,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 390.0;
    const double cardHeight = 370.0;
    const double borderRadius = 40.0;
    const double cutoutSize = 100.0;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          // Image with clipped cutout wrapped in Hero
          Hero(
            tag: image,
            child: ClipPath(
              clipper: BottomLeftCutoutClipper(
                borderRadius: borderRadius,
                cutoutSize: cutoutSize,
              ),
              child: Image.asset(
                image,
                width: cardWidth,
                height: cardHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: cardWidth,
                  height: cardHeight,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      "AI Image",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // White box with arrow icon in the cutout
          Positioned(
            bottom: 2,
            left: 5,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomLeftCutoutClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double cutoutSize;
  final double cutoutRadius; // new for cutout corner radius

  BottomLeftCutoutClipper({
    required this.borderRadius,
    required this.cutoutSize,
    this.cutoutRadius = 20.0, // match white box radius
  });

  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Start from top-left corner with rounded borderRadius
    path.moveTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    // Top edge
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    // Right edge
    path.lineTo(size.width, size.height - borderRadius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - borderRadius, size.height);

    // Bottom edge, move to start of cutout (with cutoutRadius adjustment)
    path.lineTo(cutoutSize + cutoutRadius, size.height);

    // Cutout bottom-right corner curve (top-right of white box)
    path.quadraticBezierTo(
      cutoutSize,
      size.height,
      cutoutSize,
      size.height - cutoutRadius,
    );

    // Cutout vertical edge (left side of white box)
    path.lineTo(cutoutSize, size.height - cutoutSize + cutoutRadius);

    // Cutout top-left corner curve (bottom-left of white box)
    path.quadraticBezierTo(
      cutoutSize,
      size.height - cutoutSize,
      cutoutSize - cutoutRadius,
      size.height - cutoutSize,
    );

    // Horizontal edge to left edge (bottom side)
    path.lineTo(borderRadius, size.height - cutoutSize);

    // Bottom-left corner curve of main card
    path.quadraticBezierTo(0, size.height - cutoutSize, 0,
        size.height - cutoutSize - borderRadius);

    // Left edge back to start
    path.lineTo(0, borderRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
