import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../data/models/cv_model.dart';

class CreativeCV {
  static List<pw.Widget> build(CVModel cv, pw.Font font, pw.Font fontBold) {
    final primaryColor = PdfColors.blueGrey900;
    final sidebarColor = PdfColors.blueGrey50;

    // Creative Layout uses a Row to split the page
    return [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Sidebar (Left - 1/3)
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              color: sidebarColor,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Contact Info
                  _sidebarTitle("تواصل معي", fontBold, primaryColor),
                  _sidebarItem(cv.personalInfo.email, font),
                  _sidebarItem(cv.personalInfo.phone, font),
                  _sidebarItem(cv.personalInfo.address, font),
                  pw.SizedBox(height: 20),

                  // Skills
                  _sidebarTitle("المهارات", fontBold, primaryColor),
                  ...cv.skills.map((s) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 4),
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: pw.BoxDecoration(color: PdfColors.white, borderRadius: pw.BorderRadius.circular(4)),
                    child: pw.Text(s, style: pw.TextStyle(font: font, fontSize: 10, color: primaryColor)),
                  )),
                ],
              ),
            ),
          ),

          pw.SizedBox(width: 20),

          // Main Content (Right - 2/3)
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Text(cv.personalInfo.fullName, style: pw.TextStyle(font: fontBold, fontSize: 28, color: primaryColor)),
                pw.Text("Expert Developer", style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.grey600)), // Placeholder title
                pw.SizedBox(height: 20),

                // Summary
                if (cv.summary.isNotEmpty) ...[
                  pw.Text("نبذة عني", style: pw.TextStyle(font: fontBold, fontSize: 16, color: primaryColor)),
                  pw.Text(cv.summary, style: pw.TextStyle(font: font, fontSize: 11)),
                  pw.SizedBox(height: 20),
                ],

                // Experience
                if (cv.experience.isNotEmpty) ...[
                  pw.Text("الخبرات", style: pw.TextStyle(font: fontBold, fontSize: 16, color: primaryColor)),
                  pw.Divider(color: primaryColor, thickness: 2),
                  ...cv.experience.map((e) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 10),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(e.jobTitle, style: pw.TextStyle(font: fontBold, fontSize: 13)),
                      pw.Text(e.companyName, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey700)),
                      pw.Text("${e.startDate} - ${e.endDate}", style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey500)),
                    ]),
                  )),
                ],
              ],
            ),
          ),
        ],
      )
    ];
  }

  static pw.Widget _sidebarTitle(String text, pw.Font font, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 14, fontWeight: pw.FontWeight.bold, color: color)),
    );
  }

  static pw.Widget _sidebarItem(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey800)),
    );
  }
}