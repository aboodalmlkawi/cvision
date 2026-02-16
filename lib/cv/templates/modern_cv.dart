import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:cvision/cv/data/models/cv_model.dart';

class ModernTemplate {
  final CVModel cv;
  ModernTemplate({required this.cv});

  pw.Widget build() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Text(cv.personalInfo.fullName.toUpperCase(),
            style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
        pw.Text(cv.personalInfo.jobTitle,
            style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
        pw.SizedBox(height: 5),
        pw.Text("Email: ${cv.personalInfo.email} | Phone: ${cv.personalInfo.phone}",
            style: const pw.TextStyle(fontSize: 10)),

        pw.Divider(thickness: 1, color: PdfColors.blue900),
        pw.SizedBox(height: 15),

        // Summary Section
        _sectionTitle("PROFESSIONAL SUMMARY"),
        pw.Text(cv.personalInfo.summary, style: const pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 20),

        // Experience Section
        if (cv.experience.isNotEmpty) ...[
          _sectionTitle("WORK EXPERIENCE"),
          ...cv.experience.map((exp) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(exp.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(exp.startDate, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                  ],
                ),
                pw.Text(exp.companyName, style: const pw.TextStyle(fontSize: 10, color: PdfColors.blueGrey700)),
              ],
            ),
          )),
        ],

        pw.SizedBox(height: 15),

        // Skills Section
        if (cv.skills.isNotEmpty) ...[
          _sectionTitle("TECHNICAL SKILLS"),
          pw.Text(cv.skills.join(" • "), style: const pw.TextStyle(fontSize: 11)),
        ],
      ],
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Text(title,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
    );
  }
}