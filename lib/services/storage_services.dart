import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/book.dart';

class StorageServices {
  static const String bookskey = 'books';
  Future<List<Book>> getBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(bookskey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded
        .map((item) => Book.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveBooks(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(books.map((book) => book.toJson()).toList());

    await prefs.setString(bookskey, jsonString);
  }

  Future<void> addBook(Book book) async {
    final books = await getBooks();
    books.add(book);
    await saveBooks(books);
  }

  Future<void> deleteBook(String id) async {
    final books = await getBooks();
    books.removeWhere((book) => book.id == id);
    await saveBooks(books);
  }

  Future<void> updateBook(Book updateBook) async {
    final books = await getBooks();
    final index = books.indexWhere((book) => book.id == updateBook.id);
    if (index == -1) return;
    books[index] = updateBook;

    await saveBooks(books);
  }

  Future<void> updateBookProgress({
    required String id,
    required int lastPage,
    required int totalPages,
  }) async {
    final books = await getBooks();
    final index = books.indexWhere((book) => book.id == id);
    if (index == -1) return;

    final book = books[index];
    books[index] = Book(
      id: book.id,
      title: book.title,
      path: book.path,
      lastPage: lastPage,
      totalPages: totalPages,
    );
    await saveBooks(books);
  }
}
