import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cvision/cv/data/models/cv_model.dart';
import '../templates/classic_cv.dart';
import '../templates/modern_cv.dart';
import '../templates/creative_cv.dart';
import '../templates/minimal_cv.dart';

Future<Uint8List> generateCV(CVModel cv, {int templateIndex = 0}) async {
  final doc = pw.Document();

  final fontRegular = await PdfGoogleFonts.cairoRegular();
  final fontBold = await PdfGoogleFonts.cairoBold();

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
      textDirection: pw.TextDirection.rtl,
      build: (pw.Context context) {

        switch (templateIndex) {
          case 1:
            return pw.Column(children: ClassicCV.build(cv, fontRegular, fontBold));
          case 2:
            return pw.Column(children: CreativeCV.build(cv, fontRegular, fontBold));
          case 3:
            return pw.Column(children: MinimalCV.build(cv, fontRegular, fontBold));
          case 0:
          default:
            return pw.Column(children: ModernCV.build(cv, fontRegular, fontBold));
        }
      },
    ),
  );

  return doc.save();
}