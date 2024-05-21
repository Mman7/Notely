class Note {
  Note(
      {required this.uuid,
      required this.timeCreated,
      required this.category,
      required this.data,
      required this.isBookmark,
      required this.title,
      this.hadPreviewIMG});

  String uuid;
  String title;
  String data;
  bool isBookmark;
  var hadPreviewIMG;
  String category;
  DateTime timeCreated;
  var lastModified;

  saveToDataBase() {}

  static saveData() {}
}
