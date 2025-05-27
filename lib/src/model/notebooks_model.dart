import 'package:objectbox/objectbox.dart';

@Entity()
class Notebook {
  Notebook({this.id = 0, required this.title, this.description});
  @Id()
  int id;
  String title;
  String? description;
}
