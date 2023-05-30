import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;

  const MessagesScreen({Key key, this.messages}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment:
                  widget.messages[widget.messages.length - 1 - index]
                          ['isUserMessage']
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: widget.messages[widget.messages.length -
                                  1 -
                                  index]['isUserMessage']
                              ? Radius.circular(10)
                              : Radius.circular(10),
                          topRight: widget.messages[widget.messages.length -
                                  1 -
                                  index]['isUserMessage']
                              ? Radius.circular(10)
                              : Radius.circular(10),
                          bottomRight: widget.messages[widget.messages.length -
                                  1 -
                                  index]['isUserMessage']
                              ? Radius.circular(0)
                              : Radius.circular(10),
                          bottomLeft: widget.messages[widget.messages.length -
                                  1 -
                                  index]['isUserMessage']
                              ? Radius.circular(10)
                              : Radius.circular(0),
                        ),
                        color:
                            widget.messages[widget.messages.length - 1 - index]
                                    ['isUserMessage']
                                ? Color.fromARGB(255, 79, 187, 82)
                                : Color.fromARGB(255, 109, 108, 108)),
                    constraints: BoxConstraints(maxWidth: w * 2 / 3),
                    child: Text(
                        widget
                            .messages[widget.messages.length - 1 - index]
                                ['message']
                            .text
                            .text[0],
                        style: TextStyle(
                          fontSize: 20,
                          color: widget.messages[widget.messages.length - 1 - index]
                                    ['isUserMessage']
                          ?Colors.white
                          :Colors.white,
                          fontStyle: FontStyle.normal,
                        ))),
              ],
            ),
          );
        },
        separatorBuilder: (_, i) =>
            const Padding(padding: EdgeInsets.only(top: 10)),
        itemCount: widget.messages.length);
  }
}
