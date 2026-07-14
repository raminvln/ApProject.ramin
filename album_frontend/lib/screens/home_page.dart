import 'package:flutter/material.dart';
import 'package:album_frontend/models/photo_model.dart';
import 'package:album_frontend/screens/photo_detail_page.dart';
import 'package:album_frontend/screens/upload_page.dart';
import 'package:album_frontend/services/mock_data.dart';
import 'package:album_frontend/services/search_service.dart';
import 'package:album_frontend/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<PhotoModel> _allPhotos;
  late Map<String, List<PhotoModel>> _groupedPhotos;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _sortBy = 'Latest';
  String _filterBy = 'All';

  @override
  void initState() {
    super.initState();
    _allPhotos = MockData.getPhotos();
    _applyFilterAndSort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _allPhotos = MockData.getPhotos();
    } else {
      _allPhotos = SearchService.searchAll(query, MockData.getPhotos(), {});
    }
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    List<PhotoModel> photos = List.from(_allPhotos);
    final now = DateTime.now();

    // Apply Filter
    switch (_filterBy) {
      case 'This Week':
        final weekAgo = now.subtract(const Duration(days: 7));
        photos = photos.where((p) => p.dateAdded.isAfter(weekAgo)).toList();
        break;
      case 'This Month':
        final monthAgo = now.subtract(const Duration(days: 30));
        photos = photos.where((p) => p.dateAdded.isAfter(monthAgo)).toList();
        break;
    }

    // اول گروه‌بندی بر اساس تاریخ
    var grouped = MockData.groupByDate(photos);

    // بعد Sort داخل هر گروه
    if (_sortBy != 'Latest') {
      Map<String, List<PhotoModel>> sortedGrouped = {};
      for (var key in grouped.keys) {
        List<PhotoModel> groupPhotos = List.from(grouped[key]!);
        switch (_sortBy) {
          case 'A-Z':
            groupPhotos.sort((a, b) => a.title.compareTo(b.title));
            break;
          case 'Most Liked':
            groupPhotos.sort((a, b) => b.likes.compareTo(a.likes));
            break;
        }
        sortedGrouped[key] = groupPhotos;
      }
      grouped = sortedGrouped;
    }

    setState(() {
      _groupedPhotos = grouped;
    });
  }

  void _showOptionsMenu() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              // Sort Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              _buildMenuOption(
                sheetContext,
                'Latest',
                Icons.access_time,
                _sortBy == 'Latest',
                () {
                  setState(() => _sortBy = 'Latest');
                  _applyFilterAndSort();
                },
              ),
              _buildMenuOption(
                sheetContext,
                'A-Z',
                Icons.sort_by_alpha,
                _sortBy == 'A-Z',
                () {
                  setState(() => _sortBy = 'A-Z');
                  _applyFilterAndSort();
                },
              ),
              _buildMenuOption(
                sheetContext,
                'Most Liked',
                Icons.favorite,
                _sortBy == 'Most Liked',
                () {
                  setState(() => _sortBy = 'Most Liked');
                  _applyFilterAndSort();
                },
              ),
              const Divider(indent: 16, endIndent: 16),
              // Filter Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Filter by',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              _buildMenuOption(
                sheetContext,
                'All',
                Icons.calendar_today,
                _filterBy == 'All',
                () {
                  setState(() => _filterBy = 'All');
                  _applyFilterAndSort();
                },
              ),
              _buildMenuOption(
                sheetContext,
                'This Week',
                Icons.date_range,
                _filterBy == 'This Week',
                () {
                  setState(() => _filterBy = 'This Week');
                  _applyFilterAndSort();
                },
              ),
              _buildMenuOption(
                sheetContext,
                'This Month',
                Icons.calendar_month,
                _filterBy == 'This Month',
                () {
                  setState(() => _filterBy = 'This Month');
                  _applyFilterAndSort();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext sheetContext,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(sheetContext);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF2563EB) : Colors.grey[500],
              size: 20,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isSelected ? const Color(0xFF2563EB) : null,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check, color: Color(0xFF2563EB), size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thickness: 4,
                radius: const Radius.circular(8),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast,
                  ),
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _groupedPhotos.keys.length,
                  itemBuilder: (context, index) {
                    String dateKey = _groupedPhotos.keys.elementAt(index);
                    List<PhotoModel> photos = _groupedPhotos[dateKey]!;
                    return _buildDateSection(dateKey, photos);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),

    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Photos',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showOptionsMenu,
                    customBorder: const CircleBorder(),
                    child: const Icon(Icons.more_horiz, size: 22),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search photos...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.5),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(String dateLabel, List<PhotoModel> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                dateLabel,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${photos.length}',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: photos.map((photo) => _buildPhotoCard(photo)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(PhotoModel photo) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 3;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhotoDetailPage(photo: photo)),
      ),
      child: Hero(
        tag: photo.id,
        flightShuttleBuilder:
            (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) => Material(
              color: Colors.transparent,
              child: toHeroContext.widget,
            ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: cardWidth,
            height: cardWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _getColorForPhoto(photo),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      photo.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                if (photo.caption != null)
                  Positioned(
                    bottom: 6,
                    left: 8,
                    right: 8,
                    child: Text(
                      photo.caption!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 9,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForPhoto(PhotoModel photo) {
    final colors = const [
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF97316),
      Color(0xFF10B981),
      Color(0xFF06B6D4),
      Color(0xFF6366F1),
      Color(0xFFF43F5E),
    ];
    final index = int.tryParse(photo.id) ?? 0;
    return colors[index % colors.length];
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadPage()),
          ),
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
