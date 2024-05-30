import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  Note(
      {this.id = 0,
      required this.uuid,
      required this.previewContent,
      required this.title,
      required this.content,
      this.category,
      this.isBookmark = false,
      required this.dateCreated,
      this.includePic = false});
  @Id()
  int id;
  String uuid;
  String previewContent;
  String title;
  String content;
  bool isBookmark;
  bool includePic;
  String? category;
  DateTime dateCreated;
  // var lastModified;

  static saveToDataBase({note}) {}

  static saveData() {}
}
