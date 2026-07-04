class PhotoModel {
  final String id;
  final String url;
  final String title;
  final String? caption;
  final bool isFavorite;
  final bool isImportant;
  final DateTime dateAdded;

  PhotoModel({
    required this.id,
    required this.url,
    required this.title,
    this.caption,
    this.isFavorite = false,
    this.isImportant = false,
    required this.dateAdded,
  });
}