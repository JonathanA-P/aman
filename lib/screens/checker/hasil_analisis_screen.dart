import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import 'hasil_analisis_detail_screen.dart';
import '../../models/analysis_model.dart';

class HasilAnalisisScreen extends StatefulWidget {
  final LegalAnalysisResponse response;
  
  const HasilAnalisisScreen({super.key, required this.response});

  @override
  State<HasilAnalisisScreen> createState() => _HasilAnalisisScreenState();
}

class _HasilAnalisisScreenState extends State<HasilAnalisisScreen> {
  bool _isSummaryExpanded = false;
  @override
  void initState() {
    super.initState();
    // Show the warning dialog shortly after screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWarningDialog();
    });
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/robot_analyzing.svg',
                      width: 72,
                      height: 72,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.response.disclaimer,
                        style: TextStyle(fontSize: 13, color: AppColors.brandNavy, fontWeight: FontWeight.w600, height: 1.4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldYellow,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Mengerti", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 320,
              color: AppColors.brandNavy,
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ) // Placeholder for trailing icon or spacing if needed
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.balance, color: Colors.white, size: 32),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hasil analisis situasimu",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Analisis selesai - Tap tiap kartu untuk melihat detail",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(13),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Ringkasan Situasi",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.highlightBlue,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSummaryExpanded = !_isSummaryExpanded;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.goldYellow,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _isSummaryExpanded ? "Sembunyikan" : "Lihat Selengkapnya",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.response.penjelasanSingkat,
                                maxLines: _isSummaryExpanded ? null : 4,
                                overflow: _isSummaryExpanded ? null : TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Poin Penting",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPointCard(
                          title: "Langkah Hukum",
                          desc: widget.response.langkahHukum.isNotEmpty ? widget.response.langkahHukum.first : "Tidak ada rekomendasi khusus",
                          icon: Icons.balance,
                          pointCount: widget.response.langkahHukum.length,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HasilAnalisisDetailScreen(
                                title: "Langkah Hukum",
                                description: widget.response.langkahHukum.map((e) => "- \$e").join('\n\n'),
                                icon: Icons.balance,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPointCard(
                          title: "Potensi Risiko",
                          desc: widget.response.potensiRisiko.isNotEmpty ? widget.response.potensiRisiko.first : "Risiko rendah",
                          icon: Icons.gavel,
                          pointCount: widget.response.potensiRisiko.length,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HasilAnalisisDetailScreen(
                                title: "Potensi Risiko",
                                description: widget.response.potensiRisiko.map((e) => "- \$e").join('\n\n'),
                                icon: Icons.gavel,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPointCard(
                          title: "Tips Tambahan",
                          desc: widget.response.tips.isNotEmpty ? widget.response.tips.first : "Pastikan mengumpulkan bukti yang cukup",
                          icon: Icons.lightbulb,
                          pointCount: widget.response.tips.length,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HasilAnalisisDetailScreen(
                                title: "Tips Tambahan",
                                description: widget.response.tips.map((e) => "- \$e").join('\n\n'),
                                icon: Icons.lightbulb,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Pop back to first screen (Beranda)
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldYellow,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Mulai Analisis Baru", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointCard({
    required String title,
    required String desc,
    required IconData icon,
    required int pointCount,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandNavy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.goldYellow, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.highlightBlue),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.goldYellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Jelaskan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 12),
          Text(
            "\$pointCount poin penting ditemukan",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
