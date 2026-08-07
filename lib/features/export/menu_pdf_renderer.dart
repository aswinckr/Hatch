import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../menu/data/menu_repository.dart';
import '../menu/domain/dish.dart';

class EmptyMenuException implements Exception {
  const EmptyMenuException();
}

class MenuPdfRenderer {
  List<MealSection> includedSections(MenuSnapshot snapshot) => MealSection
      .values
      .where(
        (section) => snapshot.dishes.any((dish) => dish.mealSection == section),
      )
      .toList(growable: false);

  Future<Uint8List> render(MenuSnapshot snapshot) async {
    if (snapshot.dishes.isEmpty) throw const EmptyMenuException();
    const colors = _PdfPalette.standard;
    final outfit = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Outfit.ttf'),
    );
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(18 * PdfPageFormat.mm),
          theme: pw.ThemeData.withFont(
            base: outfit,
            bold: outfit,
            italic: outfit,
          ),
        ),
        build: (_) => [
          pw.Center(
            child: pw.Text(
              'FAVOURITE PLACES',
              style: pw.TextStyle(
                fontSize: 9,
                letterSpacing: 3,
                color: colors.accent,
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text(
              'The Menu',
              style: pw.TextStyle(
                font: outfit,
                fontSize: 30,
                color: colors.ink,
              ),
            ),
          ),
          pw.SizedBox(height: 18),
          for (final section in includedSections(snapshot))
            ..._section(snapshot, section, colors, outfit),
        ],
      ),
    );
    return document.save();
  }

  List<pw.Widget> _section(
    MenuSnapshot snapshot,
    MealSection section,
    _PdfPalette colors,
    pw.Font outfit,
  ) {
    final dishes =
        snapshot.dishes.where((dish) => dish.mealSection == section).toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return [
      pw.Center(
        child: pw.Text(
          section.label.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 10,
            letterSpacing: 2.2,
            color: colors.accent,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
      pw.SizedBox(height: 12),
      for (final dish in dishes)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 15),
          child: pw.Column(
            children: [
              pw.Text(
                dish.name,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: outfit,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                  color: colors.ink,
                ),
              ),
              if (dish.description.trim().isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 3),
                  child: pw.Text(
                    dish.description,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10, color: colors.ink),
                  ),
                ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4),
                child: pw.Text(
                  dish.restaurant,
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontStyle: pw.FontStyle.italic,
                    color: colors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      pw.SizedBox(height: 8),
    ];
  }
}

class _PdfPalette {
  const _PdfPalette(this.ink, this.accent);
  final PdfColor ink, accent;
  static const standard = _PdfPalette(
    PdfColor.fromInt(0xFF2B211B),
    PdfColor.fromInt(0xFF1F4D3A),
  );
}
