class PanduanModel {
  final String kategori;
  final String judul;
  final String definisi;
  final List<String> poinPenting;
  final List<String> langkahLangkah;

  PanduanModel({
    required this.kategori,
    required this.judul,
    required this.definisi,
    required this.poinPenting,
    required this.langkahLangkah,
  });

  factory PanduanModel.fromJson(Map<String, dynamic> json) {
    return PanduanModel(
      kategori: json['kategori'] ?? 'Umum',
      judul: json['judul'] ?? 'Istilah Hukum',
      definisi: json['definisi'] ?? '',
      poinPenting: List<String>.from(json['poin_penting'] ?? []),
      langkahLangkah: List<String>.from(json['langkah_langkah'] ?? []),
    );
  }
}
