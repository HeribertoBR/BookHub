import 'dart:async';
import 'package:flutter/material.dart';
import '../features/library/library_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LibraryPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF7FAFC), Color(0xFFE7F1F8)],
              ),
            ),
          ),
          Positioned(
            top: -90,
            right: -70,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0x1A17608F),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -110,
            left: -90,
            child: Container(
              width: 280,
              height: 280,
              decoration: const BoxDecoration(
                color: Color(0x1A17608F),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/splash_icon_2.png',
                    width: 190,
                    semanticLabel: 'BookHub',
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Tu biblioteca personal',
                    style: TextStyle(
                      color: Color(0xFF0B3557),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '',
                    style: TextStyle(color: Color(0xFF58758D), fontSize: 15),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.8,
                      color: Color(0xFF0B4B78),
                      backgroundColor: Color(0xFFD2E1EC),
                    ),
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
