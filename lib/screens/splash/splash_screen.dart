import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aman/theme/app_theme.dart';
import '../onboarding/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  late Animation<double> _bigAScale;
  late Animation<double> _bigAOpacity;
  
  late Animation<double> _amanTextOpacity;
  
  late Animation<double> _magnifyingGlassOpacity;
  late Animation<Offset> _magnifyingGlassSlide;
  
  late Animation<double> _centerElementsOpacity;
  late Animation<double> _characterOpacity;
  
  late Animation<double> _buttonOpacity;
  late Animation<Color?> _buttonColor;
  
  late Animation<double> _backgroundOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    );

    // 0.0 to 0.15: Big 'A' scales down
    _bigAScale = Tween<double>(begin: 8.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.15, curve: Curves.easeOut)),
    );
    // Big 'A' fades out as 'AMAN' fades in
    _bigAOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.15, 0.2, curve: Curves.easeOut)),
    );

    // 0.15 to 0.2: 'AMAN' text fades in
    _amanTextOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.15, 0.2, curve: Curves.easeIn)),
    );

    // 0.25 to 0.45: Magnifying glass slides across
    _magnifyingGlassOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.3, curve: Curves.easeIn)),
    );
    _magnifyingGlassSlide = Tween<Offset>(
      begin: const Offset(-0.8, 0.0),
      end: const Offset(0.8, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.45, curve: Curves.easeInOut)),
    );

    // 0.5 to 0.6: 'AMAN' and glass fade out
    _centerElementsOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.6, curve: Curves.easeOut)),
    );

    // 0.6 to 0.7: Character fades in
    _characterOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.7, curve: Curves.easeIn)),
    );

    // 0.75 to 0.85: Button fades in
    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.75, 0.85, curve: Curves.easeIn)),
    );
    
    // 0.85 to 0.9: Button changes color to Gold
    _buttonColor = ColorTween(
      begin: AppColors.brandNavy.withAlpha(50), 
      end: AppColors.goldYellow
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.85, 0.9, curve: Curves.linear)),
    );

    // 0.9 to 1.0: Backgrounds fade in
    _backgroundOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.9, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandNavy,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              Opacity(
                opacity: _backgroundOpacity.value,
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      right: -30,
                      child: Image.asset(
                        'assets/images/bg_4.png',
                        width: 150,
                        opacity: const AlwaysStoppedAnimation(0.2),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      right: -40,
                      child: Image.asset(
                        'assets/images/bg_1-3d9543.png',
                        width: 200,
                        opacity: const AlwaysStoppedAnimation(0.3),
                      ),
                    ),
                    Positioned(
                      bottom: 120,
                      left: -40,
                      child: Image.asset(
                        'assets/images/bg_2-63176c.png',
                        width: 160,
                        opacity: const AlwaysStoppedAnimation(0.3),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 10,
                      child: Image.asset(
                        'assets/images/bg_3.png',
                        width: 120,
                        opacity: const AlwaysStoppedAnimation(0.4),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Opacity(
                  opacity: _centerElementsOpacity.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: _bigAOpacity.value,
                        child: Transform.scale(
                          scale: _bigAScale.value,
                          child: const Text(
                            "A",
                            style: TextStyle(
                              fontSize: 180,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: _amanTextOpacity.value,
                        child: const Text(
                          "AMAN",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: _magnifyingGlassOpacity.value,
                        child: SlideTransition(
                          position: _magnifyingGlassSlide,
                          child: SvgPicture.asset(
                            'assets/images/magnifying_glass_1.svg',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: _characterOpacity.value,
                      child: SvgPicture.asset(
                        'assets/images/character_1.svg',
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Opacity(
                      opacity: _buttonOpacity.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _backgroundOpacity.value > 0.5 ? _navigateToOnboarding : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _buttonColor.value,
                              disabledBackgroundColor: _buttonColor.value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Mulai Sekarang",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
