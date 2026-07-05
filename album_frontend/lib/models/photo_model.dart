class PhotoModel {
  final String id;
  final String url;
  final String title;
  final String? caption;
  final bool isFavorite;
  final bool isImportant;
  final DateTime dateAdded;
  final String ownerName;
  final int likes;
  final List<String> tags;
  final List<Map<String, String>> comments;
  final bool isPublic;

  PhotoModel({
    required this.id,
    required this.url,
    required this.title,
    this.caption,
    this.isFavorite = false,
    this.isImportant = false,
    required this.dateAdded,
    this.ownerName = 'Admin',
    this.likes = 0,
    this.tags = const [],
    this.comments = const [],
    this.isPublic = true,
  });
}