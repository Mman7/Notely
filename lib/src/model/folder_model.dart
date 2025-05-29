import 'package:objectbox/objectbox.dart';

//TODO create
@Entity()
class FolderModel {
  FolderModel({this.id = 0, required this.title, this.noteInclude});
  @Id()
  int id;
  String title;
  // List covert into string
  String? noteInclude;
}
