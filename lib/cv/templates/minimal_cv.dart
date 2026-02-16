import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../data/models/cv_model.dart';

class MinimalCV {
  static List<pw.Widget> build(CVModel cv, pw.Font font, pw.Font fontBold) {
    return [
      // Minimal Header (Left Aligned)
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(cv.personalInfo.fullName.toUpperCase(), style: pw.TextStyle(font: fontBold, fontSize: 24, letterSpacing: 2)),
          pw.SizedBox(height: 5),
          pw.Text(cv.personalInfo.email, style: pw.TextStyle(font: font, fontSize: 12)),
          pw.Text(cv.personalInfo.phone, style: pw.TextStyle(font: font, fontSize: 12)),
        ],
      ),
      pw.SizedBox(height: 30),

      // Experience (Clean list)
      if (cv.experience.isNotEmpty) ...[
        pw.Text("EXPERIENCE", style: pw.TextStyle(font: fontBold, fontSize: 12, letterSpacing: 1.5)),
        pw.SizedBox(height: 10),
        ...cv.experience.map((e) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 15),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 80,
                child: pw.Text(e.startDate, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(e.jobTitle, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                    pw.Text(e.companyName, style: pw.TextStyle(font: font, fontSize: 11, fontStyle: pw.FontStyle.italic)),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],

      pw.SizedBox(height: 20),

      // Skills (Simple list)
      if (cv.skills.isNotEmpty) ...[
        pw.Text("SKILLS", style: pw.TextStyle(font: fontBold, fontSize: 12, letterSpacing: 1.5)),
        pw.SizedBox(height: 10),
        pw.Text(cv.skills.join("  •  "), style: pw.TextStyle(font: font, fontSize: 11, lineSpacing: 5)),
      ],
    ];
  }
}