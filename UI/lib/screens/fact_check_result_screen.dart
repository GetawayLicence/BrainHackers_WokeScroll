import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FactCheckResultScreen extends StatelessWidget {
  final Map<String, dynamic> apiResponse;
  const FactCheckResultScreen({super.key, required this.apiResponse});

  @override
  Widget build(BuildContext context) {
    final String title = apiResponse['title'] ?? 'N/A';
    final String prediction = apiResponse['prediction'] ?? 'N/A';
    final double confidence = (apiResponse['confidence'] ?? 0.0) as double;

    final bool isReal = prediction.toLowerCase() == 'real';
    final Color predictionColor = isReal ? Colors.green : Colors.red;
    final Color purple = const Color(0xFF6A1B9A);
    final Color lightPurple = const Color(0xFFCE93D8);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [lightPurple, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Title
                Text(
                  'Results',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                ),
                const SizedBox(height: 30),

                // Title of the article
                Text(
                  "\"$title\"",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Result Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: purple.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Verdict',
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          prediction,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: predictionColor,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CircularPercentIndicator(
                          radius: 80.0,
                          lineWidth: 12.0,
                          animation: true,
                          percent: confidence.clamp(0.0, 1.0),
                          center: Text(
                            "${(confidence * 100).round()}%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: purple,
                            ),
                          ),
                          progressColor: predictionColor,
                          backgroundColor: Colors.grey.shade300,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Confidence Level',
                          style: TextStyle(fontSize: 16, color: purple),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
