import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PersonalMessages(),
    GroupMessages(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        color: Colors.indigo,
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}

class PersonalMessages extends StatelessWidget {
  final List<String> users = ['User 1', 'User 2', 'User 3'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Personal Messages',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://via.placeholder.com/60x60"),
                  ),
                  title: Text(
                    users[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Message preview...',
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DirectMessagesPage(username: users[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GroupMessages extends StatelessWidget {
  final List<String> groups = ['Group 1', 'Group 2', 'Group 3'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Group Messages',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://via.placeholder.com/60x60"),
                  ),
                  title: Text(
                    groups[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Message preview...',
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DirectMessagesPage(username: groups[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DirectMessagesPage extends StatefulWidget {
  final String username;

  const DirectMessagesPage({Key? key, required this.username})
      : super(key: key);

  @override
  _DirectMessagesPageState createState() => _DirectMessagesPageState();
}

class _DirectMessagesPageState extends State<DirectMessagesPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(_controller.text.trim());
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        color: Colors.indigo,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Start typing...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const BottomBar(
      {Key? key, required this.currentIndex, required this.onTabTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Group Chat',
        ),
      ],
    );
  }
}
