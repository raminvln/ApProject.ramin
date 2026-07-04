import 'package:album_frontend/models/photo_model.dart';

class MockData {
  static List<PhotoModel> getPhotos() {
    return [
      PhotoModel(
        id: '1',
        url: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400',
        title: 'Sunset',
        caption: 'Beautiful sunset',
        isImportant: true,
        isFavorite: true,
        dateAdded: DateTime(2026, 6, 15),
      ),
      PhotoModel(
        id: '2',
        url: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
        title: 'Mountains',
        caption: 'Mountain view',
        isFavorite: true,
        dateAdded: DateTime(2026, 6, 20),
      ),
      PhotoModel(
        id: '3',
        url: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
        title: 'Beach',
        caption: 'Summer beach',
        isImportant: true,
        dateAdded: DateTime(2026, 6, 25),
      ),
      PhotoModel(
        id: '4',
        url: 'https://images.unsplash.com/photo-1444723121867-7a241cacace9?w=400',
        title: 'City',
        dateAdded: DateTime(2026, 6, 28),
      ),
      PhotoModel(
        id: '5',
        url: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
        title: 'Nature',
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 1),
      ),
      PhotoModel(
        id: '6',
        url: 'https://images.unsplash.com/photo-1445264918150-66a2371142a2?w=400',
        title: 'Forest',
        isImportant: true,
        dateAdded: DateTime(2026, 7, 2),
      ),
      PhotoModel(
        id: '7',
        url: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400',
        title: 'River',
        dateAdded: DateTime(2026, 7, 3),
      ),
      PhotoModel(
        id: '8',
        url: 'https://images.unsplash.com/photo-1444021465936-c6ca81d39b84?w=400',
        title: 'Garden',
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 4),
      ),
      PhotoModel(
        id: '9',
        url: 'https://images.unsplash.com/photo-1490750967868-88aa4f44baee?w=400',
        title: 'Flowers',
        dateAdded: DateTime(2026, 7, 5),
      ),
      PhotoModel(
        id: '10',
        url: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400',
        title: 'Lake',
        isImportant: true,
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 6),
      ),
      PhotoModel(
        id: '11',
        url: 'https://images.unsplash.com/photo-1472396961693-142e6e269027?w=400',
        title: 'Desert',
        dateAdded: DateTime(2026, 7, 7),
      ),
      PhotoModel(
        id: '12',
        url: 'https://images.unsplash.com/photo-1484821582734-6c6c9f99a672?w=400',
        title: 'Ocean',
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 8),
      ),
      PhotoModel(
        id: '13',
        url: 'https://images.unsplash.com/photo-1509909756405-be0199881695?w=400',
        title: 'Autumn',
        isImportant: true,
        dateAdded: DateTime(2026, 7, 9),
      ),
      PhotoModel(
        id: '14',
        url: 'https://images.unsplash.com/photo-1483664852095-d6cc6870702d?w=400',
        title: 'Winter',
        dateAdded: DateTime(2026, 7, 10),
      ),
      PhotoModel(
        id: '15',
        url: 'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=400',
        title: 'Spring',
        isFavorite: true,
        dateAdded: DateTime(2026, 7, 11),
      ),
      PhotoModel(
        id: '16',
        url: 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=400',
        title: 'Bridge',
        isImportant: true,
        dateAdded: DateTime(2026, 7, 12),
      ),
    ];
  }
}