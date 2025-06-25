import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>> fetchAnalysis(String text) async {
  print("📡 Calling backend...");
  final url = Uri.parse(
    dotenv.env['ANALYZE_URL']!,
  ); // replace with your IP if needed
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": text}),
  );

  print("📬 Received response with status ${response.statusCode}");

  if (response.statusCode == 200) {
    print("✅ Response OK");
    return jsonDecode(response.body);
  } else {
    print("❌ Response failed: ${response.body}");
    throw Exception("Failed to analyze post: ${response.body}");
  }
}
