import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _contents = [
    {
      'headline': 'Bingung Sama Urusan Hukum?',
      'body': 'Kontrak kerja, perjanjian, atau transaksi sering kali punya bahasa yang bikin bingung. Jangan asal setuju sebelum kamu tahu apa yang sebenarnya kamu hadapi.',
      'cta': 'Selanjutnya',
      'image': 'assets/images/onboarding_1.png',
    },
    {
      'headline': 'Pahami Sebelum Bertindak',
      'body': 'Ceritakan situasimu atau analisis dokumen yang kamu punya. AMAN? membantu menjelaskan hal penting, potensi risiko, dan langkah yang bisa kamu pertimbangkan.',
      'cta': 'Selanjutnya',
      'image': 'assets/images/onboarding_2.png',
    },
    {
      'headline': 'Lebih Paham, Lebih Siap Bertindak',
      'body': 'Kenali hak, kewajiban, potensi risiko, dan langkah selanjutnya sebelum mengambil keputusan.',
      'cta': 'Mulai Sekarang',
      'image': 'assets/images/onboarding_3.png',
    },
  ];

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: const Text(
                    "Lewati", 
                    style: TextStyle(
                      color: Color(0xFF3F3ABD), 
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.75,
                    )
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  final data = _contents[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 413,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(data['image']!),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _contents.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == i ? 36 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == i ? const Color(0xFFCC9913) : const Color(0xFFF6DD9D),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data['headline']!,
                          style: const TextStyle(
                            color: Color(0xFF102F50),
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.08,
                            letterSpacing: -0.51,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['body']!,
                          style: const TextStyle(
                            color: Color(0xFF010D1A),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.75,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0, top: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Visibility(
                      visible: _currentPage > 0,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: OutlinedButton(
                        onPressed: () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF4F48EC), width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                            color: Color(0xFF4F48EC),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _contents.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _navigateToLogin();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE6AC16),
                        foregroundColor: const Color(0xFFFFF9E8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        _contents[_currentPage]['cta']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, height: 1.50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
