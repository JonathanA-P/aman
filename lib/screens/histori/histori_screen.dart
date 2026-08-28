import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/ai_service.dart';
import '../../models/panduan_model.dart';
import '../../models/analysis_model.dart';
import '../panduan/panduan_detail_screen.dart';
import '../checker/hasil_analisis_screen.dart';

class HistoriScreen extends StatefulWidget {
  const HistoriScreen({super.key});

  @override
  State<HistoriScreen> createState() => _HistoriScreenState();
}

class _HistoriScreenState extends State<HistoriScreen> {
  int _selectedTab = 0; // 0 for Hasil Analisis, 1 for Istilah Hukum
  String _searchQuery = "";
  bool _isLoading = false;
  
  final List<Map<String, String>> _dummyHasilAnalisis = [
    {"title": "Penipuan Online", "date": "Hari ini"},
    {"title": "Pencurian Kendaraan", "date": "Kemarin"},
    {"title": "Sengketa Lahan", "date": "23 Jan"},
    {"title": "Pencemaran Nama Baik", "date": "20 Jan"},
    {"title": "Masalah Ketenagakerjaan", "date": "18 Jan"},
  ];

  final List<Map<String, String>> _dummyIstilahHukum = [
    {"title": "Wanprestasi", "desc": "Kelalaian debitur dalam memenuhi..."},
    {"title": "Gugatan", "desc": "Tuntutan hak ke pengadilan..."},
    {"title": "Somasi", "desc": "Teguran tertulis sebelum..."},
    {"title": "Pidana", "desc": "Tindak kejahatan yang..."},
    {"title": "Perdata", "desc": "Hukum yang mengatur hubungan..."},
  ];

  Future<void> _searchVocabulary(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final panduan = await AIService.explainVocabulary(query);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PanduanDetailScreen(panduan: panduan),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mencari istilah: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light background color for the empty space
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.brandNavy,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/legal_checker_icon.png',
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Histori",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Berisi daftar kosa kata dan riwayat pencarianmu",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 20,
                right: 20,
                child: Column(
                  children: [
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  _selectedTab = 0;
                                  _searchQuery = ""; // Reset search when switching tabs
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedTab == 0 ? AppColors.goldYellow : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Hasil Analisis",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _selectedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                                    color: _selectedTab == 0 ? Colors.white : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  _selectedTab = 1;
                                  _searchQuery = ""; // Reset search when switching tabs
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedTab == 1 ? AppColors.goldYellow : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Istilah Hukum",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _selectedTab == 1 ? FontWeight.w700 : FontWeight.w500,
                                    color: _selectedTab == 1 ? Colors.white : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onSubmitted: (value) {
                          if (_selectedTab == 1) {
                            _searchVocabulary(value);
                          } else {
                            setState(() {
                              _searchQuery = value;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: _selectedTab == 0 ? "Cari Hasil Analisis" : "Cari Istilah Hukum (tekan Enter)",
                          hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                          suffixIcon: _isLoading 
                              ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 16, 
                                    height: 16, 
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.brandNavy)
                                  ),
                                )
                              : GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (_selectedTab == 1 && _searchQuery.isNotEmpty) {
                                      _searchVocabulary(_searchQuery);
                                    } else if (_selectedTab == 0) {
                                      setState(() {
                                        // It will automatically filter because _searchQuery is in state
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.search, color: AppColors.brandNavy),
                                ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFC8C6F9), width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFC8C6F9), width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.brandNavy, width: 1.2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20), // Reduced from 100 because 80 was absorbed by the Stack
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _selectedTab == 0 ? _buildListHasilAnalisis() : _buildListIstilahHukum(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Image.asset(
            'assets/images/robot_avatar-24af35.png', // Placeholder for the sad robot
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
          const Text(
            "Pencarian tidak ditemukan",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.highlightBlue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Coba gunakan kata kunci lain",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHasilAnalisis() {
    final filteredData = _searchQuery.isEmpty 
      ? _dummyHasilAnalisis 
      : _dummyHasilAnalisis.where((item) => 
          item['title']!.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();

    if (filteredData.isEmpty) {
      return _buildEmptySearchState();
    }
    
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = filteredData[index];
        return GestureDetector(
          onTap: () {
            // Dummy response for history detail
            final dummyResponse = LegalAnalysisResponse(
              status: "Hati-hati",
              penjelasanSingkat: "Masalah ${item['title']} ini memerlukan perhatian karena berpotensi merugikan hak hukum Anda. Segera lakukan dokumentasi.",
              potensiRisiko: ["Kehilangan hak kepemilikan atau uang", "Tuntutan balik dari pihak lain", "Proses yang memakan waktu lama"],
              langkahHukum: ["Kumpulkan semua bukti transaksi atau surat menyurat", "Berikan somasi tertulis", "Konsultasi ke mediator atau advokat"],
              tips: ["Jangan menghapus chat atau bukti apapun", "Bersikap kooperatif namun tegas"],
              disclaimer: "Analisis ini dihasilkan oleh AI berdasarkan riwayat masa lalu dan bukan nasihat hukum profesional."
            );
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => HasilAnalisisScreen(
                response: dummyResponse,
                isFromHistory: true,
              ))
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE9EBF8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.description_outlined, color: AppColors.brandNavy),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.brandNavy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['date']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListIstilahHukum() {
    final filteredData = _searchQuery.isEmpty 
      ? _dummyIstilahHukum 
      : _dummyIstilahHukum.where((item) => 
          item['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) || 
          item['desc']!.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();

    if (filteredData.isEmpty && !_isLoading) {
      return _buildEmptySearchState();
    }
    
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = filteredData[index];
        return GestureDetector(
          onTap: () {
            // Dummy response for history detail
            final dummyPanduan = PanduanModel(
              kategori: "Umum",
              judul: item['title']!,
              definisi: item['desc']!,
              poinPenting: ["Terkait dengan hukum perdata", "Membutuhkan bukti tertulis"],
              langkahLangkah: ["Konsultasikan dengan pengacara", "Kumpulkan dokumen pendukung"]
            );
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => PanduanDetailScreen(
                panduan: dummyPanduan,
              ))
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE9EBF8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_book_outlined, color: AppColors.goldYellow),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.brandNavy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['desc']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      );
    },
  );
  }
}
