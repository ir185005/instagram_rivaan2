import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_rivaan/models/user_model.dart';
import 'package:instagram_rivaan/providers/user_pr.dart';
import 'package:instagram_rivaan/resources/firestore_methods.dart';
import 'package:instagram_rivaan/utils/colors.dart';
import 'package:instagram_rivaan/utils/constants.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController textController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  postComment() async {
    setState(() {
      isLoading = true;
    });
    String res = await FireStoreMethods().postComment(
      postId: widget.snap['postId'],
      text: textController.text,
      uid: widget.snap['uid'],
      name: widget.snap['userName'],
      profilePic: widget.snap['profImage'],
      context: context,
    );
    setState(() {
      isLoading = false;
      textController.clear();
    });
    if (res == 'success') {
      Utils().showSnackBar(context, 'Commented successfylly');
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return CommentCard(
                    snap: snapshot.data!.docs[index].data(),
                  );
                });
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userModel.photoUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 8.0,
                ),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Comment as ${userModel.userName}',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                postComment();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: isLoading == true
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Post',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
