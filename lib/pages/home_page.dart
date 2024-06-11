// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

//  backgroundColor: const Color.fromARGB(255, 203, 156, 205),

import 'package:chat_app/api/apis.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<ChatUser> list = [];
  final List<ChatUser> searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: !_isSearching,
        onPopInvoked: (_) async {
          if (_isSearching) {
            setState(() => _isSearching = !_isSearching);
          } else {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 203, 156, 205),

          // Appbar
          appBar: AppBar(
            leading: const Icon(Icons.home_filled),
            title: _isSearching
                ? Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20.0),
                    child: TextFormField(
                      // onTapOutside: (PointerDownEvent) {
                      //   FocusScope.of(context).unfocus();
                      // },

                      onSaved: (val) => Apis.me.about = val ?? '',
                      validator: (val) {
                        if (val == null && val!.isEmpty) {
                        } else {
                          return null;
                        }
                        return null;
                      },

                      style: const TextStyle(color: Colors.white),

                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        // suffixIcon: IconButton(
                        //     onPressed: () {},
                        //     icon: const Icon(Icons.search,
                        //         size: 30, color: Colors.white)),
                        hintText: 'Name,Email ...',
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(115, 196, 183, 183)),
                      ),

                      //when search text changes it updates the search list
                      onChanged: (val) {
                        searchList.clear();

                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            searchList.add(i);
                          }
                          setState(() {
                            searchList;
                          });
                        }
                      },
                      // controller: ,
                    ),
                  )
                : const Text('C H A T  A P P'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (searchList.isNotEmpty) {
                      searchList.clear();
                    }
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  size: 32,
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                ),
                highlightColor: Colors.transparent,
              ),
              const SizedBox(
                width: 3,
              ),
              IconButton(
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(
                          user: Apis.me,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert_rounded))
            ],
          ),

          // floating actionbutton
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.purple[200],
            onPressed: () async {
              // ignore: unused_element

              await Apis.auth.signOut();
              await GoogleSignIn().signOut();
              log('SignOut Successfully!');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ));
            },
            child: Image(
              color: Colors.purple[600],
              height: 30,
              image: const AssetImage('lib/assets/images/adduser.png'),
            ),
          ),

          //  main body of the home page
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 209, 116, 212),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'lib/assets/images/wp-bg.png',
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: Apis.getAllusers(),
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
                        list = data
                                ?.map((e) => ChatUser.fromJson(e.data()))
                                .toList() ??
                            [];
                    }
                    if (list.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 5),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user: _isSearching
                                  ? searchList[index]
                                  : list[index]);
                          // return Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text('My Name is : ${list[index]}'),
                          // );
                        },
                        itemCount:
                            _isSearching ? searchList.length : list.length,
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
                                '        No Chats to show \nClick button to Start a Chat',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 48, 49, 48),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Image(
                                color: Color.fromARGB(255, 231, 222, 233),
                                height: 40,
                                image:
                                    AssetImage('lib/assets/images/adduser.png'),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
