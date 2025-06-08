import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/modules/local_database.dart';

@Entity()
class FolderModel {
  FolderModel({this.id = 0, required this.title, this.noteInclude});
  @Id()
  int id;
  String title;
  // List covert into string
  String? noteInclude;

  List<int> getConvertNoteIncluded() {
    return List<int>.from(jsonDecode(noteInclude ?? '[]'));
  }

  /// Filter out [null]
  void refreshNoteIncluded() {
    Database database = Database();
    List result = database.getManyNote(list: getConvertNoteIncluded());
    List newList = [];
    for (Note? e in result) {
      if (e != null) newList.add(e.id);
    }
    String json = jsonEncode(newList);
    noteInclude = json;
    Database().updateFolder(folder: this);
  }
}
