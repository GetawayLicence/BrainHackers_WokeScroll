import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmotionalAnalysisScreen extends StatelessWidget {
  final Map<String, dynamic> apiResponse;
  const EmotionalAnalysisScreen({super.key, required this.apiResponse});

  @override
  Widget build(BuildContext context) {
    final int vibeScore = apiResponse['vibe_score']?.round() ?? 0;
    final toneList = apiResponse['tone'] ?? [];
    final manipulationText = apiResponse['manipulation_analysis'] ?? 'No data';
    final summary = apiResponse['summary'] ?? 'No summary provided.';

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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Results title
                      Center(
                        child: Text(
                          'Results',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: purple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // VibeScore Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFF9378FF),
                              child: Text(
                                vibeScore.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'VibeScore: Based on tone and language used.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Emotional Breakdown
                      const Text(
                        'Emotional Analysis',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            toneList.map<Widget>((tone) {
                              return Chip(
                                label: Text(tone),
                                backgroundColor: const Color(0xFFEAE6FF),
                                shape: const StadiumBorder(),
                                labelStyle: const TextStyle(
                                  color: Color(0xFF9378FF),
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Summary
                      const Text(
                        'Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(summary, style: const TextStyle(fontSize: 14)),

                      const SizedBox(height: 24),

                      // Manipulative Language
                      const Text(
                        'Manipulative Language',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      MarkdownBody(
                        data: manipulationText,
                        styleSheet: MarkdownStyleSheet.fromTheme(
                          Theme.of(context),
                        ).copyWith(
                          p: const TextStyle(fontSize: 14),
                          strong: const TextStyle(fontWeight: FontWeight.bold),
                          listBullet: const TextStyle(
                            color: Color(0xFF9378FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _onSave(context),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Save Analysis',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave(BuildContext context) {
    saveReportToFirestore(apiResponse);
    print('Saving to database: $apiResponse');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Analysis saved!")));
  }

  void saveReportToFirestore(Map<String, dynamic> report) async {
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'vibe_score': report['vibe_score'],
        'tone': report['tone'],
        'summary': report['summary'],
        'manipulation_analysis': report['manipulation_analysis'],
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Failed to save report: $e');
    }
  }
}
