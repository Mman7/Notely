import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notely/myobjectbox.dart';
import 'package:notely/objectbox.g.dart';
import 'package:notely/src/model/folder_model.dart';
import 'package:notely/src/model/note_model.dart';
import 'package:notely/src/modules/socket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Database {
  static final noteBox = objectbox.store.box<Note>();
  static final folderBox = objectbox.store.box<FolderModel>();

  static void applyDatas(
      {required List<Note> notesFromRemote,
      required List<FolderModel> remoteFolders}) {
    debugPrint('Applying data to database..');
    List<Note> localNotes = getAllNote();
    List<FolderModel> localFolders = getAllFolder();
    Set localNoteSet = localNotes.map((n) => n.uuid).toSet();
    Set localFoldersSet = localFolders.map((n) => n.uuid).toSet();
    // apply notes
    for (Note i in notesFromRemote) {
      if (localNoteSet.contains(i.uuid)) {
        // Update notes
        // get note
        // local is x, remote is i
        Note note = localNotes.where((x) => x.uuid == i.uuid).first;
        // compare lastestModified
        bool isRemoteNewer = note.lastestModified.isBefore(i.lastestModified);
        if (isRemoteNewer) {
          note.title = i.title;
          note.content = i.content;
          note.previewContent = i.previewContent;
          note.lastestModified = i.lastestModified;
          note.dateCreated = i.dateCreated;
          noteBox.put(note, mode: PutMode.update);
        }
      } else {
        // Create a new one
        noteBox.put(i, mode: PutMode.insert);
      }
    }
    // apply folders
    for (FolderModel i in remoteFolders) {
      if (localFoldersSet.contains(i.uuid)) {
        // Update notes
        int id = localFolders.where((x) => x.uuid == i.uuid).first.id;
        i.id = id;
        folderBox.put(i, mode: PutMode.update);
      } else {
        // Create a new one
        folderBox.put(i, mode: PutMode.insert);
      }
    }
  }

  static List<Note?> filterNoteByFolder({required List<int>? ids}) {
    if (ids == null) return [];
    return noteBox.getMany(ids);
  }

  static getManyNote({required List<int> list}) {
    return noteBox.getMany(list);
  }

  static getAllNote() {
    final notes = noteBox.getAll();
    return notes;
  }

  static getAllFolder() {
    final noteBookList = objectbox.store.box<FolderModel>().getAll();
    return noteBookList;
  }

  //  CRUD Operations for Note
  static addNote({required Note note}) {
    noteBox.put(note);
    SocketClient.connect();
  }

  static getNote({required int id}) {
    return noteBox.get(id);
  }

  // Example: update an existing note by id
  static void updateNote({required Note note}) {
    noteBox.put(note, mode: PutMode.update);
    SocketClient.connect();
  }

  static removeNotesByUUIDs(List<String> ids) {
    List<Note> notes = getAllNote();
    List<int> notesToDelete = notes
        .where((n) => ids.contains(n.uuid))
        .toList()
        .map((e) => e.id)
        .toList();
    noteBox.removeMany(notesToDelete);
  }

  static deleteNote({required Note note}) async {
    noteBox.remove(note.id);
    addDeleteList(note: note);
    SocketClient.connect();
  }

  static addDeleteList({required Note note}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deleteList = prefs.getString('delete') ?? '[]';
    dynamic decodedList = jsonDecode(deleteList);
    decodedList.add(note.uuid);
    prefs.setString('delete', jsonEncode(decodedList));
  }

  /// Returns a list of UUIDs for notes that have been marked as deleted.
  static Future<List<String>> getDeletedNoteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getString('delete') ?? '[]';
    List<dynamic> decodedList = jsonDecode(list);
    return decodedList.whereType<String>().toList();
  }

  static clearDeletedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('delete');
  }

  //  CRUD Operations for Folder
  static addFolder({
    required name,
  }) {
    FolderModel notebook = FolderModel(
      uuid: Uuid().v4(),
      noteInclude: '',
      title: name,
    );
    folderBox.put(notebook);
    SocketClient.connect();
  }

  static getFolder({required int id}) {
    FolderModel? folder = folderBox.get(id);
    return folder;
  }

  static updateFolder({required FolderModel folder}) {
    folderBox.put(folder, mode: PutMode.update);
    SocketClient.connect();
  }

  static deleteFolder({required id}) {
    folderBox.remove(id);
    SocketClient.connect();
  }

  /// only for testing purpose
  static wipeAllData() {
    noteBox.removeAll();
    folderBox.removeAll();
  }
}
