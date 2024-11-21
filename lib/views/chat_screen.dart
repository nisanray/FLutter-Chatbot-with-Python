import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../models/chat_message.dart';
import '../controllers/chat_controller.dart';
import '../utils.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ChatController _chatController = ChatController();
  List<ChatMessage> _messages = [];
  bool _isSendButtonActive = false;
  bool _showWelcomeMessage = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isSendButtonActive = _controller.text.trim().isNotEmpty;
    });
  }

  Future<void> _sendMessage() async {
    String userMessage = _controller.text;
    _controller.clear();
    _focusInputBox();

    setState(() {
      _messages.add(ChatMessage(sender: "user", message: userMessage));
      _isSendButtonActive = false;
      _showWelcomeMessage = false;
    });

    try {
      ChatMessage botMessage = await _chatController.sendMessage(userMessage);
      setState(() {
        _messages.add(botMessage);
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(sender: "bot", message: "Unable to connect to the server. Please try again later."));
      });
    }

    _scrollToBottom();
  }

  void _focusInputBox() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chatbot",style: TextStyle(color: Colors.white),),centerTitle: true,backgroundColor: Colors.teal.shade400,),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    bool isUser = message.sender == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isUser)
                            Padding(
                              padding: const EdgeInsets.only(right: 3, left: 8),
                              child: Image.asset(chatBotLogo, width: 30, height: 30),
                            ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isUser ? Colors.blue[100] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                message.message,
                                style: TextStyle(
                                  color: isUser ? Colors.black : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            _sendMessage();
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: _isSendButtonActive ? Colors.blue : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        color: Colors.white,
                        onPressed: _isSendButtonActive
                            ? () {
                          if (_controller.text.trim().isNotEmpty) {
                            _sendMessage();
                          }
                        }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_showWelcomeMessage)
            Center(
              child: AnimatedOpacity(
                opacity: _showWelcomeMessage ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(chatBotLogo, width: 100, height: 100),
                    SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Hi there! 😊\n I’m here to help you. What can I assist you with today?',
                              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                              speed: Duration(milliseconds: 100),textAlign: TextAlign.center,
                            ),
                          ],
                          totalRepeatCount: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}