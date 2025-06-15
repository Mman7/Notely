import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:syncnote/src/modules/local_database.dart';
import 'package:uuid/uuid.dart';

@Entity()
class Note {
  Note({
    this.id = 0,
    required this.uuid,
    required this.title,
    required this.content,
    required this.previewContent,
    this.folder,
    this.isBookmark = false,
    this.dateCreated,
    this.lastestModified,
  });
  @Id()
  int id;
  String uuid;
  String previewContent;
  String content;
  String title;
  bool? isBookmark;
  DateTime? dateCreated;
  String? folder;
  DateTime? lastestModified;
  List get getFolderList => _getFolderIncluded();
  List<int> _getFolderIncluded() {
    return List<int>.from(jsonDecode(folder ?? '[]'));
  }

  addFolder({required int folderId}) {
    List newList = List.from(getFolderList);
    if (newList.contains(folderId)) {
      return; // Folder already included
    }
    newList.add(folderId);
    folder = jsonEncode(newList);
    Database().updateNote(note: this);
  }

  removeFolder({required int folderId}) {
    List<int> folderList = _getFolderIncluded();
    folderList.remove(folderId);
    folder = jsonEncode(folderList);
    Database().updateNote(note: this);
  }

  factory Note.newNote() {
    return Note(
      uuid: Uuid().v4(),
      title: '',
      content: '',
      previewContent: '',
    );
  }
}
