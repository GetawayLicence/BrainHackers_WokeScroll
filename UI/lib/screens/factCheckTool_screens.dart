import 'package:flutter/material.dart';
import 'package:fake_news_app/screens/analyzing_news_screens.dart';

class FactCheckToolScreen extends StatelessWidget {
  final TextEditingController captionController = TextEditingController();
  FactCheckToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Fact-Check A Resource',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF99879D),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8EFFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: captionController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search an article title to get started!',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final userInput = captionController.text.trim();

                  if (userInput.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter some text!')),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AnalyzingScreen(inputText: userInput),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C6BFF),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Check Fact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
