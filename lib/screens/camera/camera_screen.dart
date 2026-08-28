import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  void _onCapturePressed() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => _buildAnalyzingDialog(),
    );

    // Simulate analysis delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context); // pop dialog
        Navigator.pop(context, true); // pop camera screen and return true
      }
    });
  }

  Widget _buildAnalyzingDialog() {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Menganalisis Gambar",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF4F48EC),
                letterSpacing: -0.66,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 13),
            SvgPicture.asset(
              'assets/images/robot_analyzing.svg',
              width: 135,
              height: 160,
            ),
            const SizedBox(height: 13),
            Text(
              "Hai haiii mohon bersabar yaak ..,\naku akan berusaha lebih cepat",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18.2,
                fontWeight: FontWeight.w500,
                color: Color(0xFF100E34),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020E1A),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 180, // Leave space for bottom bar
            child: Image.asset(
              'assets/images/camera_placeholder.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 180,
              width: double.infinity,
              color: const Color(0xFF020E1A), // Hitam
              padding: const EdgeInsets.only(top: 25, bottom: 42, left: 33, right: 33),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 58.8),
                      GestureDetector(
                        onTap: _onCapturePressed,
                        child: Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 3.77,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 58.8,
                            height: 58.8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF232D),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 58.8,
                        height: 58.8,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/images/flip_camera.svg',
                          width: 39,
                          height: 39,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Kamera Belakang",
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.6,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFF7F8FC), // Putih
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
