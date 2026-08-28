import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import 'hasil_analisis_screen.dart';
import '../../models/analysis_model.dart';
import '../../services/gemini_service.dart';

class Tahap3Screen extends StatefulWidget {
  final LegalAnalysisRequest request;
  
  const Tahap3Screen({super.key, required this.request});

  @override
  State<Tahap3Screen> createState() => _Tahap3ScreenState();
}

class _Tahap3ScreenState extends State<Tahap3Screen> {
  int _currentStep = 0;
  bool _hasError = false;
  final List<String> _steps = [
    "Memahami situasimu",
    "Menganalisis informasi",
    "Memetakan potensi risiko",
    "Menyiapkan hasil analisa"
  ];

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  void _startAnalysis() async {
    final animationFuture = _runAnimationSequence();
    
    late LegalAnalysisResponse response;
    try {
      response = await GeminiService.analyzeLegalSituation(widget.request);
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _currentStep = 7; // Failed state
        });
      }
      return;
    }

    await animationFuture;

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HasilAnalisisScreen(response: response)),
      );
    }
  }

  Future<void> _runAnimationSequence() async {
    // 1. Initial State (Menganalisis)
    await Future.delayed(const Duration(seconds: 2));
    if (_hasError) return;
    
    // 2. Processing Steps
    for (int i = 0; i < _steps.length; i++) {
      if (_hasError) return;
      if (mounted) {
        setState(() {
          _currentStep = i + 1;
        });
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    
    if (_hasError) return;
    
    // 3. Hampir Siap State
    if (mounted) {
      setState(() {
        _currentStep = 5; // Hampir siap state
      });
    }
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.goldYellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 18),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "TAHAP 3 DARI 3",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMuted,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFC8C6F9), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFC8C6F9), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Container(width: 20, height: 8, decoration: BoxDecoration(color: AppColors.highlightBlue, borderRadius: BorderRadius.circular(4))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: _buildCurrentStateWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStateWidget() {
    if (_currentStep == 0) {
      return _buildInitialState();
    } else if (_currentStep >= 1 && _currentStep <= 4) {
      return _buildProcessingState();
    } else if (_currentStep == 5) {
      return _buildHampirSiapState();
    } else if (_currentStep == 6) {
      return _buildSinyalLemahState();
    } else {
      return _buildSinyalMatiState();
    }
  }

  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Menganalisis",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.highlightBlue,
          ),
        ),
        const SizedBox(height: 32),
        SvgPicture.asset(
          'assets/images/robot_analyzing.svg',
          width: 140,
          height: 140,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Hai haiii mohon bersabar yaak .., aku akan\nberusaha lebih cepat",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/robot_analyzing.svg',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            const Text(
              "Kami sedang menganalisis\nsituasimu",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.highlightBlue,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Harap tunggu sebentar",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Column(
              children: List.generate(_steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildStepItem(_steps[index], index),
                );
              }),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF), // Light purple
                borderRadius: BorderRadius.circular(24), // Pill shape
                border: Border.all(color: const Color(0xFFC8C6F9)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, color: AppColors.highlightBlue, size: 16),
                  SizedBox(width: 8),
                  Text(
                    "Analisis dilakukan secara aman & privat",
                    style: TextStyle(fontSize: 12, color: AppColors.highlightBlue, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String text, int stepIndex) {
    // Determine the state of the step
    // Since _currentStep goes from 1 to 4 when processing,
    // stepIndex 0 corresponds to step 1.
    bool isCompleted = _currentStep > (stepIndex + 1);
    bool isCurrent = _currentStep == (stepIndex + 1);

    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Widget icon;
    Color textColor = Colors.grey.shade500;
    FontWeight fontWeight = FontWeight.w500;

    if (isCompleted) {
      borderColor = const Color(0xFF10B981); // Green
      icon = Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
        child: const Icon(Icons.check, color: Colors.white, size: 14),
      );
      textColor = AppColors.textDark;
      fontWeight = FontWeight.w700;
    } else if (isCurrent) {
      bgColor = const Color(0xFFF3E8FF); // Light purple
      borderColor = const Color(0xFFC8C6F9); // Purple border
      icon = Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(color: AppColors.highlightBlue, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      );
      textColor = AppColors.textDark;
      fontWeight = FontWeight.w700;
    } else {
      icon = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(
          "${stepIndex + 1}",
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHampirSiapState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Hampir siap",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.highlightBlue,
          ),
        ),
        const SizedBox(height: 32),
        SvgPicture.asset(
          'assets/images/robot_analyzing.svg',
          width: 140,
          height: 140,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Hasil analisismu sudah hampir selesai nih",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSinyalLemahState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Mencoba terhubung",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.highlightBlue,
          ),
        ),
        const SizedBox(height: 32),
        SvgPicture.asset(
          'assets/images/robot_analyzing.svg',
          width: 140,
          height: 140,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Sabar yaa .. koneksinya lagi lama nihhhh",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSinyalMatiState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Gagal Terhubung",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.highlightBlue,
          ),
        ),
        const SizedBox(height: 32),
        SvgPicture.asset(
          'assets/images/robot_analyzing.svg',
          width: 140,
          height: 140,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Aku tidak bisa menemukan sinyalmu nih",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
