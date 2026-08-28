import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../checker/legal_checker_screen.dart';
import 'profile_dialog.dart';
import '../../services/ai_service.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _selectedModeIndex = 0; // 0: Kamera, 1: Galeri, 2: PDF
  final TextEditingController _kosaKataController = TextEditingController();

  @override
  void dispose() {
    _kosaKataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: -125,
                  left: -15,
                  right: -15,
                  child: SvgPicture.asset(
                    'assets/images/beranda_bg_curve.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 16,
                                  color: Color(0xFFF7F8FC),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Halo User!',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: ' '),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const ProfileDialog(),
                                );
                              },
                              child: Container(
                                width: 43.2,
                                height: 43.2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFF6DD9D),
                                    width: 1.8,
                                  ),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/robot_avatar-24af35.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/legal_checker_icon.png',
                              width: 70.8,
                              height: 64.2,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Legal Situation Checker",
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFF7F8FC),
                                      height: 1.2,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Ceritakan situasimu, kami bantu pahami.",
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xCCF7F8FC),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF2F2B8E),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "TELUSURI KOSA KATA",
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A2332),
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _kosaKataController,
                                decoration: const InputDecoration(
                                  hintText: "Tulis apa yang kamu kurang paham",
                                  hintStyle: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 14, 
                                    fontWeight: FontWeight.w400,
                                    color: Color(0x80100E34),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFC8C6F9),
                                      width: 1.2,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF2F2B8E),
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_kosaKataController.text.trim().isEmpty) return;
                                    
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(child: CircularProgressIndicator()),
                                    );
                                    
                                    try {
                                      final result = await AIService.explainVocabulary(_kosaKataController.text.trim());
                                      if (!context.mounted) {
                                        return;
                                      }
                                      
                                      Navigator.pop(context); // close loading
                                      
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                        ),
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Penjelasan Kosa Kata", 
                                                style: TextStyle(
                                                  fontFamily: 'Manrope',
                                                  fontSize: 16, 
                                                  fontWeight: FontWeight.w800, 
                                                  color: Color(0xFF2F2B8E)
                                                )
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                result.definisi, 
                                                style: const TextStyle(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 14, 
                                                  height: 1.5,
                                                  color: Color(0xFF1A2332)
                                                )
                                              ),
                                              const SizedBox(height: 32),
                                              SizedBox(
                                                width: double.infinity, 
                                                height: 48,
                                                child: ElevatedButton(
                                                  onPressed: () => Navigator.pop(context), 
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF4F48EC),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12)
                                                    )
                                                  ),
                                                  child: const Text("Tutup", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                                )
                                              )
                                            ],
                                          ),
                                        )
                                      );
                                    } catch (e) {
                                      if (!context.mounted) {
                                        return;
                                      }
                                      Navigator.pop(context); // close loading
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFCC9913),
                                    foregroundColor: const Color(0xFFF7F8FC),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Cek Arti",
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 12, 
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PILIH MODE INPUT",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4F48EC),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInputModeCard(0, "Scan Kamera", "Foto Dokumen", "assets/images/scan_kamera.svg")),
                      const SizedBox(width: 8),
                      Expanded(child: _buildInputModeCard(1, "Galeri", "Pilih Foto", "assets/images/galeri.svg")),
                      const SizedBox(width: 8),
                      Expanded(child: _buildInputModeCard(2, "Upload PDF", "Dokumen", "assets/images/upload_pdf.svg")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const LegalSituationChecker()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F48EC),
                        foregroundColor: const Color(0xFFF7F8FC),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Mulai Analisis",
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12, 
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Background handled by parent but styling is here
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cara Kerja",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4F48EC),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Kami memetakan situasi hukummu menjadi empat indikator:",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF100E34),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/cara_kerja_illus-1ea92d.png',
                          width: 131,
                          height: 105,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildIndicatorItem("Hak")),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildIndicatorItem("Risiko")),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _buildIndicatorItem("Kewajiban")),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildIndicatorItem("Langkah")),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "AMAN? adalah panduan pemahaman awal, bukan nasihat hukum profesional.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0x66100E34),
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputModeCard(int index, String title, String subtitle, String svgAsset) {
    bool isSelected = _selectedModeIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedModeIndex = index;
        });
        
        AttachmentType type = AttachmentType.none;
        if (index == 0) {
          type = AttachmentType.camera;
        } else if (index == 1) {
          type = AttachmentType.gallery;
        } else if (index == 2) {
          type = AttachmentType.document;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LegalSituationChecker(initialAttachmentType: type),
          ),
        );
      },
      child: Container(
        height: 122,
        padding: const EdgeInsets.only(top: 5),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF4F48EC) : const Color(0x804F48EC),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(svgAsset, height: 48), // Approx height for icons
              ),
            ),
            Positioned(
              bottom: 15,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2332),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF99A1AF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorItem(String title) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2B8E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2F2B8E),
          width: 1.2,
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Outfit',
          color: Color(0xFFF7F8FC),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
