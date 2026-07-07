import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class ReaderPage extends StatelessWidget {
  final String title;
  final String path;

  const ReaderPage({super.key, required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    final file = File(path);

    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: file.existsSync()
          ? PdfViewer.file(path)
          : const Center(child: Text('No se encontró el archivo pdf.')),
    );
  }
}
