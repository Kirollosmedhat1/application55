import 'package:flutter/material.dart';

class ChatPageWithBottomSheet extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final int memberCount;
  final String groupIconUrl;
  final String adminName;
  final String wallpaperrUrl;
  final String imag;

  const ChatPageWithBottomSheet({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    required this.memberCount,
    required this.groupIconUrl,
    required this.adminName,
    required this.wallpaperrUrl,
    required this.imag,
  }) : super(key: key);

  @override
  _ChatPageWithBottomSheetState createState() => _ChatPageWithBottomSheetState();
}

class _ChatPageWithBottomSheetState extends State<ChatPageWithBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Display the bottom sheet after the page is built
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: [
                const Text('This is the bottom sheet content'),
                ElevatedButton(
                  onPressed: () {
                    // Handle button tap inside the bottom sheet
                  },
                  child: const Text('Bottom Sheet Button'),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: const Column(
        children: [
          Expanded(
            child: Center(
              child: Text("Chat Content Goes Here"),
            ),
          ),
        ],
      ),
    );
  }
}
