import 'package:flutter/material.dart';
import 'package:melonote/myobjectbox.dart';
import 'package:melonote/objectbox.g.dart';
import 'package:melonote/src/model/folder_model.dart';
import 'package:melonote/src/model/note_model.dart';
import 'package:uuid/uuid.dart';

class Database {
  final noteBox = objectbox.store.box<Note>();
  final folderBox = objectbox.store.box<FolderModel>();

  void applyNotes(
      {required List<Note> notes, required List<FolderModel> folders}) {
    debugPrint('Applying data to database..');
    List<Note> localNotes = getAllNote();
    List<FolderModel> localFolders = getAllFolder();

    Set localNoteSet = localNotes.map((n) => n.uuid).toSet();
    Set localFoldersSet = localFolders.map((n) => n.uuid).toSet();

    // apply notes
    for (Note i in notes) {
      if (localNoteSet.contains(i.uuid)) {
        // Update notes
        int id = localNotes.where((x) => x.uuid == i.uuid).first.id;
        i.id = id;
        noteBox.put(i);
      } else {
        // Create a new one
        noteBox.put(i);
      }
    }
    // apply folders
    for (FolderModel i in folders) {
      if (localFoldersSet.contains(i.uuid)) {
        // Update notes
        int id = localFoldersSet.where((x) => x.uuid == i.uuid).first.id;
        i.id = id;
        folderBox.put(i, mode: PutMode.update);
      } else {
        // Create a new one
        folderBox.put(i, mode: PutMode.insert);
      }
    }
  }

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
      uuid: Uuid().v4(),
      noteInclude: '',
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

  List<Note?> filterNoteByFolder({required List<int>? ids}) {
    if (ids == null) return [];
    return noteBox.getMany(ids);
  }
}
