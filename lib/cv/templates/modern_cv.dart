import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cvision/cv/data/models/cv_model.dart';

class ModernCV {
  static List<pw.Widget> build(CVModel cv, pw.Font fontRegular, pw.Font fontBold) {
    return [
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(20),
        decoration: const pw.BoxDecoration(
          color: PdfColor.fromInt(0xFF0D47A1),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              cv.personalInfo.fullName,
              style: pw.TextStyle(font: fontBold, fontSize: 26, color: PdfColors.white),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              cv.personalInfo.jobTitle,
              style: pw.TextStyle(font: fontRegular, fontSize: 16, color: PdfColors.white),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
                children: [
                  pw.Text(cv.personalInfo.phone, style: pw.TextStyle(font: fontRegular, fontSize: 12, color: PdfColors.white)),
                  pw.SizedBox(width: 20),
                  pw.Text(cv.personalInfo.email, style: pw.TextStyle(font: fontRegular, fontSize: 12, color: PdfColors.white)),
                ]
            ),
          ],
        ),
      ),

      pw.SizedBox(height: 20),

      if (cv.personalInfo.summary.isNotEmpty) ...[
        _buildSectionTitle("النبذة التعريفية", fontBold),
        pw.Text(cv.personalInfo.summary, style: pw.TextStyle(font: fontRegular, fontSize: 12)),
        pw.SizedBox(height: 20),
      ],

      if (cv.experience.isNotEmpty) ...[
        _buildSectionTitle("الخبرات المهنية", fontBold),
        ...cv.experience.map((e) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(e.jobTitle, style: pw.TextStyle(font: fontBold, fontSize: 14)),
              pw.Text("${e.companyName} | ${e.startDate} - ${e.endDate}", style: pw.TextStyle(font: fontRegular, fontSize: 12, color: PdfColors.grey700)),
              if (e.description.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Text(e.description, style: pw.TextStyle(font: fontRegular, fontSize: 12)),
              ]
            ],
          ),
        )).toList(),
        pw.SizedBox(height: 20),
      ],

      if (cv.education.isNotEmpty) ...[
        _buildSectionTitle("التعليم الأكاديمي", fontBold),
        ...cv.education.map((edu) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(edu.degree, style: pw.TextStyle(font: fontBold, fontSize: 14)),
              pw.Text("${edu.schoolName} | ${edu.startDate} - ${edu.endDate}", style: pw.TextStyle(font: fontRegular, fontSize: 12, color: PdfColors.grey700)),
            ],
          ),
        )).toList(),
      ],
    ];
  }

  static pw.Widget _buildSectionTitle(String title, pw.Font fontBold) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 16, color: const PdfColor.fromInt(0xFF0D47A1))),
          pw.Divider(color: const PdfColor.fromInt(0xFF0D47A1), thickness: 1),
        ],
      ),
    );
  }
}