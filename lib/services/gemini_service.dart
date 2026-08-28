import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/analysis_model.dart';

class GeminiService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  
  static Future<LegalAnalysisResponse> analyzeLegalSituation(LegalAnalysisRequest request) async {
    if (_apiKey.isEmpty) {
      throw Exception('Gemini API Key is not set.');
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
      systemInstruction: Content.system('''
Kamu adalah asisten hukum AI yang ahli di Indonesia. Tugasmu adalah menganalisis situasi hukum yang diberikan pengguna dan memberikan penjelasan yang mudah dipahami, potensi risiko, serta langkah yang harus diambil. 
Format jawabanmu HARUS berupa JSON dengan struktur sebagai berikut:
{
  "status": "Aman" / "Hati-hati" / "Bahaya",
  "penjelasanSingkat": "Penjelasan singkat tentang situasi tersebut (maks 3 kalimat).",
  "potensiRisiko": ["Risiko 1", "Risiko 2"],
  "langkahHukum": ["Langkah 1", "Langkah 2"],
  "tips": ["Tips 1", "Tips 2"],
  "disclaimer": "Penjelasan bahwa ini bukan nasihat hukum profesional."
}
'''),
    );

    final prompt = '''
Analisis situasi berikut:
- Situasi/Masalah: ${request.situasi}
- Waktu Kejadian: ${request.kapan}
- Lokasi Kejadian: ${request.dimana}
- Ada Bukti?: ${request.hasEvidence}
- Tindakan yang sudah dilakukan: ${request.tindakan}
''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        throw Exception("Empty response from Gemini.");
      }

      final jsonMap = jsonDecode(responseText);
      
      return LegalAnalysisResponse(
        status: jsonMap['status'] ?? 'Hati-hati',
        penjelasanSingkat: jsonMap['penjelasanSingkat'] ?? '-',
        potensiRisiko: List<String>.from(jsonMap['potensiRisiko'] ?? []),
        langkahHukum: List<String>.from(jsonMap['langkahHukum'] ?? []),
        tips: List<String>.from(jsonMap['tips'] ?? []),
        disclaimer: jsonMap['disclaimer'] ?? 'Analisis ini dihasilkan oleh AI dan bukan merupakan nasihat hukum profesional. Silakan berkonsultasi dengan advokat/pengacara untuk langkah lebih lanjut.',
      );

    } catch (e) {
      throw Exception('Gagal menganalisis data: \$e');
    }
  }
}
