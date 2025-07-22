import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

@Entity()
class Note {
  Note({
    this.id = 0,
    required this.uuid,
    required this.title,
    required this.content,
    required this.previewContent,
    this.isBookmark = false,
    this.dateCreated,
    this.lastestModified,
  });
  @Id()
  int id;
  @Unique()
  String uuid;
  String previewContent;
  String content;
  String title;
  bool? isBookmark;
  DateTime? dateCreated;
  DateTime? lastestModified;

  toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'title': title,
      'content': content,
      'isBookmark': isBookmark,
      'dateCreated': dateCreated?.toIso8601String(),
      'lastestModified': lastestModified?.toIso8601String(),
    };
  }

  factory Note.newNote() {
    return Note(
      uuid: Uuid().v4(),
      title: '',
      content: '',
      previewContent: '',
    );
  }
}
