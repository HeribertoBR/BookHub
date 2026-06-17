import 'package:flutter/material.dart';
import '../../data/models/book.dart';
import '../../services/storage_services.dart';

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
    final books = await _storageServices.getBooks();

    setState(() {
      _books = books;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Biblioteca'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        ),
        body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if(_books.isEmpty) {
      return const Center(
        child: Text(
          'Aùn no has importado libros',
        ),
      );
    }

    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: (context, index){
        final book = _books[index];

        return ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: Text(book.title),
          subtitle: Text(book.path),
        );
      },
    );
  }



}