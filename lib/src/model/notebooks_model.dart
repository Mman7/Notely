import 'package:objectbox/objectbox.dart';

@Entity()
class Notebook {
  //TODO implement note book

  Notebook({this.id = 0});
  @Id()
  int id;
  String? title;
  List<String>? noteListid;
}
