// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_types_as_parameter_names, non_constant_identifier_names

import 'dart:developer';
import 'dart:io';

//  backgroundColor: const Color.fromARGB(255, 203, 156, 205),

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  ChatUser user;
  ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  void onTappOutside(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 83, 17, 85),

        // Appbar
        appBar: AppBar(
          title: const Text('Y O U R   P R O F I L E'),
        ),

        // floating actionbutton
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Log Out'),
          backgroundColor: Colors.pink[500],
          onPressed: () async {
            // ignore: unused_element
            Dialogs.showProgressBar(context);
            await Apis.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Navigator.pop(context);
              });
              log('SignOut Successfully!');
              Dialogs.showSnackBar(context, 'Logged Out Successfully!');
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) {
                return const LoginPage();
              }), (_) => false);
            });
          },
          icon: const Icon(Icons.logout_rounded),
        ),

        //  main body of the home page
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //why form because we need to do validation of entered values in out textformfield widget...
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 15),
                  child: Center(
                    child: Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.1),
                                child: Image.file(
                                  File(_image!),
                                  fit: BoxFit.cover,
                                  height: mq.height * .20,
                                  width: mq.height * .20,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.1),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  height: mq.height * .20,
                                  width: mq.height * .20,
                                  imageUrl: widget.user.image,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    backgroundColor: Colors.purple[300],
                                    child: const Icon(Icons.person),
                                  ),
                                ),
                              ),
                        Positioned(
                          right: -18,
                          bottom: 3,
                          child: MaterialButton(
                            elevation: 3,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.purple[700],
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: const GradientBoxBorder(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 26, 181, 253),
                          Color.fromARGB(255, 140, 212, 108)
                        ]),
                        width: 2,
                      ),
                      color: Colors.purple[300],
                      borderRadius: BorderRadius.circular(60)),
                  height: mq.height * .04,
                  width: mq.width * 0.8,
                  child: Center(
                    child: Text(
                      widget.user.email,
                      style: const TextStyle(
                          fontSize: 16,
                          wordSpacing: 2,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    // onTapOutside: (PointerDownEvent) {
                    //   FocusScope.of(context).unfocus();
                    // },
                    onSaved: (val) => Apis.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    style: const TextStyle(color: Colors.white),
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                        // hoverColor: const Color.fromARGB(255, 253, 191, 3),
                        // focusColor: const Color.fromARGB(255, 235, 178, 5),
                        hintText: 'eg. AdarshInDev',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(115, 196, 183, 183)),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'UserName',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),

                    // controller: ,
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    // onTapOutside: (PointerDownEvent) {
                    //   FocusScope.of(context).unfocus();
                    // },

                    onSaved: (val) => Apis.me.about = val ?? '',
                    validator: (val) {
                      if (val == null && val!.isEmpty) {
                        log('woriking..1');
                        return 'Required Field';
                      } else {
                        log('woriking..2');

                        return null;
                      }
                    },

                    maxLength: 50,

                    style: const TextStyle(color: Colors.white),
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                        hintText: 'eg. Hi I\'m Using the App',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(115, 196, 183, 183)),
                        prefixIcon: const Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        label: const Text('About',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),

                    // controller: ,
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.06,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Apis.updateUserInfo();
                      log('inside validator');
                    }
                  },
                  label: const Text('U P D A T E',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16, wordSpacing: 8)),
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(
                        Size(mq.height * 0.2, mq.height * 0.06)),
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.blueAccent.shade200),
                  ),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        enableDrag: true,
        sheetAnimationStyle:
            AnimationStyle(duration: const Duration(milliseconds: 550)),
        context: context,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * .28,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 67, 15, 77),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Text(
                      'Pick Profile Picture',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
// Pick an image.
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            log('image path: ${image.path}  --MimeType: ${image.mimeType}');
                            setState(() {
                              _image = image.path;
                            });
                          }
                          Apis.updateProfilePic(File(_image!));
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 198, 82, 174)),
                          fixedSize: WidgetStatePropertyAll(Size(100, 100)),
                        ),
                        child: Image.asset('lib/assets/images/images_add.png')),
                    const SizedBox(
                      width: 60,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
// Pick an image.
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);
                          if (image != null) {
                            log('image path: ${image.path} ');
                            setState(() {
                              _image = image.path;
                            });
                          }
                          Apis.updateProfilePic(File(_image!));
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 198, 82, 174)),
                          fixedSize: WidgetStatePropertyAll(Size(100, 100)),
                        ),
                        child: Image.asset('lib/assets/images/cam3d.png'))
                  ],
                ),
              ],
            ),
          );
        });
  }
}
