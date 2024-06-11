import 'dart:developer';

import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.message.fromId
        ? userMessage()
        : senderMessage();
  }

  Widget userMessage() {
    if (widget.message.read.isNotEmpty) {
      Apis.updateMessageReadStatus(widget.message);
      log('message read updated');
    }

    final mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: mq.width * 0.04),
          child: Row(
            children: [
              /// to show read tick sign
              if (widget.message.read.isNotEmpty)
                const Icon(Icons.done_all_rounded,
                    color: Color.fromARGB(255, 13, 95, 210)),
              SizedBox(
                width: mq.width * 0.01,
              ),
              Text(
                  MyDateUtil.getFormattedTime(
                      context: context, time: widget.message.sent),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17)),
            ],
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * 0.04,
              vertical: mq.height * 0.01,
            ),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: const Color.fromARGB(255, 23, 135, 226),
                border: Border.all(
                    width: 2, color: const Color.fromARGB(255, 162, 35, 184))),
            child: Text(widget.message.msg,
                style: const TextStyle(
                    fontSize: 17, color: Color.fromARGB(230, 255, 255, 255))),
          ),
        ),
      ],
    );
  }

  Widget senderMessage() {
    final mq = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * 0.04,
              vertical: mq.height * 0.01,
            ),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Colors.purple[400],
                border: Border.all(
                    width: 2, color: const Color.fromARGB(255, 35, 238, 109))),
            child: Text(widget.message.msg,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Color.fromARGB(255, 255, 255, 255))),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 17)),
        ),
      ],
    );
  }
}
