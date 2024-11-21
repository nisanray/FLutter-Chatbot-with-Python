import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class ChatController {
  final String apiUrl = "http://127.0.0.1:5000/chatbot"; // Replace with your backend URL

  Future<ChatMessage> sendMessage(String userMessage) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": userMessage}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String botResponse = data['response'] ?? "Sorry, I didn't understand that.";
      return ChatMessage(sender: "bot", message: botResponse);
    } else {
      return ChatMessage(sender: "bot", message: "Error: Failed to get response from server.");
    }
  }
}// TODO Implement this library.