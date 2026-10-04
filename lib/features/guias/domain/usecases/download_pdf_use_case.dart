import '../repositories/guias_repository.dart';

class DownloadPdfUseCase {
  final GuiasRepository repository;

  DownloadPdfUseCase(this.repository);

  Future<String> call({
    required String idGuia,
    required String numeroGuia,
  }) {
    return repository.downloadPdf(
      idGuia: idGuia,
      numeroGuia: numeroGuia,
    );
  }
}
