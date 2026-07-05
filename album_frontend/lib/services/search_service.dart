import 'package:album_frontend/models/photo_model.dart';

class SearchService {
  // سرچ بر اساس نام
  static List<PhotoModel> searchByName(String query, List<PhotoModel> photos) {
    return photos
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // سرچ بر اساس تگ
  static List<PhotoModel> searchByTag(String query, List<PhotoModel> photos) {
    return photos
        .where((p) => p.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  // سرچ بر اساس آلبوم (از طریق mock_data)
  static List<PhotoModel> searchByAlbum(String query, List<PhotoModel> photos, Map<String, List<String>> albumPhotos) {
    final matchedAlbums = albumPhotos.keys
        .where((album) => album.toLowerCase().contains(query.toLowerCase()))
        .toList();
    
    Set<String> photoIds = {};
    for (var album in matchedAlbums) {
      photoIds.addAll(albumPhotos[album] ?? []);
    }
    
    return photos.where((p) => photoIds.contains(p.id)).toList();
  }

  // سرچ بر اساس کامنت
  static List<PhotoModel> searchByComment(String query, List<PhotoModel> photos) {
    return photos
        .where((p) => p.comments.any((c) => c['text']!.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  // سرچ بر اساس تاریخ
  static List<PhotoModel> searchByDate(DateTime date, List<PhotoModel> photos) {
    return photos
        .where((p) => 
          p.dateAdded.year == date.year &&
          p.dateAdded.month == date.month &&
          p.dateAdded.day == date.day)
        .toList();
  }

  // سرچ همه (All)
  static List<PhotoModel> searchAll(String query, List<PhotoModel> photos, Map<String, List<String>> albumPhotos) {
    if (query.isEmpty) return photos;
    
    final results = <PhotoModel>{};
    results.addAll(searchByName(query, photos));
    results.addAll(searchByTag(query, photos));
    results.addAll(searchByAlbum(query, photos, albumPhotos));
    results.addAll(searchByComment(query, photos));
    
    return results.toList();
  }
}