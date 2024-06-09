import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final String audio;


      final String image;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.audio,
     required this.image,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      
      mainAxisAlignment: widget.sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        
        // Image.network(widget.image),
        widget.audio.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: widget.sentByMe ? 0 : 70,
                  right: widget.sentByMe ? 70 : 0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: widget.sentByMe ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.sender.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: widget.sentByMe ? Colors.white : Colors.green,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Implement audio playing functionality here
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: widget.sentByMe ? Colors.white : Colors.green,
                      ),
                    ),
                  ],
                ),
              )
            : Container(), // If there is no audio, don't display anything
       widget.image.isEmpty ? Container(
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: widget.sentByMe ? 230 : 20,
            right: widget.sentByMe ? 20 : 230,
          ),
          alignment:
              widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: widget.sentByMe
                ? const EdgeInsets.only(left: 30)
                : const EdgeInsets.only(right: 30),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.sentByMe ? Colors.green : Colors.white,
            ),
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: widget.sentByMe ? Colors.white : Colors.black,
              ),
            ),
          ),
        ):
        Container(
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: widget.sentByMe ? 230 : 20,
            right: widget.sentByMe ? 20 : 230,
          ),
          alignment:
              widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: widget.sentByMe
                ? const EdgeInsets.only(left: 30)
                : const EdgeInsets.only(right: 30),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.sentByMe ? Colors.green : Colors.white,
            ),
            child: Image.network(
              widget.image,
             
            ),
          ),
        )
      ],
    );
  }
}
