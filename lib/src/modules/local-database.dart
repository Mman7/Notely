import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/objectbox.g.dart';
import 'package:syncnote/src/model/note_model.dart';
import 'package:syncnote/src/model/notebooks_model.dart';

class Database {
  final noteBox = objectbox.store.box<Note>();
  final noteBookBox = objectbox.store.box<Notebook>();

  getAllNote() {
    final notes = noteBox.getAll();
    return notes;
  }

  getAllNoteBook() {
    final noteBookList = objectbox.store.box<Notebook>().getAll();
    return noteBookList;
  }

  getSpecificNoteBook({required id}) {
    // prevent first launch value equals to null
    if (noteBookBox.getAll().isEmpty) return;
    String noteBooktitle = objectbox.store.box<Notebook>().get(id)!.title;
    final query =
        noteBox.query(Note_.notebook.containsElement(noteBooktitle)).build();
    final noteBookData = query.find();
    return noteBookData;
  }

  saveNote({required Note note}) {
    noteBox.put(note);
  }

  removeNote({id}) {
    noteBox.remove(id);
  }

  removeNoteBook({id}) {
    noteBookBox.remove(id);
  }
}
