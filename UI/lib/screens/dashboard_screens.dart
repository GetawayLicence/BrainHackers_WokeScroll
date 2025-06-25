import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:fake_news_app/screens/analyzing_post_screens.dart';
import 'package:fake_news_app/main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  final Color lavender = const Color(0xFFF8EFFF);
  final Color purple = const Color(0xFF9C6BFF);
  final Color background = const Color(0xFFF5F5F5);

  final TextEditingController captionController = TextEditingController();
  File? _imageFile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Reset image and text when returning from AnalyzingScreen
    setState(() {
      _imageFile = null;
      captionController.clear();
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final savedImage = await _saveImage(File(picked.path));
      setState(() {
        _imageFile = savedImage;
      });
      _extractTextFromImage(savedImage);
    }
  }

  Future<File> _saveImage(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final newPath = p.join(dir.path, p.basename(image.path));
    return image.copy(newPath);
  }

  Future<void> _extractTextFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);

    final extractedText = recognizedText.text.trim();

    if (extractedText.isNotEmpty) {
      captionController.text = extractedText;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalyzingScreen(inputText: extractedText),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't extract any text from image.")),
      );
    }

    await textRecognizer.close();
  }

  void _analyzeTextInput() {
    final userInput = captionController.text.trim();

    if (userInput.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter some text!')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalyzingScreen(inputText: userInput),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Analyse a Post',
          style: TextStyle(
            color: Color(0xFF99879D),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: lavender,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'Tap to upload image\n(Extracts caption text)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color: background),
                      child: Center(
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: lavender,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: captionController,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          hintText: 'Enter the post text to be analysed...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _analyzeTextInput,
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Analyse',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
