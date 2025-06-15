import 'package:syncnote/myobjectbox.dart';
import 'package:syncnote/objectbox.g.dart';
import 'package:syncnote/src/model/folder_model.dart';
import 'package:syncnote/src/model/note_model.dart';

class Database {
  final noteBox = objectbox.store.box<Note>();
  final folderBox = objectbox.store.box<FolderModel>();

  /// only for testing purpose
  wipeAllData() {
    noteBox.removeAll();
    folderBox.removeAll();
  }

  getNote({required int id}) {
    final note = noteBox.get(id);
    return note;
  }

  getAllNote() {
    final notes = noteBox.getAll();
    return notes;
  }

  getAllFolder() {
    final noteBookList = objectbox.store.box<FolderModel>().getAll();
    return noteBookList;
  }

  // Example: update an existing note by id
  void updateNote({required Note note}) {
    noteBox.put(note, mode: PutMode.update);
  }

  saveNote({required Note note}) {
    noteBox.put(note);
  }

  addFolder({
    required name,
  }) {
    FolderModel notebook = FolderModel(
      title: name,
    );
    folderBox.put(notebook);
  }

  deleteNote({required id}) {
    noteBox.remove(id);
  }

  getManyNote({required List<int> list}) {
    return noteBox.getMany(list);
  }

  clearAll() {
    noteBox.removeAll();
    folderBox.removeAll();
  }

  getFolder({required int id}) {
    FolderModel? folder = folderBox.get(id);
    return folder;
  }

  updateFolder({required FolderModel folder}) {
    folderBox.put(folder, mode: PutMode.update);
  }

  deleteFolder({required id}) {
    folderBox.remove(id);
  }

  List<Note>? filterNoteByFolder({required List<int>? ids}) {
    if (ids == null) return [];
    return noteBox.getMany(ids).whereType<Note>().toList();
  }
}
