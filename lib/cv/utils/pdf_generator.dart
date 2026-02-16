import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cvision/cv/data/models/cv_model.dart';

Future<Uint8List> generateCV(CVModel cv) async {
  final doc = pw.Document();

  final fontRegular = await PdfGoogleFonts.cairoRegular();
  final fontBold = await PdfGoogleFonts.cairoBold();

  const PdfColor primaryColor = PdfColor.fromInt(0xFF6A1B9A);
  const PdfColor textColor = PdfColors.black;
  const PdfColor subTextColor = PdfColors.grey700;

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
      textDirection: pw.TextDirection.rtl,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    cv.personalInfo.fullName,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(cv.personalInfo.email, style: const pw.TextStyle(fontSize: 10, color: subTextColor)),
                      pw.Text(" | ", style: const pw.TextStyle(fontSize: 10, color: subTextColor)),
                      pw.Text(cv.personalInfo.phone, style: const pw.TextStyle(fontSize: 10, color: subTextColor)),
                      if (cv.personalInfo.address.isNotEmpty) ...[
                        pw.Text(" | ", style: const pw.TextStyle(fontSize: 10, color: subTextColor)),
                        pw.Text(cv.personalInfo.address, style: const pw.TextStyle(fontSize: 10, color: subTextColor)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(color: primaryColor, thickness: 1.5),
            pw.SizedBox(height: 15),

            if (cv.summary.isNotEmpty) ...[
              _buildSectionTitle("النبذة التعريفية", primaryColor),
              pw.Text(
                cv.summary,
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
                textAlign: pw.TextAlign.justify,
              ),
              pw.SizedBox(height: 15),
            ],

            if (cv.skills.isNotEmpty) ...[
              _buildSectionTitle("المهارات", primaryColor),
              pw.Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cv.skills.map((skill) {
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(skill, style: const pw.TextStyle(fontSize: 10)),
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 15),
            ],

            if (cv.education.isNotEmpty) ...[
              _buildSectionTitle("التعليم", primaryColor),
              ...cv.education.map((e) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(e.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                          pw.Text(e.degree, style: const pw.TextStyle(fontSize: 11, color: subTextColor)),
                        ],
                      ),
                      pw.Text(
                        "${e.startDate} - ${e.endDate}",
                        style: const pw.TextStyle(fontSize: 10, color: subTextColor),
                      ),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 15),
            ],

            // --- الخبرات (Experience) ---
            if (cv.experience.isNotEmpty) ...[
              _buildSectionTitle("الخبرات العملية", primaryColor),
              ...cv.experience.map((e) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(e.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                          pw.Text(
                            "${e.startDate} - ${e.endDate}",
                            style: const pw.TextStyle(fontSize: 10, color: subTextColor),
                          ),
                        ],
                      ),
                      pw.Text(e.company, style: const pw.TextStyle(fontSize: 11, color: primaryColor)),
                    ],
                  ),
                );
              }),
            ],
          ],
        );
      },
    ),
  );

  return doc.save();
}

pw.Widget _buildSectionTitle(String title, PdfColor color) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: color, width: 0.5)),
    ),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
        color: color,
      ),
    ),
  );
}