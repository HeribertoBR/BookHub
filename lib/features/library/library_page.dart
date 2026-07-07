import 'package:flutter/material.dart';
import '../../data/models/book.dart';
import '../../services/storage_services.dart';
import 'package:file_picker/file_picker.dart';
import '../reader/reader_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
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
      appBar: AppBar(title: const Text('Mi Biblioteca')),
      floatingActionButton: FloatingActionButton(
        onPressed: _importPdf,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_books.isEmpty) {
      return const Center(child: Text('Aùn no has importado libros'));
    }

    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];

        return ListTile(
          leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
          title: Text(book.title),
          subtitle: Text(book.path),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReaderPage(title: book.title, path: book.path),
              ),
            );
          },
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
