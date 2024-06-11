import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 104, 49, 113)));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
          child: Card(
            shadowColor: Colors.purple[600],
            elevation: 5,
            color: Colors.purple[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(user: widget.user)));
              },
              //users profile image
              // leading: const CircleAvatar(
              //   child: Icon(Icons.person),
              // ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.1),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  height: mq.height * .055,
                  width: mq.height * .055,
                  imageUrl: widget.user.image,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              //users UserName
              title: Text(widget.user.name),
              //Last Message  Sended by the user
              subtitle: Text(
                widget.user.about,
                maxLines: 1,
                style: const TextStyle(
                  color: Color.fromARGB(255, 95, 88, 88),
                ),
              ),
              // When User Last Texted
              trailing: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    color: Colors.greenAccent.shade700,
                    borderRadius: BorderRadius.circular(10)),
              ),
              //  trailing: Text(
              //   widget.user.lastActive.toString(),
              //   style: const TextStyle(
              //       fontSize: 14, color: Color.fromARGB(255, 95, 88, 88)),
              // ),
            ),
          ),
        ));
  }
}
