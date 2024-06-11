import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';
import 'package:syncnote/src/widget/custom_text_button.dart';

//*do this first TODO: implement function with sidebar
//TODO layout problem

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  MaterialStatesController statesController = MaterialStatesController();

  @override
  Widget build(BuildContext context) {
    var isExtended = context.watch<AppProvider>().isSidebarExtended;

    openIcon() {
      return isExtended
          ? Icons.keyboard_arrow_left_sharp
          : Icons.keyboard_arrow_right_sharp;
    }

    var appProvider = context.read<AppProvider>();

    return Container(
      width: double.infinity,
      decoration:
          const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow()]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextButton(
                  icon: Icons.search,
                  text: ' Search',
                  showText: isExtended,
                  onPressed: () {
                    appProvider.setSearchMode(value: true);
                  },
                ),
                CustomTextButton(
                  icon: Icons.add_circle_rounded,
                  text: ' New Note',
                  showText: isExtended,
                  onPressed: () {
                    appProvider.setSearchMode(value: false);
                  },
                ),
                CustomTextButton(
                  icon: Icons.book,
                  text: ' All Notes',
                  showText: isExtended,
                  onPressed: () {
                    appProvider.setSearchMode(value: false);
                    appProvider.setListMode(value: 'allnotes');
                  },
                ),
                CustomTextButton(
                  icon: Icons.star,
                  text: ' Bookmarks',
                  showText: isExtended,
                  onPressed: () {
                    appProvider.setListMode(value: 'bookmarks');
                  },
                ),
                //TODO: notesbooks menu with create notebooks button under it
                CustomTextButton(
                  icon: Icons.menu_book,
                  text: ' Notebooks',
                  showText: isExtended,
                  onPressed: () {
                    appProvider.setSearchMode(value: false);
                    appProvider.setListMode(value: 'notebooks');
                  },
                ),
                //TODO: tags menu with create tags button under it

                CustomTextButton(
                  icon: Icons.bookmark,
                  text: ' Tags',
                  showText: isExtended,
                  onPressed: () {
                    appProvider.setSearchMode(value: false);
                    appProvider.setListMode(value: 'tags');
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Material(
                child: InkWell(
                    onTap: () {
                      context.read<AppProvider>().changeSidebarExtended();
                    },
                    child: Icon(openIcon()))),
          )
        ],
      ),
    );
  }
}

// class SideBar extends StatelessWidget {
//   const SideBar({
//     super.key,
//     required this.sidebarXController,
//   });

//   final SidebarXController sidebarXController;

//   @override
//   Widget build(BuildContext context) {
//     final appProvider = context.read<AppProvider>();
//     return SidebarX(
//       controller: sidebarXController,
//       theme: SidebarXTheme(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: <Color>[hexToColor('0064C1'), hexToColor('002547')]),
//           // color: hexToColor('001E3B'),
//         ),
//         selectedItemDecoration: const BoxDecoration(
//             color: Colors.white10,
//             borderRadius: BorderRadius.all(Radius.circular(7))),
//         textStyle:
//             const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         iconTheme: const IconThemeData(color: Colors.white),
//         hoverTextStyle:
//             const TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
//         selectedTextStyle:
//             const TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
//         selectedIconTheme: const IconThemeData(
//           color: Colors.blue,
//         ),
//       ),
//       separatorBuilder: (context, index) {
//         return const Gap(10);
//       },
//       items: [
//         SidebarXItem(
//             label: ' Search',
//             icon: Icons.search,
//             onTap: () {
//               appProvider.setSearchMode(value: true);
//             }),
//             iconBuilder: (selected, hovered) {
//         SidebarXItem(
//               return const Icon(
//                 Icons.add_circle_rounded,
//                 color: Colors.orange,
//               );
//             },
//             label: ' New Note',
//             selectable: false,
//             onTap: () {
//               appProvider.setSearchMode(value: false);
//               appProvider.setNoteSelected(id: 0);
//             }),
//         SidebarXItem(
//             onTap: () {
//               appProvider.setSearchMode(value: false);
//             },
//             icon: Icons.book,
//             label: ' All Notes'),
//         SidebarXItem(
//             onTap: () {
//               appProvider.setSearchMode(value: false);
//               appProvider.setListMode(value: 'bookmarks');
//               appProvider.getSpData();
//             },
//             icon: Icons.star,
//             label: ' Bookmarks'),
//         SidebarXItem(
//             onTap: () {
//               appProvider.setSearchMode(value: false);
//               appProvider.setListMode(value: 'notebooks');
//             },
//             icon: Icons.menu_book,
//             label: ' Notebooks'),
//         SidebarXItem(
//             onTap: () {
//               appProvider.setSearchMode(value: false);
//               appProvider.setListMode(value: 'tags');
//             },
//             icon: Icons.bookmark,
//             label: ' Tags'),
//       ],
//     );
//   }
// }
