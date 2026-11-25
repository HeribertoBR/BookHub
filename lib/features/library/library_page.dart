import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/models/book.dart';
import '../../services/storage_services.dart';
import '../../services/theme_controller.dart';
import '../reader/reader_page.dart';

enum _BookAction { remove, deleteFile }

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  static const _navy = Color(0xFF0B3557);
  static const _blue = Color(0xFF0B4B78);
  static const _pageBackground = Color(0xFFF5F8FB);

  final StorageServices _storageServices = StorageServices();
  List<Book> _books = [];
  bool _isLoading = true;

  Future<bool> _confirmBookAction(Book book, bool deleteFile) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(deleteFile ? 'Eliminar PDF' : 'Quitar de la biblioteca'),
        content: Text(
          deleteFile
              ? '¿Deseas eliminar "${book.title}" de la biblioteca y del dispositivo?'
              : '¿Deseas quitar "${book.title}" de la biblioteca? El archivo no se borrará.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: deleteFile ? Colors.red : _blue,
            ),
            child: Text(deleteFile ? 'Eliminar' : 'Quitar'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _removeBook(Book book, {required bool deleteFile}) async {
    if (!await _confirmBookAction(book, deleteFile)) {
      return;
    }

    await _storageServices.deleteBook(book.id);

    var fileDeleted = true;
    if (deleteFile) {
      try {
        final file = File(book.path);
        if (await file.exists()) {
          await file.delete();
          fileDeleted = true;
        }
      } catch (_) {
        fileDeleted = false;
      }
    }

    if (!mounted) return;
    setState(() {
      _books.removeWhere((item) => item.id == book.id);
    });

    final message = deleteFile
        ? (fileDeleted
              ? 'PDF eliminado'
              : 'Se quitó de la biblioteca, pero el archivo no pudo eliminarse')
        : 'PDF quitado de la biblioteca';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });
    final books = await _storageServices.getBooks();

    if (!mounted) return;
    setState(() {
      _books = books;
      _isLoading = false;
    });
  }

  Future<void> _openBook(Book book) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReaderPage(book: book)),
    );
    await _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDark;
    final appBarColor = isDark ? const Color(0xFF101820) : _pageBackground;
    final foregroundColor = isDark ? const Color(0xFFEAF2F8) : _navy;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101820) : _pageBackground,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Icon(Icons.auto_stories_rounded, color: _blue),
            SizedBox(width: 10),
            Text('BookHub', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: ThemeController.instance,
            builder: (context, child) {
              return IconButton(
                tooltip: isDark
                    ? 'Cambiar a modo claro'
                    : 'Cambiar a modo oscuro',
                onPressed: ThemeController.instance.toggle,
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tu biblioteca',
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1D2A35)
                              : const Color(0xFFE2EDF5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_books.length} ${_books.length == 1 ? 'libro' : 'libros'}',
                          style: const TextStyle(
                            color: _blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Tus lecturas, siempre a mano.',
                    style: TextStyle(color: Color(0xFF63798B), fontSize: 15),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _importPdf,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Importar PDF'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _blue));
    }

    if (_books.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2EDF5),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 42,
                  color: _blue,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Empieza tu biblioteca',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Importa un archivo PDF para tener tus libros aquí y abrirlos cuando quieras.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF63798B),
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
      itemCount: _books.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final book = _books[index];
        final isDark = ThemeController.instance.isDark;

        return Card(
          margin: EdgeInsets.zero,
          color: isDark ? const Color(0xFF19232D) : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDark ? const Color(0xFF30414F) : const Color(0xFFE5EDF3),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2F8),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: _blue,
                size: 25,
              ),
            ),
            title: Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? const Color(0xFFEAF2F8) : _navy,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    book.totalPages > 0
                        ? '${book.readingProgressPercent}% leído · Página ${book.lastPage + 1} de ${book.totalPages}'
                        : 'Documento PDF · Toca para abrir',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFA9BAC7)
                          : const Color(0xFF63798B),
                      fontSize: 12,
                    ),
                  ),
                  if (book.totalPages > 0) ...[
                    const SizedBox(height: 7),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: book.readingProgress,
                        minHeight: 5,
                        backgroundColor: isDark
                            ? const Color(0xFF30414F)
                            : const Color(0xFFE2EDF5),
                        color: _blue,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing: SizedBox(
              width: book.lastPage > 0 ? 96 : 48,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (book.lastPage > 0)
                    IconButton(
                      tooltip: 'Retomar lectura',
                      onPressed: () => _openBook(book),
                      icon: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: _blue,
                      ),
                    ),
                  PopupMenuButton<_BookAction>(
                    icon: const Icon(Icons.more_vert_rounded, color: _blue),
                    tooltip: 'Opciones del PDF',
                    onSelected: (action) {
                      switch (action) {
                        case _BookAction.remove:
                          _removeBook(book, deleteFile: false);
                          break;
                        case _BookAction.deleteFile:
                          _removeBook(book, deleteFile: true);
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem<_BookAction>(
                        value: _BookAction.remove,
                        child: Row(
                          children: [
                            Icon(Icons.remove_circle_outline_rounded, size: 20),
                            SizedBox(width: 10),
                            Text('Quitar de la lista'),
                          ],
                        ),
                      ),
                      PopupMenuItem<_BookAction>(
                        value: _BookAction.deleteFile,
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Eliminar PDF',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () => _openBook(book),
          ),
        );
      },
    );
  }

  Future<void> _importPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) {
      return;
    }
    final file = result.files.first;
    if (file.path == null) {
      return;
    }
    final book = Book(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: file.name,
      path: file.path!,
    );

    await _storageServices.addBook(book);
    await _loadBooks();
  }
}
