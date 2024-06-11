import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for handling message text changes
  final _messageController = TextEditingController();
  List<Message> list0 = [];
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: Stack(
            children: [
              Container(
                width: mq.width,
                height: mq.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('lib/assets/images/wp-bg.png'))),
              ),
              StreamBuilder(
                stream: Apis.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;

                      list0 = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (list0.isNotEmpty) {
                        return ListView.builder(
                          itemCount: list0.length,
                          padding: const EdgeInsets.only(top: 5),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(
                              message: list0[index],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(130, 163, 59, 184),
                                borderRadius: BorderRadius.circular(20)),
                            width: mq.width * 0.65,
                            height: mq.height * 0.16,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '      No Chats to show \n    Go Ahead & Discuss \n What is on your mood 💬',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 48, 49, 48),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  }
                },
              ),
              Positioned(left: 9, bottom: 15, child: _chatInput()),
              Positioned(
                  right: mq.width * 0.02,
                  bottom: 17,
                  child: InkWell(
                    onTap: () {
                      if (_messageController.text.isNotEmpty) {
                        Apis.sendMessage(widget.user, _messageController.text);
                        _messageController.clear();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.purple[700],
                      radius: mq.height * 0.0303,
                      child: Center(
                        child: Image.asset(
                          // color: const Color.fromARGB(255, 154, 240, 157),
                          'lib/assets/images/send_button.png',
                          height: 36,
                        ),
                      ),
                    ),
                  )

                  // Container(
                  //   height: 57,
                  //   width: 57,
                  //   decoration: BoxDecoration(
                  //       image: const DecorationImage(
                  //           fit: BoxFit.contain,
                  //           image: AssetImage(
                  //             'lib/assets/images/send_button.png',
                  //           )),
                  //       color: Colors.purple[400],
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(50))),
                  // ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // child: CircleAvatar(
  //                 // backgroundColor: Colors.green[800],
  //                 radius: 28,
  //                 child: Image.asset(
  //                   // color: const Color.fromARGB(255, 154, 240, 157),
  //                   'lib/assets/images/send.png',
  //                   height: 90,
  //                 ),
  //               )

  Widget _appBar() {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4),
      child: Row(
        children: [
          const SizedBox(
            width: 7,
          ),
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Homepage()),
                    (_) => false);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              )),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.purple[200],
            radius: mq.height * 0.0265,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * 0.1),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                height: mq.height * .05,
                width: mq.height * .05,
                imageUrl: widget.user.image,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          SizedBox(width: mq.width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: mq.height * 0.0006,
              ),
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Last seen not Available",
                style: TextStyle(fontSize: 14, color: Colors.purple[100]),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                Apis.deleteChat();
                list0.clear();
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
                size: 35,
              )),
        ],
      ),
    );
  }

  Widget _chatInput() {
    final mq = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        color: Colors.purple[400],
      ),
      height: mq.height * 0.065,
      width: mq.width * 0.8,
      child: Row(
        children: [
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                height: 25,
                'lib/assets/images/happy-face.png',
              )),
          Expanded(
              child: TextField(
            controller: _messageController,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(color: Colors.purple[100], fontSize: 19),
            cursorColor: Colors.purple[200],
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Type a message...',
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide.none,
              ),
            ),
          )),
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                height: 25,
                'lib/assets/images/add_image.png',
                color: Colors.teal[200],
              )),
          IconButton(
              onPressed: () {},
              icon: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  height: 25,
                  'lib/assets/images/cam3d.png',
                ),
              )),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
