import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  Note(
      {this.id = 0,
      this.uuid,
      this.previewContent,
      this.title,
      this.content,
      this.tag,
      this.isBookmark = false,
      this.dateCreated,
      this.includePic = false});
  @Id()
  //TODO implement tag,notebook system
  int id;
  String? uuid;
  String? previewContent;
  String? title;
  String? content;
  bool? isBookmark;
  bool? includePic;
  DateTime? dateCreated;

  /// these two
  String? tag;
  String? notebook;
  // var lastModified;

  static saveToDataBase({note}) {}

  static saveData() {}
}
