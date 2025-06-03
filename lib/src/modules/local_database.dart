import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/objectbox.g.dart';
import 'package:syncnote/src/model/folder_model.dart';
import 'package:syncnote/src/model/note_model.dart';

class Database {
  final noteBox = objectbox.store.box<Note>();
  final folderBox = objectbox.store.box<FolderModel>();

  getNote({required int id}) {
    final note = noteBox.get(id);
    return note;
  }

  getAllNote() {
    final notes = noteBox.getAll();
    return notes;
  }

  getAllNoteBook() {
    final noteBookList = objectbox.store.box<FolderModel>().getAll();
    return noteBookList;
  }

  getSpecificNoteBook({required int id}) {
    // prevent first launch value equals to null
    if (folderBox.getAll().isEmpty) return;
    var noteBookData = folderBox.get(id);

    return noteBookData;
  }

  // Example: update an existing note by id
  void updateNote({required Note note}) {
    noteBox.put(note, mode: PutMode.update);
  }

  saveNote({required Note note}) {
    noteBox.put(note);
  }

  addNoteBook({
    required name,
  }) {
    FolderModel notebook = FolderModel(
      title: name,
    );
    folderBox.put(notebook);
  }

  removeNote({required id}) {
    noteBox.remove(id);
  }

  clearAll() {
    noteBox.removeAll();
    folderBox.removeAll();
  }

  getFolder({id}) {
    FolderModel? folder = folderBox.get(id);
    return folder;
  }

  updateFolder({required FolderModel folder}) {
    folderBox.put(folder, mode: PutMode.update);
  }

  removeFolder({required id}) {
    folderBox.remove(id);
  }

  List<Note>? filterNoteByFolder({required List<int>? ids}) {
    if (ids == null) return [];
    return noteBox.getMany(ids).whereType<Note>().toList();
  }
}
