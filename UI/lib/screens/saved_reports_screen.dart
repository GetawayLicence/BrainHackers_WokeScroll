import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReportDetailScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;
  final String? docId;

  const ReportDetailScreen({
    super.key,
    required this.reportData,
    this.docId, // Firestore document ID (optional)
  });

  @override
  Widget build(BuildContext context) {
    final int vibeScore = (reportData['vibe_score'] as num?)?.round() ?? 0;
    final List<dynamic> toneList =
        reportData['tone'] is List ? reportData['tone'] : [];
    final dynamic manipulationData = reportData['manipulation_analysis'];
    final String summary = reportData['summary'] ?? 'No summary';
    final Timestamp? timestamp = reportData['timestamp'];
    final String formattedDate =
        timestamp != null
            ? "${timestamp.toDate().day.toString().padLeft(2, '0')}/"
                "${timestamp.toDate().month.toString().padLeft(2, '0')}/"
                "${timestamp.toDate().year}"
            : 'No Date';

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
                      Center(
                        child: Text(
                          'Saved Analysis',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: purple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // VibeScore
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

                      // Tone Chips
                      const Text(
                        'Emotional Analysis',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      toneList.isNotEmpty
                          ? Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                toneList
                                    .map<Widget>(
                                      (tone) => Chip(
                                        label: Text(tone.toString()),
                                        backgroundColor: const Color(
                                          0xFFEAE6FF,
                                        ),
                                        shape: const StadiumBorder(),
                                        labelStyle: const TextStyle(
                                          color: Color(0xFF9378FF),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          )
                          : const Text('No tone'),

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

                      // Manipulation Analysis
                      const Text(
                        'Manipulative Language',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      manipulationData is String
                          ? MarkdownBody(
                            data: manipulationData,
                            styleSheet: MarkdownStyleSheet.fromTheme(
                              Theme.of(context),
                            ).copyWith(
                              p: const TextStyle(fontSize: 14),
                              strong: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              listBullet: const TextStyle(
                                color: Color(0xFF9378FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : const Text('No analysis'),
                    ],
                  ),
                ),
              ),

              // Delete Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _deleteReport(context),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    "Delete Report",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 48),
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

  void _deleteReport(BuildContext context) async {
    if (docId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot delete: Missing document ID")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(docId)
          .delete();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete report: $e")));
    }
  }
}
