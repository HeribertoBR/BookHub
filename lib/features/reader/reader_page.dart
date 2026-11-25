import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_flip_view/pdf.dart';

import '../../data/models/book.dart';
import '../../services/storage_services.dart';

class ReaderPage extends StatefulWidget {
  final Book book;

  const ReaderPage({super.key, required this.book});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  static const _navy = Color(0xFF0B3557);
  static const _blue = Color(0xFF0B4B78);
  static const _background = Color(0xFFF3F7FA);

  late final PageFlipController _pageController;
  final StorageServices _storageServices = StorageServices();
  int _currentPage = 0;
  int _pageCount = 0;
  bool _hasLoadError = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.book.lastPage;
    _pageController = PageFlipController(initialPage: widget.book.lastPage);
  }

  @override
  void dispose() {
    _saveProgress();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _saveProgress() async {
    await _storageServices.updateBookProgress(
      id: widget.book.id,
      lastPage: _currentPage,
      totalPages: _pageCount > 0 ? _pageCount : widget.book.totalPages,
    );
  }

  String _pageStatus(bool fileExists) {
    if (!fileExists) return 'Archivo no disponible';
    if (_hasLoadError) return 'No se pudo abrir';
    if (_pageCount == 0) return 'Preparando libro...';
    final percent = widget.book.progressAtPage(
      _currentPage,
      pageCount: _pageCount,
    );
    return 'Página ${_currentPage + 1} de $_pageCount · ${(percent * 100).round()}%';
  }

  @override
  Widget build(BuildContext context) {
    final fileExists = File(widget.book.path).existsSync();

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text(
          widget.book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE4ECF2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x180B3557),
                      blurRadius: 18,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: fileExists
                    ? PdfFlipBook.file(
                        widget.book.path,
                        controller: _pageController,
                        onLoaded: (pageCount) {
                          if (!mounted) return;
                          final savedPage = pageCount == 0
                              ? 0
                              : widget.book.lastPage.clamp(0, pageCount - 1);
                          setState(() {
                            _pageCount = pageCount;
                            _currentPage = savedPage;
                          });
                          if (_pageController.page != savedPage) {
                            _pageController.jumpTo(savedPage);
                          }
                          _saveProgress();
                        },
                        onPageChanged: (page) {
                          if (!mounted) return;
                          setState(() => _currentPage = page);
                          _saveProgress();
                        },
                        paperColor: Colors.white,
                        enableZoom: true,
                        enableTapToFlip: true,
                        errorBuilder: (context, error, retry) {
                          if (!_hasLoadError) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted || _hasLoadError) return;
                              setState(() => _hasLoadError = true);
                            });
                          }
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.picture_as_pdf_outlined,
                                    color: _blue,
                                    size: 44,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'No se pudo abrir este PDF.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _navy,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  FilledButton.icon(
                                    onPressed: () {
                                      setState(() => _hasLoadError = false);
                                      retry();
                                    },
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: const Text('Intentar de nuevo'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: _blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, progress) => const Center(
                          child: CircularProgressIndicator(color: _blue),
                        ),
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'No se encontró el archivo PDF.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _navy, fontSize: 16),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    tooltip: 'Página anterior',
                    onPressed: fileExists && _currentPage > 0
                        ? _pageController.previous
                        : null,
                    style: IconButton.styleFrom(
                      backgroundColor: _navy,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFDCE5EC),
                      disabledForegroundColor: const Color(0xFF8293A0),
                    ),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFDCE6ED)),
                    ),
                    child: Text(
                      _pageStatus(fileExists),
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'Página siguiente',
                    onPressed:
                        fileExists &&
                            _pageCount > 0 &&
                            _currentPage < _pageCount - 1
                        ? _pageController.next
                        : null,
                    style: IconButton.styleFrom(
                      backgroundColor: _navy,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFDCE5EC),
                      disabledForegroundColor: const Color(0xFF8293A0),
                    ),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
