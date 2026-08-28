import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'tahap3_screen.dart';
import '../../models/analysis_model.dart';

class Tahap2Screen extends StatefulWidget {
  final String situasi;
  const Tahap2Screen({super.key, required this.situasi});

  @override
  State<Tahap2Screen> createState() => _Tahap2ScreenState();
}

class _Tahap2ScreenState extends State<Tahap2Screen> {
  String _hasEvidence = "Ada";
  final TextEditingController _kapanController = TextEditingController();
  final TextEditingController _dimanaController = TextEditingController();
  final TextEditingController _tindakanController = TextEditingController();

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
                  "TAHAP 2 DARI 3",
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
                    Container(width: 20, height: 8, decoration: BoxDecoration(color: AppColors.highlightBlue, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(width: 4),
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/beranda_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Kapan kejadian tersebut terjadi?"),
                    const SizedBox(height: 8),
                    _buildTextField("Ketikkan sesuatu", _kapanController),
                    const SizedBox(height: 24),
                    
                    _buildLabel("Dimana kejadian tersebut terjadi?"),
                    const SizedBox(height: 8),
                    _buildTextField("Ketikkan sesuatu", _dimanaController),
                    const SizedBox(height: 24),

                    _buildLabel("Apakah kamu memiliki bukti?"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildOption("Ada")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildOption("Tidak Ada")),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _buildLabel("Apa yang sudah kamu lakukan?"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _tindakanController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Misal: Sudah menghubungi HRD lewat WhatsApp, tapi tidak direspon selama 2 minggu...",
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFC8C6F9), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.highlightBlue, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
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
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF), // Light purple
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC8C6F9)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock_outline, color: AppColors.highlightBlue, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 11, color: AppColors.highlightBlue, height: 1.4, fontFamily: 'Manrope'),
                              children: [
                                const TextSpan(text: "Privasi terjaga. ", style: TextStyle(fontWeight: FontWeight.w800)),
                                TextSpan(text: "Informasi yang kamu berikan hanya digunakan untuk analisis ini dan tidak disimpan permanen.", style: TextStyle(color: AppColors.highlightBlue)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final request = LegalAnalysisRequest(
                          situasi: widget.situasi,
                          kapan: _kapanController.text,
                          dimana: _dimanaController.text,
                          hasEvidence: _hasEvidence,
                          tindakan: _tindakanController.text,
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Tahap3Screen(request: request)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldYellow,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Selanjutnya", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC8C6F9), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.highlightBlue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _buildOption(String value) {
    bool isSelected = _hasEvidence == value;
    return GestureDetector(
      onTap: () {
        setState(() => _hasEvidence = value);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.highlightBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.highlightBlue : const Color(0xFFC8C6F9),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
