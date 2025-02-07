import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AskFinvestChatbot extends StatefulWidget {
  const AskFinvestChatbot({super.key});

  @override
  _AskFinvestChatbotState createState() => _AskFinvestChatbotState();
}

class _AskFinvestChatbotState extends State<AskFinvestChatbot> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isTyping = false; // Show typing animation
  final String apiKey = "AIzaSyCUpreI1-VfkjDvncU8Gp4mMIFKveHLn68";
  late final GenerativeModel model;
  late final ChatSession chat;

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );
    chat = model.startChat(history: []);
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      messages.add({"role": "user", "text": message});
      isTyping = true; // Show typing animation
    });

    final response = await chat.sendMessage(Content.text(message));
    String botReply = response.text ?? "Error: Unable to fetch response.";

    // Remove unwanted characters like '' from AI response
    botReply = botReply.replaceAll('*', '').trim();

    setState(() {
      messages.add({"role": "bot", "text": botReply});
      isTyping = false; // Hide typing animation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Text("Ask Finvest", style: TextStyle(color: Colors.white)),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            IconButton(
              onPressed: () {},
              icon:
                  Icon(Icons.notifications, color: Color(0xFF90EE90), size: 30),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Color(0xFF90EE90)),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length +
                  (isTyping ? 1 : 0), // Extra item for typing animation
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Typing...",
                        style: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                }
                final msg = messages[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    color: msg["role"] == "user"
                        ? Color(0xFF90EE90)
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: msg["role"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    msg["text"]!,
                    style: TextStyle(
                      color:
                          msg["role"] == "user" ? Colors.black : Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Ask Finvest...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF90EE90)),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}