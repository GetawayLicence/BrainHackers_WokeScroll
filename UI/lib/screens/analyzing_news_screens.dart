import 'package:flutter/material.dart';
import 'package:fake_news_app/services/fake_news_api_service.dart';
import 'fact_check_result_screen.dart';

class AnalyzingScreen extends StatefulWidget {
  final String inputText;

  const AnalyzingScreen({super.key, required this.inputText});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  @override
  void initState() {
    super.initState();
    print("🔍 initState called");
    _analyzeInput();
  }

  void _analyzeInput() async {
    try {
      final response = await fetchAnalysis(widget.inputText);
      print("API Response: $response");

      //Push to Emotional Analysis Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FactCheckResultScreen(apiResponse: response),
        ),
      );
    } catch (e) {
      print("Error: $e");
      // You can navigate to an error screen or show a dialog here
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF9378FF), // Match Figma purple
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Analyzing...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(color: Colors.white, strokeWidth: 6),
              SizedBox(height: 40),
              Text(
                'Hang tight!\nThis may take a few seconds...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
