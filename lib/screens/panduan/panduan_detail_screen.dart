import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/panduan_model.dart';

class PanduanDetailScreen extends StatelessWidget {
  final PanduanModel panduan;

  const PanduanDetailScreen({super.key, required this.panduan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Curved Blue Header Background
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              height: 280,
              decoration: const BoxDecoration(
                color: AppColors.brandNavy,
              ),
            ),
          ),
          
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Nav Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        ),
                      ),
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          panduan.kategori,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Header Image
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/legal_checker_icon.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Main Content Area
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Scrollable content
                      Positioned.fill(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            top: 60, // Space for the overlapping title card
                            left: 20,
                            right: 20,
                            bottom: 100, // Space for the bottom button
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                panduan.definisi,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade700,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 32),
                              
                              // Timeline list for Poin Penting
                              ...List.generate(panduan.poinPenting.length, (index) {
                                bool isLast = index == panduan.poinPenting.length - 1;
                                return _buildTimelineItem(
                                  (index + 1).toString(),
                                  panduan.poinPenting[index],
                                  isLast,
                                );
                              }),

                              const SizedBox(height: 32),
                              
                              // Expansion Tile for Langkah-Langkah
                              if (panduan.langkahLangkah.isNotEmpty)
                                _buildExpansionLangkah(panduan.langkahLangkah),
                            ],
                          ),
                        ),
                      ),

                      // Overlapping Title Card
                      Positioned(
                        top: -10,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFC8C6F9), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            panduan.judul,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brandNavy,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDCA91D), // Gold/Yellow button
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Tutup",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String number, String text, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9EEFF), // Light purple background
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    number,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brandNavy,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey.shade300,
                    ),
                  )
                else
                  const SizedBox(height: 16), // Padding for last item
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 2), // Space between items
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionLangkah(List<String> langkah) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6FF), // Very light purple/blue background
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC8C6F9), width: 1.5),
        ),
        child: ExpansionTile(
          iconColor: AppColors.brandNavy,
          collapsedIconColor: AppColors.brandNavy,
          title: const Text(
            "Langkah yang bisa dilakukan",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.brandNavy,
            ),
          ),
          childrenPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
          children: langkah.map((step) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCA91D), // Yellow dot
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    
    // Create a smooth wave effect
    path.quadraticBezierTo(
      size.width * 0.25, 
      size.height, 
      size.width * 0.5, 
      size.height - 30,
    );
    
    path.quadraticBezierTo(
      size.width * 0.75, 
      size.height - 60, 
      size.width, 
      size.height - 20,
    );
    
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
