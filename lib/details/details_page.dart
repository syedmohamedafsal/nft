import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiDetailsPage extends StatefulWidget {
  final String image;

  const AiDetailsPage({super.key, required this.image});

  @override
  State<AiDetailsPage> createState() => _AiDetailsPageState();
}

class _AiDetailsPageState extends State<AiDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _textSlideUp;
  late Animation<Offset> _infoBoxSlide;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _iconScale;

  String _bidStatus = 'idle'; // idle, loading, confirmed


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _textSlideUp = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _infoBoxSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    ));

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
    ));

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildIconButton(IconData icon, VoidCallback onPressed) {
    return ScaleTransition(
      scale: _iconScale,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.30),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(icon, color: Colors.white, size: 25),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  // Hero Image Section
                  Stack(
                    children: [
                      Hero(
                        tag: widget.image,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                          child: Image.asset(
                            widget.image,
                            height: 450,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Back Button
                      Positioned(
                        top: 20,
                        left: 20,
                        child: buildIconButton(
                          CupertinoIcons.back,
                          () => Navigator.pop(context),
                        ),
                      ),

                      // Favorite Button
                      Positioned(
                        top: 20,
                        right: 20,
                        child: buildIconButton(CupertinoIcons.heart, () {}),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  // Text Details
                  SlideTransition(
                    position: _textSlideUp,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DREAM SPACE',
                            style: GoogleFonts.audiowide(
                              textStyle: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                              text:
                                  'This NFT captures the quiet chaos of dreams — fluid colors, weightless forms, and infinite depth. Every pixel invites you to pause, wonder, and get lost in a space that feels familiar yet unknown. A place where your thoughts float free, and meaning is what you make of it... ',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(
                                  text: 'More',
                                  style: GoogleFonts.audiowide(
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Make Bid Button
                  SlideTransition(
                    position: _buttonSlide,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) async {
                          setState(() {
                            _bidStatus = 'loading';
                          });

                          await Future.delayed(const Duration(seconds: 1));

                          setState(() {
                            _bidStatus = 'confirmed';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 50,
                          decoration: BoxDecoration(
                            color: _bidStatus == 'confirmed'
                                ? Colors.green
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_bidStatus == 'idle') ...[
                                const Icon(Icons.double_arrow,
                                    color: Colors.black),
                                const SizedBox(width: 12),
                                Text(
                                  'Make Bid',
                                  style: GoogleFonts.audiowide(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ] else if (_bidStatus == 'loading') ...[
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                ),
                              ] else if (_bidStatus == 'confirmed') ...[
                                const Icon(Icons.check, color: Colors.white),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Floating Bid Info Box
            Positioned(
              top: 400,
              left: 20,
              right: 20,
              child: SlideTransition(
                position: _infoBoxSlide,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.adb_rounded, color: Colors.white),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Min Bid',
                                style: GoogleFonts.audiowide(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '3.4 ETH',
                                style: GoogleFonts.audiowide(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/image/profile.jpeg'),
                            radius: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '@syedmd_afsal',
                            style: GoogleFonts.audiowide(
                              textStyle: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
