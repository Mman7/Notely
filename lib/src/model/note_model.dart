import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  Note(
      {this.id = 0,
      required this.uuid,
      required this.previewContent,
      required this.title,
      required this.content,
      this.tag,
      this.isBookmark = false,
      required this.dateCreated,
      this.includePic = false});
  @Id()
  //TODO implement tag,notebook system
  int id;
  String uuid;
  String previewContent;
  String title;
  String content;
  bool isBookmark;
  bool includePic;

  /// these two
  String? tag;
  String? notebook;
  DateTime dateCreated;
  // var lastModified;

  static saveToDataBase({note}) {}

  static saveData() {}
}
