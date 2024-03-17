// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final void Function()? onTap;
  const CommentButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.comment,
        color: Colors.grey,
      ),
    );
  }
}
