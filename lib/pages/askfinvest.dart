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
    });

    final response = await chat.sendMessage(Content.text(message));
    final botReply = response.text ?? "Error: Unable to fetch response.";

    setState(() {
      messages.add({"role": "bot", "text": botReply});
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
            Text(
              "Ask Finvest",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 130,
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.notifications,
                color: Color(0xFF90EE90),
                size: 30,
              ),
            )
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFF90EE90),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(msg["text"]!,
                      textAlign: msg["role"] == "user"
                          ? TextAlign.end
                          : TextAlign.start,
                      style: TextStyle(
                          color: msg["role"] == "user"
                              ? Colors.white
                              : Colors.white),),
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
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Color(0xFF90EE90),
                  ),
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