import 'package:album_frontend/models/photo_model.dart';

class AlbumModel {
  final String id;
  final String name;
  final List<PhotoModel> photos;
  final DateTime createdAt;
  final String coverColor; // رنگ کاور تا وقتی عکس واقعی نداریم

  AlbumModel({
    required this.id,
    required this.name,
    required this.photos,
    required this.createdAt,
    required this.coverColor,
  });

  String get lastPhotoUrl {
    if (photos.isNotEmpty) {
      return photos.last.url;
    }
    return '';
  }

  int get photoCount => photos.length;
}