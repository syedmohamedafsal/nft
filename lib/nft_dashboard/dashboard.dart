import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft/details/details_page.dart';
import 'package:nft/widget/ai_image_card.dart';
import 'package:nft/widget/custome_painter.dart';

class NFTMarketplaceHomePage extends StatefulWidget {
  const NFTMarketplaceHomePage({super.key});

  @override
  State<NFTMarketplaceHomePage> createState() => _NFTMarketplaceHomePageState();
}

class _NFTMarketplaceHomePageState extends State<NFTMarketplaceHomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logoOffset;
  late Animation<Offset> _profileOffset;
  late Animation<Offset> _titleOffset;
  late Animation<Offset> _cardOffset;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _logoOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _profileOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _titleOffset = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _cardOffset = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SlideTransition(
                                position: _logoOffset,
                                child: Image.asset(
                                  'assets/image/logo_remove.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SlideTransition(
                                position: _profileOffset,
                                child: const CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      AssetImage('assets/image/profile.jpeg'),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 20),
                          const SizedBox(height: 20),

                          // Title Section
                          SlideTransition(
                            position: _titleOffset,
                            child: Row(
                              children: [
                                FadeTransition(
                                  opacity: _fadeIn,
                                  child: Text(
                                    'NFT',
                                    style: GoogleFonts.audiowide(
                                      color: Colors.white,
                                      letterSpacing: 5,
                                      fontSize: 38,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                FadeTransition(
                                  opacity: _fadeIn,
                                  child: const CustomBeatsOnFireContainer(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeTransition(
                            opacity: _fadeIn,
                            child: SlideTransition(
                              position: _titleOffset,
                              child: Text(
                                'MARKETPLACE',
                                style: GoogleFonts.audiowide(
                                  color: Colors.white,
                                  fontSize: 38,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Image Cards
                          SlideTransition(
                            position: _cardOffset,
                            child: Column(
                              children: [
                                AiImageCard(
                                  image: 'assets/image/ai.jpg',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AiDetailsPage(
                                                image: 'assets/image/ai.jpg'),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                AiImageCard(
                                  image: 'assets/image/backai.jpg',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AiDetailsPage(
                                                image:
                                                    'assets/image/backai.jpg'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
