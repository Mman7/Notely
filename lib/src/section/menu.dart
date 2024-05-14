import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncnote/src/widget/menu_button.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: Colors.blue,
      child: Column(
        children: [
          Container(
            color: Colors.green,
            child: const TextField(
                decoration: InputDecoration.collapsed(
                    hintText: 'Search', fillColor: Colors.black)),
          ),
          const Gap(10),
          MenuButton(onPress: () {}, icon: const Icon(Icons.search), label: 'ddd'),
          MenuButton(onPress: () {}, icon: const Icon(Icons.add), label: 'New Note'),
          const Gap(10),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.orange,
              child: Column(
                children: [
                  MenuButton(
                      onPress: () {},
                      icon: const Icon(Icons.star),
                      label: 'Bookmark'),
                  MenuButton(
                      onPress: () {},
                      icon: const Icon(Icons.book),
                      label: 'NoteBook'),
                  MenuButton(
                      onPress: () {},
                      icon: const Icon(Icons.bookmark),
                      label: 'Tags'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
