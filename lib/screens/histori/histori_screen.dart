import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import '../checker/legal_checker_screen.dart';

class HistoriScreen extends StatefulWidget {
  const HistoriScreen({super.key});

  @override
  State<HistoriScreen> createState() => _HistoriScreenState();
}

class _HistoriScreenState extends State<HistoriScreen> {
  int _selectedTab = 0; // 0 for Hasil Analisis, 1 for Istilah Hukum
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light background color for the empty space
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
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
              Positioned(
                bottom: -80,
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
                              onTap: () {
                                setState(() {
                                  _selectedTab = 0;
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
                              onTap: () {
                                setState(() {
                                  _selectedTab = 1;
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
                        decoration: InputDecoration(
                          hintText: _selectedTab == 0 ? "Cari Hasil Analisis" : "Cari Istilah Hukum",
                          hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                          suffixIcon: const Icon(Icons.search, color: AppColors.brandNavy),
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
          
          const SizedBox(height: 100), // Spacing to account for the positioned elements
          Expanded(
            child: SingleChildScrollView(
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
                  
                  if (_searchQuery.isEmpty)
                    const Text(
                      "Kamu belum pernah melakukan analisis",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                    
                  if (_searchQuery.isNotEmpty) ...[
                    const Text(
                      "Analisis tidak ditemukan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.highlightBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Coba gunakan kata kunci lain atau mulai analisis baru",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LegalSituationChecker()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.highlightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Mulai Analisis",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
