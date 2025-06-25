import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fake_news_app/screens/saved_reports_screen.dart';

class PastSearchesScreen extends StatefulWidget {
  const PastSearchesScreen({super.key});

  @override
  State<PastSearchesScreen> createState() => _PastSearchesScreenState();
}

class _PastSearchesScreenState extends State<PastSearchesScreen> {
  String searchQuery = '';
  Set<String> selectedDocIds = {};

  void _toggleSelection(String docId) {
    setState(() {
      if (selectedDocIds.contains(docId)) {
        selectedDocIds.remove(docId);
      } else {
        selectedDocIds.add(docId);
      }
    });
  }

  void _deleteSelected() async {
    final batch = FirebaseFirestore.instance.batch();
    for (String id in selectedDocIds) {
      batch.delete(FirebaseFirestore.instance.collection('reports').doc(id));
    }
    await batch.commit();
    setState(() => selectedDocIds.clear());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Selected reports deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            selectedDocIds.isNotEmpty
                ? Text('${selectedDocIds.length} selected')
                : TextField(
                  onChanged: (val) => setState(() => searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search reports...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
        actions: [
          if (selectedDocIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteSelected,
            ),
        ],
        leading:
            selectedDocIds.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => selectedDocIds.clear()),
                )
                : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('reports')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No reports found."));
            }

            final reports =
                snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final summary =
                      (data['summary'] ?? '').toString().toLowerCase();
                  return summary.contains(searchQuery.toLowerCase());
                }).toList();

            if (reports.isEmpty) {
              return const Center(child: Text("No matching results."));
            }

            return ListView.separated(
              itemCount: reports.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final report = reports[index];
                final data = report.data() as Map<String, dynamic>;
                final docId = report.id;
                final timestamp = (data['timestamp'] as Timestamp).toDate();
                final formattedDate =
                    "${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}";
                final summary = (data['summary'] ?? '') as String;
                final preview =
                    summary.length > 25
                        ? '${summary.substring(0, 25)}...'
                        : summary;

                final bool isSelected = selectedDocIds.contains(docId);

                return ListTile(
                  selected: isSelected,
                  selectedTileColor: Colors.purple.shade100,
                  onLongPress: () => _toggleSelection(docId),
                  onTap: () {
                    if (selectedDocIds.isNotEmpty) {
                      _toggleSelection(docId);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ReportDetailScreen(
                                reportData: data,
                                docId: report.id,
                              ),
                        ),
                      );
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          preview,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8EFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Vibescore: ${data['vibe_score'].toStringAsFixed(1)}',
                            style: const TextStyle(
                              color: Color(0xFF9C6BFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
