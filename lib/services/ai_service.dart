import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/analysis_model.dart';
import '../models/panduan_model.dart';

class AIService {
  // We use GROQ_API_KEY from .env
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  
  static Future<LegalAnalysisResponse> analyzeLegalSituation(LegalAnalysisRequest request) async {
    if (_apiKey.isEmpty) {
      throw Exception('Groq API Key is not set in .env file.');
    }

    final systemInstruction = '''
Kamu adalah pengacara dan asisten hukum AI yang ahli di Indonesia. Tugasmu adalah menganalisis situasi hukum yang diberikan pengguna dan memberikan penjelasan, potensi risiko, serta langkah yang harus diambil. Jawabanmu harus sangat spesifik dan berkaitan langsung dengan detail kasus/situasi yang diberikan oleh pengguna.
Format jawabanmu HARUS berupa JSON murni dengan struktur sebagai berikut:
{
  "status": "Aman" / "Hati-hati" / "Bahaya",
  "penjelasanSingkat": "Penjelasan singkat tentang situasi tersebut (maks 3 kalimat).",
  "potensiRisiko": ["Sebutkan risiko spesifik dari situasi ini", "Sebutkan risiko lainnya"],
  "langkahHukum": ["Langkah hukum spesifik pertama", "Langkah hukum spesifik kedua"],
  "tips": ["Tips spesifik 1", "Tips spesifik 2"],
  "disclaimer": "Penjelasan bahwa ini bukan nasihat hukum profesional."
}
Pastikan hanya mengembalikan JSON tanpa tambahan teks lain atau markdown formatting.
''';

    final prompt = '''
Analisis situasi berikut:
- Situasi/Masalah: ${request.situasi}
- Waktu Kejadian: ${request.kapan}
- Lokasi Kejadian: ${request.dimana}
- Ada Bukti?: ${request.hasEvidence}
- Tindakan yang sudah dilakukan: ${request.tindakan}
''';

    try {
      String modelName = 'qwen/qwen3.8-27b';
      final List<Map<String, dynamic>> userMessageContent = [
        {'type': 'text', 'text': prompt}
      ];

      // Jika ada attachment gambar, kita gunakan model Vision
      if (request.attachment != null) {
        final path = request.attachment!.path.toLowerCase();
        if (path.endsWith('.png') || path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.webp')) {
          modelName = 'qwen/qwen3.8-27b';
          final bytes = await request.attachment!.readAsBytes();
          final base64Image = base64Encode(bytes);
          
          String mimeType = 'image/jpeg';
          if (path.endsWith('.png')) mimeType = 'image/png';
          else if (path.endsWith('.webp')) mimeType = 'image/webp';
          
          userMessageContent.add({
            'type': 'image_url',
            'image_url': {
              'url': 'data:$mimeType;base64,$base64Image',
            }
          });
        }
      }

      final requestBody = {
        'model': modelName,
        'messages': [
          {'role': 'system', 'content': systemInstruction},
          {'role': 'user', 'content': userMessageContent}
        ],
        'temperature': 0.1,
      };

      // Vision model di Groq saat ini tidak mendukung response_format json_object
      if (modelName != 'qwen/qwen3.8-27b_vision_disabled') {
        requestBody['response_format'] = {'type': 'json_object'};
      }

      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception("Groq API Error: ${response.body}");
      }

      final responseData = jsonDecode(response.body);
      final responseText = responseData['choices'][0]['message']['content'] as String?;
      
      if (responseText == null || responseText.isEmpty) {
        throw Exception("Empty response from AI.");
      }

      String cleanText = responseText;
      if (cleanText.startsWith('```json')) {
        cleanText = cleanText.substring(7);
      } else if (cleanText.startsWith('```')) {
        cleanText = cleanText.substring(3);
      }
      if (cleanText.endsWith('```')) {
        cleanText = cleanText.substring(0, cleanText.length - 3);
      }
      
      final jsonMap = jsonDecode(cleanText.trim());
      
      return LegalAnalysisResponse(
        status: jsonMap['status'] ?? 'Hati-hati',
        penjelasanSingkat: jsonMap['penjelasanSingkat'] ?? '-',
        potensiRisiko: List<String>.from(jsonMap['potensiRisiko'] ?? []),
        langkahHukum: List<String>.from(jsonMap['langkahHukum'] ?? []),
        tips: List<String>.from(jsonMap['tips'] ?? []),
        disclaimer: jsonMap['disclaimer'] ?? 'Analisis ini dihasilkan oleh AI dan bukan merupakan nasihat hukum profesional. Silakan berkonsultasi dengan advokat/pengacara untuk langkah lebih lanjut.',
      );

    } catch (e) {
      throw Exception('Gagal menganalisis data: $e');
    }
  }

  static Future<PanduanModel> explainVocabulary(String word) async {
    if (_apiKey.isEmpty) {
      throw Exception('Groq API Key is not set in .env file.');
    }

    final systemInstruction = '''
Kamu adalah asisten hukum AI yang ahli di Indonesia. Tugasmu adalah menjelaskan istilah hukum yang diberikan oleh pengguna.
Kamu harus merespons dalam format JSON murni TANPA markdown block (tanpa ```json dan ```).
Pastikan format JSON sesuai dengan struktur berikut:
{
  "kategori": "Kategori istilah ini, misal: Pekerjaan, Pidana, Perdata, Umum",
  "judul": "Istilah yang dicari (diformat dengan benar)",
  "definisi": "Penjelasan singkat dalam maksimal 1-3 kalimat.",
  "poin_penting": ["Poin 1 (misal Hak Pekerja/Unsur Hukum)", "Poin 2", "Poin 3"],
  "langkah_langkah": ["Langkah 1 yang bisa dilakukan", "Langkah 2", "Langkah 3"]
}
Gunakan bahasa Indonesia yang mudah dipahami orang awam. Jangan tambahkan teks apa pun di luar JSON.
''';

    final prompt = 'Jelaskan arti dari istilah hukum ini: $word';

    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'qwen/qwen3.8-27b',
          'messages': [
            {'role': 'system', 'content': systemInstruction},
            {'role': 'user', 'content': prompt}
          ],
          'response_format': {'type': 'json_object'},
          'temperature': 0.1,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Groq API Error: ${response.body}");
      }

      final responseData = jsonDecode(response.body);
      final text = responseData['choices'][0]['message']['content'] as String?;
      
      String cleanText = text ?? '{}';
      if (cleanText.startsWith('```json')) {
        cleanText = cleanText.substring(7);
      } else if (cleanText.startsWith('```')) {
        cleanText = cleanText.substring(3);
      }
      if (cleanText.endsWith('```')) {
        cleanText = cleanText.substring(0, cleanText.length - 3);
      }
      
      final jsonMap = jsonDecode(cleanText.trim());
      return PanduanModel.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Gagal menghubungi AI: $e');
    }
  }
}
