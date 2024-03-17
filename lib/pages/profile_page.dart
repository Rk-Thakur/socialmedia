import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //curretn user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //all users
  final userCollection = FirebaseFirestore.instance.collection('Users');

  //edit field
  Future<void> editField(String name) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            "Edit $name",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Enter new $name',
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            //cancel button
            TextButton(
              onPressed: () {
                return Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            //save button
            TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (newValue.trim().isNotEmpty) {
      //update value
      await userCollection.doc(currentUser.email).update({name: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Profile Page"),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                //profilepic
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.person,
                  size: 72,
                ),

                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My Details",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                //username
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'UserName',
                  onPresed: () => editField('name'),
                ),

                //bio
                MyTextBox(
                  text: userData['bio'],
                  sectionName: 'Bio',
                  onPresed: () => editField('name'),
                ),

                const SizedBox(
                  height: 50,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My Post",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error${snapshot.error}"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
