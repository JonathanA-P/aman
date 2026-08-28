import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/panduan_model.dart';
import 'panduan_detail_screen.dart';
import '../../services/ai_service.dart';

class PanduanScreen extends StatefulWidget {
  const PanduanScreen({super.key});

  @override
  State<PanduanScreen> createState() => _PanduanScreenState();
}

class _PanduanScreenState extends State<PanduanScreen> {
  final List<String> _categories = ["Semua", "Pekerjaan", "Kontrak", "Perdata"];
  int _selectedCategoryIndex = 0;
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _searchVocabulary(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final panduan = await AIService.explainVocabulary(query);
      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PanduanDetailScreen(panduan: panduan),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  final List<Map<String, String>> _guidelines = [
    {
      "title": "PHK Sepihak",
      "subtitle": "Hak & Kompensasi yang harus kamu dapat"
    },
    {
      "title": "Hak Imunitas",
      "subtitle": "Perlindungan dalam profesi tertentu"
    },
    {
      "title": "Somasi",
      "subtitle": "Langkah pertama sebelum jalur hukum"
    },
    {
      "title": "Klaim Balik",
      "subtitle": "Tuntutan balik dalam persidangan"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.brandNavy,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/legal_checker_icon.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Panduan",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Pahami istilah dan kasus hukum sehari hari",
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
              Positioned(
                bottom: -24,
                left: 20,
                right: 20,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13), // ~0.05 opacity
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _searchVocabulary,
                    decoration: InputDecoration(
                      hintText: "Cari istilah hukum...",
                      hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                      suffixIcon: _isLoading 
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.brandNavy),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.search, color: AppColors.brandNavy),
                              onPressed: () => _searchVocabulary(_searchController.text),
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
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.brandNavy : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.brandNavy : Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _guidelines.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _guidelines[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PanduanDetailScreen(
                          panduan: PanduanModel(
                            kategori: "Hukum",
                            judul: item["title"]!,
                            definisi: "Ini adalah penjelasan singkat mengenai ${item['title']}. (Fitur ini sedang dalam pengembangan, gunakan pencarian 'Istilah Hukum' di menu Histori untuk definisi AI).",
                            poinPenting: ["Poin 1 terkait ${item['title']}", "Poin 2 terkait ${item['title']}"],
                            langkahLangkah: ["Langkah pertama", "Langkah kedua"],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFC8C6F9), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5), // ~0.02 opacity
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9EEFF), // Very light purple/pink
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.book, color: Colors.blueAccent),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"]!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["subtitle"]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textBody,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Color(0xFFC8C6F9)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
