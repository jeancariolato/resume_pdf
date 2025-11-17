import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'PDF Resume',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _summary;
  bool _loading = false;

Future<void> _pickAndSummarize() async {
  FilePickerResult? res = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    withData: true,          // ← obrigatório para trazer bytes
  );
  if (res == null) return;

  setState(() => _loading = true);

  final bytes = res.files.single.bytes!;          // ← Uint8List
  final name  = res.files.single.name;            // só para log

  // monta multipart usando bytes
  final req = http.MultipartRequest(
      'POST', Uri.parse('http://127.0.0.1:8000/resuma'));

  req.files.add(http.MultipartFile.fromBytes(
    'pdf',
    bytes,
    filename: name,
  ));

  final streamed = await req.send();
  final resp = await http.Response.fromStream(streamed);

  setState(() {
    _loading = false;
    if (resp.statusCode == 200) {
      _summary = (jsonDecode(resp.body) as Map)['summary'];
    } else {
      _summary = 'Erro ${resp.statusCode}';
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PDF Resumido'),
      ),
      
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_summary ?? 'Toque no botão'),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndSummarize,
        tooltip: 'Escolher PDF',
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
