import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/models/book.dart';
import '../../services/storage_services.dart';
import '../reader/reader_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        foregroundColor: _navy,
        elevation: 0,
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(Icons.auto_stories_rounded, color: _blue),
            SizedBox(width: 10),
            Text('BookHub', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
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
                      const Expanded(
                        child: Text(
                          'Tu biblioteca',
                          style: TextStyle(
                            color: _navy,
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
                          color: const Color(0xFFE2EDF5),
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

        return Card(
          margin: EdgeInsets.zero,
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE5EDF3)),
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
              style: const TextStyle(color: _navy, fontWeight: FontWeight.w600),
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Documento PDF · Toca para abrir',
                style: TextStyle(color: Color(0xFF63798B), fontSize: 12),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: _blue,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ReaderPage(title: book.title, path: book.path),
                ),
              );
            },
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
