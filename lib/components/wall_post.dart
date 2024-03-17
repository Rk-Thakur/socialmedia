import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tweet/components/comment.dart';

import '../helper/helper_methods.dart';
import 'comment_button.dart';
import 'delete_button.dart';
import 'like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user
  final currentuser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentuser.email);
  }

  //toggleLike
  void toogleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    //access the document is fIRebase

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('UserPost').doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentuser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentuser.email])
      });
    }
  }

  //add a comment

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection('UserPost')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      "CommentText": commentText,
      "CommentedBy": currentuser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  //show a dialog box for adding comment

  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add Comments"),
              content: TextField(
                controller: _commentTextController,
                decoration:
                    const InputDecoration(hintText: 'Write a comment...'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _commentTextController.clear();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    addComment(_commentTextController.text);

                    Navigator.pop(context);

                    _commentTextController.clear();
                  },
                  child: const Text("Post"),
                ),
              ],
            ));
  }

  //delete post
  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Post"),
              content: const Text("Are you sure you want to delete?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    //delete the comments from the firestore first
                    // if you only delte the post , the commets will be stored in firestore

                    final commentDoc = await FirebaseFirestore.instance
                        .collection('UserPost')
                        .doc(widget.postId)
                        .collection('Comments')
                        .get();

                    for (var doc in commentDoc.docs) {
                      await FirebaseFirestore.instance
                          .collection('UserPost')
                          .doc(widget.postId)
                          .collection('Comments')
                          .doc(doc.id)
                          .delete();

                      //then delete
                      FirebaseFirestore.instance
                          .collection('UserPost')
                          .doc(widget.postId)
                          .delete()
                          .then((value) => print('post deleted'))
                          .catchError((error) =>
                              print("Failed to delete post: $error "));

                      //dismiss the dialog
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Delete"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.message),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        " . ",
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              //delete butto
              if (widget.user == currentuser.email)
                DeleteButton(
                  onTap: deletePost,
                )
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //like
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toogleLike,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                width: 10,
              ),
              //Comment
              Column(
                children: [
                  //Comment button
                  CommentButton(
                    onTap: showCommentDialog,
                  ),

                  //likecounte
                  const SizedBox(
                    height: 5,
                  ),

                  const Text(
                    '0',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('UserPost')
                .doc(widget.postId)
                .collection('Comments')
                .orderBy('CommentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((e) {
                  final commentData = e.data() as Map<String, dynamic>;
                  return CommenText(
                    text: commentData['CommentText'],
                    user: commentData['CommentBy'],
                    time: formatDate(
                      commentData['CommentTime'],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
