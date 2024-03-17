import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tweet/pages/profile_page.dart';

import '../components/drawer.dart';
import '../components/text_field.dart';
import '../components/wall_post.dart';
import '../helper/helper_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  //current user
  final currentUser = FirebaseAuth.instance.currentUser;

  //postmessage

  void postMessage() {
    //only post message if theris sometingin the texfiled
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('UserPost').add({
        "UserEmail": currentUser!.email!,
        "Message": textController.text,
        "Timestamp": Timestamp.now(),
      });
    }

    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const ProfilePage();
    }));
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("The Social Medias"),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            // tha social
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('UserPost')
                    .orderBy('Timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return WallPost(
                            message: post['Message'],
                            user: post['UserEmail'],
                            postId: post.id,
                            // likes: List<String>.from(post['Likes']) ?? [],
                            likes: const [],
                            time: formatDate(post['Timestamp']),
                          );
                        });
                  } else if (snapshot.hasData) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),

            // post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Write something on the wall.....',
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
            //logged as
            Text(
              "Logged in as:${currentUser!.email}",
              style: const TextStyle(
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
