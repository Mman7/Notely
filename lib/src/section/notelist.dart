import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Column(
        children: [
          Text('Note List Section'),
        ],
      ),
    );
  }
}
