import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class FolderModel {
  FolderModel({this.id = 0, required this.title, this.noteInclude});
  @Id()
  int id;
  String title;
  // List covert into string
  String? noteInclude;
  List getConvertNoteInclude() {
    return jsonDecode(noteInclude ?? '[]');
  }
}
