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
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
  return PhotoModel(
    id: json['name'] ?? '',
    url: 'assets/photos/placeholder.jpg', // server doesn't send image bytes
    title: json['name'] ?? '',
    caption: json['caption'],
    isFavorite: json['isLikedByTheOwner'] ?? false,
    dateAdded: DateTime.tryParse(json['timeOfAdd'] ?? '') ?? DateTime.now(),
    ownerName: json['ownerName'] ?? '',
    tags: List<String>.from(json['tags'] ?? []),
  );
}
  Map<String, dynamic> toJson() {
  return {
    'name': title,
    'caption': caption,
    'isLikedByTheOwner': isFavorite,
    'tags': tags,
  };
}
}
