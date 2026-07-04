import 'package:album_frontend/models/photo_model.dart';
import 'package:album_frontend/models/album_model.dart';
class MockData {
  static List<PhotoModel> getPhotos() {
    return [
      // Today - July 4, 2026
      PhotoModel(
        id: '1',
        url: 'assets/photos/photo_1.jpg',
        title: 'Sunset Vibes',
        caption: 'Golden hour magic',
        isImportant: true,
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 4),
      ),
      PhotoModel(
        id: '2',
        url: 'assets/photos/photo_2.jpg',
        title: 'City Lights',
        caption: 'Night photography',
        isFavorite: false,
        dateAdded: DateTime(2026, 7, 4),
      ),
      PhotoModel(
        id: '3',
        url: 'assets/photos/photo_3.jpg',
        title: 'Morning Coffee',
        caption: 'Start of the day',
        isImportant: true,
        dateAdded: DateTime(2026, 7, 4),
      ),
      PhotoModel(
        id: '4',
        url: 'assets/photos/photo_4.jpg',
        title: 'Office Desk',
        caption: 'Work setup',
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 4),
      ),
      PhotoModel(
        id: '5',
        url: 'assets/photos/photo_5.jpg',
        title: 'Lunch Break',
        caption: 'Quick bite',
        dateAdded: DateTime(2026, 7, 4),
      ),
      // Yesterday - July 3, 2026
      PhotoModel(
        id: '6',
        url: 'assets/photos/photo_6.jpg',
        title: 'Park Walk',
        caption: 'Nature therapy',
        isImportant: true,
        dateAdded: DateTime(2026, 7, 3),
      ),
      PhotoModel(
        id: '7',
        url: 'assets/photos/photo_7.jpg',
        title: 'Gym Session',
        caption: 'Workout time',
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 3),
      ),
      PhotoModel(
        id: '8',
        url: 'assets/photos/photo_8.jpg',
        title: 'Evening Sky',
        caption: 'Beautiful colors',
        dateAdded: DateTime(2026, 7, 3),
      ),
      PhotoModel(
        id: '9',
        url: 'assets/photos/photo_9.jpg',
        title: 'Dinner Time',
        caption: 'Homemade pasta',
        isImportant: true,
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 3),
      ),
      // July 2, 2026
      PhotoModel(
        id: '10',
        url: 'assets/photos/photo_10.jpg',
        title: 'Beach Day',
        caption: 'Summer fun',
        dateAdded: DateTime(2026, 7, 2),
      ),
      PhotoModel(
        id: '11',
        url: 'assets/photos/photo_11.jpg',
        title: 'Sunset Sail',
        caption: 'Boat ride',
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 2),
      ),
      PhotoModel(
        id: '12',
        url: 'assets/photos/photo_12.jpg',
        title: 'Campfire',
        caption: 'Night stories',
        isImportant: true,
        dateAdded: DateTime(2026, 7, 2),
      ),
      // July 1, 2026
      PhotoModel(
        id: '13',
        url: 'assets/photos/photo_13.jpg',
        title: 'Mountain Hike',
        caption: 'Adventure time',
        isImportant: true,
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 1),
      ),
      PhotoModel(
        id: '14',
        url: 'assets/photos/photo_14.jpg',
        title: 'Waterfall',
        caption: 'Nature beauty',
        dateAdded: DateTime(2026, 7, 1),
      ),
      PhotoModel(
        id: '15',
        url: 'assets/photos/photo_15.jpg',
        title: 'Picnic',
        caption: 'Family time',
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 1),
      ),
      PhotoModel(
        id: '16',
        url: 'assets/photos/photo_16.jpg',
        title: 'Stargazing',
        caption: 'Milky way',
        isImportant: true,
        dateAdded: DateTime(2026, 7, 1),
      ),
      // June 28, 2026
      PhotoModel(
        id: '17',
        url: 'assets/photos/photo_1.jpg',
        title: 'Concert Night',
        caption: 'Live music',
        isFavorite: true,
        dateAdded: DateTime(2026, 6, 28),
      ),
      PhotoModel(
        id: '18',
        url: 'assets/photos/photo_2.jpg',
        title: 'BBQ Party',
        caption: 'Weekend fun',
        isImportant: true,
        dateAdded: DateTime(2026, 6, 28),
      ),
      // June 15, 2025 (سال قبل)
      PhotoModel(
        id: '19',
        url: 'assets/photos/photo_3.jpg',
        title: 'Graduation Day',
        caption: 'Finally done!',
        isImportant: true,
        isFavorite: true,
        dateAdded: DateTime(2025, 6, 15),
      ),
      PhotoModel(
        id: '20',
        url: 'assets/photos/photo_4.jpg',
        title: 'Family Dinner',
        caption: 'Quality time',
        dateAdded: DateTime(2025, 6, 15),
      ),
    ];
  }

  // گروه‌بندی بر اساس تاریخ
  static Map<String, List<PhotoModel>> groupByDate(List<PhotoModel> photos) {
    Map<String, List<PhotoModel>> grouped = {};

    for (var photo in photos) {
      String key = _getDateLabel(photo.dateAdded);
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(photo);
    }

    return grouped;
  }

  static String _getDateLabel(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime photoDate = DateTime(date.year, date.month, date.day);

    if (photoDate == today) {
      return 'Today';
    } else if (photoDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (date.year == now.year) {
      // امسال: ماه به حروف انگلیسی، روز به عدد
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.day}';
    } else {
      // سال‌های قبل: ماه به حروف انگلیسی، روز و سال به عدد
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  static List<AlbumModel> getAlbums() {
    final allPhotos = getPhotos();

    return [
      AlbumModel(
        id: '1',
        name: 'Nature',
        photos: allPhotos
            .where(
              (p) => [
                'Sunset Vibes',
                'Mountain Hike',
                'Waterfall',
                'Park Walk',
              ].contains(p.title),
            )
            .toList(),
        createdAt: DateTime(2026, 6, 15),
        coverColor: 'green',
      ),
      AlbumModel(
        id: '2',
        name: 'Travel',
        photos: allPhotos
            .where(
              (p) => [
                'Beach Day',
                'Sunset Sail',
                'Campfire',
                'Stargazing',
              ].contains(p.title),
            )
            .toList(),
        createdAt: DateTime(2026, 6, 20),
        coverColor: 'blue',
      ),
      AlbumModel(
        id: '3',
        name: 'Work',
        photos: allPhotos
            .where(
              (p) => [
                'Office Desk',
                'Morning Coffee',
                'Lunch Break',
              ].contains(p.title),
            )
            .toList(),
        createdAt: DateTime(2026, 7, 1),
        coverColor: 'purple',
      ),
      AlbumModel(
        id: '4',
        name: 'Family',
        photos: allPhotos
            .where(
              (p) => [
                'Family Dinner',
                'Picnic',
                'BBQ Party',
                'Graduation Day',
              ].contains(p.title),
            )
            .toList(),
        createdAt: DateTime(2026, 7, 2),
        coverColor: 'orange',
      ),
      AlbumModel(
        id: '5',
        name: 'Food',
        photos: allPhotos
            .where(
              (p) => [
                'Dinner Time',
                'Lunch Break',
                'BBQ Party',
                'Morning Coffee',
              ].contains(p.title),
            )
            .toList(),
        createdAt: DateTime(2026, 7, 3),
        coverColor: 'pink',
      ),
      AlbumModel(
        id: '6',
        name: 'City',
        photos: allPhotos
            .where(
              (p) => [
                'City Lights',
                'Concert Night',
                'Evening Sky',
              ].contains(p.title),
            )
            .toList(),
        createdAt: DateTime(2026, 7, 4),
        coverColor: 'cyan',
      ),
      AlbumModel(
        id: '7',
        name: 'Fitness',
        photos: allPhotos
            .where(
              (p) => [
                'Gym Session',
                'Mountain Hike',
                'Park Walk',
              ].contains(p.title),
            )
            .toList(),
        createdAt: DateTime(2026, 7, 4),
        coverColor: 'red',
      ),
      AlbumModel(
        id: '8',
        name: 'Memories',
        photos: allPhotos
            .where(
              (p) => [
                'Graduation Day',
                'Concert Night',
                'Stargazing',
                'Sunset Sail',
              ].contains(p.title),
            )
            .toList(),
        createdAt: DateTime(2025, 6, 15),
        coverColor: 'indigo',
      ),
    ];
  }
}
