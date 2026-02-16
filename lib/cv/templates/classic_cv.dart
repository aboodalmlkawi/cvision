import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../data/models/cv_model.dart';

class ClassicCV {
  static List<pw.Widget> build(CVModel cv, pw.Font font, pw.Font fontBold) {
    final themeColor = PdfColors.black;

    return [
      // 1. Header (Centered)
      pw.Center(
        child: pw.Column(
          children: [
            pw.Text(cv.personalInfo.fullName, style: pw.TextStyle(font: fontBold, fontSize: 24)),
            pw.SizedBox(height: 5),
            pw.Text("${cv.personalInfo.email} | ${cv.personalInfo.phone}", style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey700)),
            if (cv.personalInfo.address.isNotEmpty)
              pw.Text(cv.personalInfo.address, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey700)),
          ],
        ),
      ),
      pw.Divider(color: themeColor, thickness: 1),
      pw.SizedBox(height: 20),

      // 2. Summary
      if (cv.summary.isNotEmpty) ...[
        _sectionTitle("النبذة التعريفية", fontBold),
        pw.Text(cv.summary, style: pw.TextStyle(font: font, fontSize: 12), textAlign: pw.TextAlign.justify),
        pw.SizedBox(height: 15),
      ],

      // 3. Education
      if (cv.education.isNotEmpty) ...[
        _sectionTitle("التعليم", fontBold),
        ...cv.education.map((e) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 5),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(e.schoolName, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                pw.Text(e.degree, style: pw.TextStyle(font: font, fontSize: 11)),
              ]),
              pw.Text("${e.startDate} - ${e.endDate}", style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
            ],
          ),
        )),
        pw.SizedBox(height: 15),
      ],

      // 4. Experience
      if (cv.experience.isNotEmpty) ...[
        _sectionTitle("الخبرات العملية", fontBold),
        ...cv.experience.map((e) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(e.jobTitle, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                  pw.Text("${e.startDate} - ${e.endDate}", style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
                ],
              ),
              pw.Text(e.companyName, style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.grey700)),
            ],
          ),
        )),
        pw.SizedBox(height: 15),
      ],

      // 5. Skills
      if (cv.skills.isNotEmpty) ...[
        _sectionTitle("المهارات", fontBold),
        pw.Wrap(
          spacing: 10,
          children: cv.skills.map((s) => pw.Text("• $s", style: pw.TextStyle(font: font, fontSize: 12))).toList(),
        ),
      ],
    ];
  }

  static pw.Widget _sectionTitle(String title, pw.Font font) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400))),
      child: pw.Text(title, style: pw.TextStyle(font: font, fontSize: 14, fontWeight: pw.FontWeight.bold)),
    );
  }
}