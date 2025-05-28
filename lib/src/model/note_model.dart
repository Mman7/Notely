import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  Note({
    this.id = 0,
    required this.uuid,
    required this.title,
    required this.content,
    required this.previewContent,
    this.notebook,
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
  List<String>? notebook;
  DateTime? lastestModified;
}
