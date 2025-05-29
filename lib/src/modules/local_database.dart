import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/objectbox.g.dart';
import 'package:syncnote/src/model/folder_model.dart';
import 'package:syncnote/src/model/note_model.dart';

class Database {
  final noteBox = objectbox.store.box<Note>();
  final noteBookBox = objectbox.store.box<FolderModel>();

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
    if (noteBookBox.getAll().isEmpty) return;
    var noteBookData = noteBookBox.get(id);

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
    noteBookBox.put(notebook);
  }

  removeNote({required id}) {
    noteBox.remove(id);
  }

  removeNoteBook({required id}) {
    noteBookBox.remove(id);
  }

  clearAll() {
    noteBox.removeAll();
    noteBookBox.removeAll();
  }
}
