import 'package:flutter/material.dart';
import 'package:album_frontend/screens/home_page.dart';
import 'package:album_frontend/screens/albums_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home_outlined, Icons.home_filled, 'Home', 0),
              _buildNavItem(context, Icons.photo_album_outlined, Icons.photo_album, 'Albums', 1),
              _buildNavItem(context, Icons.search_outlined, Icons.search, 'Search', 2),
              _buildNavItem(context, Icons.favorite_outline, Icons.favorite, 'Favorites', 3),
              _buildNavItem(context, Icons.public_outlined, Icons.public, 'Explore', 4),
              _buildNavItem(context, Icons.person_outline, Icons.person, 'Profile', 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData iconOutlined,
    IconData iconFilled,
    String label,
    int index,
  ) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == currentIndex) return; // همین صفحه - هیچ کاری نکن

        switch (index) {
          case 0: // Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
            break;
          case 1: // Albums
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlbumsPage()),
            );
            break;
          case 2: // Search
            // TODO
            break;
          case 3: // Favorites
            // TODO
            break;
          case 4: // Explore
            // TODO
            break;
          case 5: // Profile
            // TODO
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2563EB).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? iconFilled : iconOutlined,
              size: 22,
              color: isSelected ? const Color(0xFF2563EB) : Colors.grey[500],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFF2563EB) : Colors.grey[500],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}