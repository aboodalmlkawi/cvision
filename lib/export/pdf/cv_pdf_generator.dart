import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cvision/cv/data/models/cv_model.dart';
import 'package:cvision/cv/templates/classic_cv.dart';
import 'package:cvision/cv/templates/modern_cv.dart';
import 'package:cvision/cv/templates/creative_cv.dart';
import 'package:cvision/cv/templates/minimal_cv.dart';

class CVPdfGenerator {

  static Future<Uint8List> generate(CVModel cv, {String templateType = 'modern'}) async {
    final doc = pw.Document();

    final fontRegular = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          switch (templateType) {
            case 'classic':
              return pw.Column(children: ClassicCV.build(cv, fontRegular, fontBold));
            case 'creative':
              return pw.Column(children: CreativeCV.build(cv, fontRegular, fontBold));
            case 'minimal':
              return pw.Column(children: MinimalCV.build(cv, fontRegular, fontBold));
            case 'modern':
            default:
              return pw.Column(children: ModernCV.build(cv, fontRegular, fontBold));
          }
        },
      ),
    );

    return doc.save();
  }
}