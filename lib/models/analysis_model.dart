import 'dart:io';

class LegalAnalysisRequest {
  final String situasi;
  final String kapan;
  final String dimana;
  final String hasEvidence;
  final String tindakan;
  final File? attachment;

  LegalAnalysisRequest({
    required this.situasi,
    required this.kapan,
    required this.dimana,
    required this.hasEvidence,
    required this.tindakan,
    this.attachment,
  });
}

class LegalAnalysisResponse {
  final String status;
  final String penjelasanSingkat;
  final List<String> potensiRisiko;
  final List<String> langkahHukum;
  final List<String> tips;
  final String disclaimer;

  LegalAnalysisResponse({
    required this.status,
    required this.penjelasanSingkat,
    required this.potensiRisiko,
    required this.langkahHukum,
    required this.tips,
    required this.disclaimer,
  });
}
