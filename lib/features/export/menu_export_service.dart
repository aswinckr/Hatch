import 'package:printing/printing.dart';
import '../menu/data/menu_repository.dart';
import 'menu_pdf_renderer.dart';

class MenuExportService {
  MenuExportService(this.renderer);
  final MenuPdfRenderer renderer;
  Future<void> preview(MenuSnapshot snapshot) => Printing.layoutPdf(
    name: 'My Favourite Menu.pdf',
    onLayout: (_) => renderer.render(snapshot),
  );
  Future<void> share(MenuSnapshot snapshot) async => Printing.sharePdf(
    bytes: await renderer.render(snapshot),
    filename: 'my-favourite-menu.pdf',
  );
}
