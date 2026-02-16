import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cvision/cv/data/models/cv_model.dart';

class PdfGenerator {
  static final PdfColor primaryBlue = PdfColor.fromInt(0xFF0D47A1);
  static final PdfColor creativeOrange = PdfColor.fromInt(0xFFFF9800);
  static final PdfColor minimalTeal = PdfColor.fromInt(0xFF009688);
  static final PdfColor classicGrey = PdfColor.fromInt(0xFF455A64);
  static final PdfColor lightGrey = PdfColor.fromInt(0xFFF5F5F5);

  static Future<Uint8List> generate(CVModel cv) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final fontItalic = await PdfGoogleFonts.robotoItalic();

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontItalic,
    );

    final String template = cv.templateId.toLowerCase().trim();

    if (template == 'modern') {
      _buildModernLayout(pdf, cv, theme);
    } else if (template == 'creative') {
      _buildCreativeLayout(pdf, cv, theme);
    } else if (template == 'minimal') {
      _buildMinimalLayout(pdf, cv, theme);
    } else {
      _buildClassicLayout(pdf, cv, theme);
    }

    return await pdf.save();
  }


  static void _buildModernLayout(pw.Document pdf, CVModel cv, pw.ThemeData theme) {
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(theme: theme, margin: pw.EdgeInsets.zero, textDirection: pw.TextDirection.ltr),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            color: primaryBlue,
            width: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(cv.personalInfo.fullName.toUpperCase(),
                    style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                pw.Text(cv.personalInfo.jobTitle,
                    style: pw.TextStyle(fontSize: 18, color: PdfColors.white.withOpacity(0.9))),
                pw.SizedBox(height: 10),
                pw.Row(children: [
                  pw.Text(cv.personalInfo.email, style: const pw.TextStyle(color: PdfColors.white, fontSize: 10)),
                  pw.SizedBox(width: 20),
                  pw.Text(cv.personalInfo.phone, style: const pw.TextStyle(color: PdfColors.white, fontSize: 10)),
                ]),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              _sectionTitle("PROFESSIONAL SUMMARY", primaryBlue),
              pw.Text(cv.personalInfo.summary),
              pw.SizedBox(height: 20),
              _sectionTitle("EXPERIENCE", primaryBlue),
              ...cv.experience.map((e) => _buildExperienceItem(e)),
            ]),
          ),
        ],
      ),
    );
  }

  static void _buildCreativeLayout(pw.Document pdf, CVModel cv, pw.ThemeData theme) {
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(theme: theme, margin: const pw.EdgeInsets.all(30), textDirection: pw.TextDirection.ltr),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 5,
                height: 700,
                color: creativeOrange,
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(cv.personalInfo.fullName, style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold, color: creativeOrange)),
                    pw.Text(cv.personalInfo.jobTitle.toUpperCase(), style: pw.TextStyle(fontSize: 14, letterSpacing: 2)),
                    pw.SizedBox(height: 20),
                    pw.Divider(color: creativeOrange),
                    _sectionTitle("ABOUT ME", creativeOrange),
                    pw.Text(cv.personalInfo.summary),
                    pw.SizedBox(height: 20),
                    _sectionTitle("WORK HISTORY", creativeOrange),
                    ...cv.experience.map((e) => _buildExperienceItem(e)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _buildMinimalLayout(pw.Document pdf, CVModel cv, pw.ThemeData theme) {
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(theme: theme, margin: const pw.EdgeInsets.all(40), textDirection: pw.TextDirection.ltr),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(cv.personalInfo.fullName, style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
                pw.Text(cv.personalInfo.jobTitle, style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
              ]),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                pw.Text(cv.personalInfo.email, style: const pw.TextStyle(fontSize: 10)),
                pw.Text(cv.personalInfo.phone, style: const pw.TextStyle(fontSize: 10)),
              ]),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 0.5),
          pw.SizedBox(height: 20),
          if (cv.personalInfo.summary.isNotEmpty) ...[
            pw.Text("PROFILE", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: minimalTeal, letterSpacing: 1.5)),
            pw.SizedBox(height: 5),
            pw.Text(cv.personalInfo.summary, style: const pw.TextStyle(fontSize: 11)),
            pw.SizedBox(height: 20),
          ],
          pw.Text("EXPERIENCE", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: minimalTeal, letterSpacing: 1.5)),
          pw.SizedBox(height: 10),
          ...cv.experience.map((e) => pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(width: 80, child: pw.Text(e.startDate, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey))),
              pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(e.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text(e.companyName, style: const pw.TextStyle(fontSize: 11)),
              ]))
            ],
          )),
        ],
      ),
    );
  }
  static void _buildClassicLayout(pw.Document pdf, CVModel cv, pw.ThemeData theme) {
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(theme: theme, margin: const pw.EdgeInsets.all(50), textDirection: pw.TextDirection.ltr),
        build: (context) => [
          pw.Center(child: pw.Text(cv.personalInfo.fullName.toUpperCase(), style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
          pw.Center(child: pw.Text(cv.personalInfo.jobTitle, style: const pw.TextStyle(fontSize: 14))),
          pw.SizedBox(height: 5),
          pw.Center(child: pw.Text("${cv.personalInfo.email} • ${cv.personalInfo.phone}", style: const pw.TextStyle(fontSize: 10))),
          pw.SizedBox(height: 10),
          pw.Divider(),
          pw.SizedBox(height: 10),
          _sectionTitle("Professional Experience", PdfColors.black),
          ...cv.experience.map((e) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text(e.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(e.startDate, style: const pw.TextStyle(fontSize: 10)),
              ]),
              pw.Text(e.companyName, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11)),
              pw.Text(e.description, style: const pw.TextStyle(fontSize: 10)),
            ]),
          )),
        ],
      ),
    );
  }

  // Helper Widgets
  static pw.Widget _sectionTitle(String title, PdfColor color) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: color)),
    );
  }

  static pw.Widget _buildExperienceItem(dynamic e) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(e.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          pw.Text(e.companyName, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
          if (e.description.isNotEmpty) pw.Text(e.description, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

extension on PdfColor {
  PdfColor? withOpacity(double d) {}
}