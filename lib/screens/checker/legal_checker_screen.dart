import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import '../camera/camera_screen.dart';
import 'tahap2_screen.dart';

enum AttachmentType { none, image, document }

class LegalSituationChecker extends StatefulWidget {
  const LegalSituationChecker({super.key});

  @override
  State<LegalSituationChecker> createState() => _LegalSituationCheckerState();
}

class _LegalSituationCheckerState extends State<LegalSituationChecker> {
  final TextEditingController _inputController = TextEditingController();
  AttachmentType _attachmentType = AttachmentType.none;

  final List<Map<String, String>> _exampleSituations = [
    {
      'icon': '💼',
      'text': 'Kontrak kerja tidak sesuai dengan yang dijanjikan HRD',
    },
    {
      'icon': '🚗',
      'text': 'Terlibat kecelakaan lalu lintas dan pihak lain menuntut',
    },
  ];

  void _selectExample(String text) {
    setState(() {
      _inputController.text = text;
    });
  }

  void _showAttachmentBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "LAMPIRKAN",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    title: "Foto",
                    subtitle: "Buka kamera",
                    iconPath: 'assets/images/scan_kamera.svg',
                    bgColor: const Color(0xFFF3E8FF),
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CameraScreen()),
                      );
                      if (result == true) {
                        setState(() => _attachmentType = AttachmentType.image);
                      }
                    },
                  ),
                  _buildAttachmentOption(
                    title: "Galeri",
                    subtitle: "Pilih foto",
                    iconPath: 'assets/images/galeri.svg',
                    bgColor: const Color(0xFFE0E7FF),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _attachmentType = AttachmentType.image);
                    },
                  ),
                  _buildAttachmentOption(
                    title: "Dokumen",
                    subtitle: "PDF, Word...",
                    iconPath: 'assets/images/upload_pdf.svg',
                    bgColor: const Color(0xFFFEF9C3),
                    isHighlighted: true,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _attachmentType = AttachmentType.document);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Batal", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required String title,
    required String subtitle,
    required String iconPath,
    required Color bgColor,
    bool isHighlighted = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 120,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted ? const Color(0xFFFDE047) : const Color(0xFFC8C6F9),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 40, height: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textDark),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.goldYellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      ),
                      child: const Icon(Icons.smart_toy, size: 60, color: AppColors.brandNavy),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Legal Situation\nChecker",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandNavy,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "CONTOH SITUASI",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._exampleSituations.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: InkWell(
                          onTap: () => _selectExample(item['text']!),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFC8C6F9)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(13),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            ),
                            child: Row(
                              children: [
                                Text(item['icon']!, style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item['text']!,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  )
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_attachmentType == AttachmentType.image)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12, top: 4),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/robot_avatar-24af35.png'), // Placeholder image
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () => setState(() => _attachmentType = AttachmentType.none),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.highlightBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 12, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_attachmentType == AttachmentType.document)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFC8C6F9)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF388E3C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("xlsx", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Catatan_Angsuran (2).xlsx", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textDark)),
                                SizedBox(height: 2),
                                Text("XLSX • 22.1 KB", style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _attachmentType = AttachmentType.none),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.highlightBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  TextField(
                    controller: _inputController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Ceritakan situasi yang sedang kamu hadapi...",
                      hintStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Tahap2Screen(situasi: _inputController.text)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.goldYellow,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Analisis Situasi", style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showAttachmentBottomSheet,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.highlightBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.attach_file, color: Colors.white, size: 24),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
