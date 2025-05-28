import 'package:objectbox/objectbox.dart';

//TODO create
@Entity()
class Notebook {
  Notebook({
    this.id = 0,
    required this.title,
  });
  @Id()
  int id;
  String title;
}
