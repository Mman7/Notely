import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import 'package:notely/src/model/note_model.dart';
import 'package:notely/src/modules/local_database.dart';
import 'package:notely/objectbox.g.dart';

@Entity()
class FolderModel {
  FolderModel({
    this.id = 0,
    required this.title,
    required this.noteInclude,
    required this.uuid,
  });
  @Id()
  int id;
  @Unique()
  String uuid; // Unique identifier for the folder
  String title;
  // List covert into string
  String noteInclude;
  List<int> get getNoteIncluded => _getConvertNoteIncluded();

  List<int> _getConvertNoteIncluded() {
    try {
      // prevent nothing to parse
      if (noteInclude.length <= 2) return [];
      return List<int>.from(jsonDecode(noteInclude));
    } catch (err) {
      return [];
    }
  }

  addNote({required int noteId}) {
    List<int> newList = List.from(getNoteIncluded);
    if (newList.contains(noteId)) return; // Folder already included
    newList.add(noteId);
    noteInclude = jsonEncode(newList);
    Database.updateFolder(folder: this);
  }

  void removeNote({required int noteId}) {
    List<int> newList = getNoteIncluded;
    newList.remove(noteId);
    noteInclude = jsonEncode(newList);
    Database.updateFolder(folder: this);
  }

  /// Filter out [null]
  void checkNull() {
    if (getNoteIncluded.isEmpty || getNoteIncluded.first == 0) return;

    List newlist = [];
    final List<Note?> notes = Database.getManyNote(list: getNoteIncluded);
    for (Note? e in notes) {
      if (e != null) newlist.add(e.id);
    }
    if (newlist.length == notes.length) return;
    noteInclude = jsonEncode(newlist);
    Database.updateFolder(folder: this);
  }

  toJson() {
    return {
      'id': id,
      'title': title,
      'uuid': uuid,
      'noteInclude': noteInclude,
    };
  }
}
