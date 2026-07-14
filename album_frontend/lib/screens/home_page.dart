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

  // Multi-select state
  bool _isSelecting = false;
  final Set<String> _selectedPhotoIds = {};

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

    switch (_filterBy) {
      case 'This Week':
        photos = photos
            .where(
              (p) => p.dateAdded.isAfter(now.subtract(const Duration(days: 7))),
            )
            .toList();
        break;
      case 'This Month':
        photos = photos
            .where(
              (p) =>
                  p.dateAdded.isAfter(now.subtract(const Duration(days: 30))),
            )
            .toList();
        break;
    }

    var grouped = MockData.groupByDate(photos);

    if (_sortBy != 'Latest') {
      Map<String, List<PhotoModel>> sortedGrouped = {};
      for (var key in grouped.keys) {
        List<PhotoModel> groupPhotos = List.from(grouped[key]!);
        switch (_sortBy) {
          case 'A-Z':
            groupPhotos.sort((a, b) => a.title.compareTo(b.title));
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

  void _toggleSelection(String photoId) {
    setState(() {
      if (_selectedPhotoIds.contains(photoId)) {
        _selectedPhotoIds.remove(photoId);
        if (_selectedPhotoIds.isEmpty) {
          _isSelecting = false;
        }
      } else {
        _selectedPhotoIds.add(photoId);
      }
    });
  }

  void _startSelection(String photoId) {
    setState(() {
      _isSelecting = true;
      _selectedPhotoIds.add(photoId);
    });
  }

  void _cancelSelection() {
    setState(() {
      _isSelecting = false;
      _selectedPhotoIds.clear();
    });
  }

  void _deleteSelected() {
    final count = _selectedPhotoIds.length;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Photos'),
        content: Text('Delete $count selected photo(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() {
                _allPhotos.removeWhere((p) => _selectedPhotoIds.contains(p.id));
                _selectedPhotoIds.clear();
                _isSelecting = false;
                _applyFilterAndSort();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$count photo(s) deleted'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addSelectedToAlbum() {
    final albums = [
      'Nature',
      'Travel',
      'Work',
      'Family',
      'Food',
      'City',
      'Fitness',
      'Memories',
    ];
    List<String> selectedAlbums = [];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add to Album'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: albums.map((album) {
                final isSelected = selectedAlbums.contains(album);
                return InkWell(
                  onTap: () => setDialogState(() {
                    if (isSelected) {
                      selectedAlbums.remove(album);
                    } else {
                      selectedAlbums.add(album);
                    }
                  }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2563EB)
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                            color: isSelected
                                ? const Color(0xFF2563EB)
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(album, style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _selectedPhotoIds.clear();
                  _isSelecting = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added to ${selectedAlbums.length} album(s)'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
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
                  _sortBy = 'Latest';
                  _applyFilterAndSort();
                },
              ),
              _buildMenuOption(
                sheetContext,
                'A-Z',
                Icons.sort_by_alpha,
                _sortBy == 'A-Z',
                () {
                  _sortBy = 'A-Z';
                  _applyFilterAndSort();
                },
              ),
              const Divider(indent: 16, endIndent: 16),
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
                  _filterBy = 'All';
                  _applyFilterAndSort();
                },
              ),
              _buildMenuOption(
                sheetContext,
                'This Week',
                Icons.date_range,
                _filterBy == 'This Week',
                () {
                  _filterBy = 'This Week';
                  _applyFilterAndSort();
                },
              ),
              _buildMenuOption(
                sheetContext,
                'This Month',
                Icons.calendar_month,
                _filterBy == 'This Month',
                () {
                  _filterBy = 'This Month';
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
                  padding: EdgeInsets.only(bottom: 80),
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
      floatingActionButton: _isSelecting ? null : _buildFloatingActionButton(),
      bottomNavigationBar: _isSelecting
          ? _buildSelectionBar()
          : const BottomNavBar(currentIndex: 0),
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
              _isSelecting
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: _cancelSelection,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_selectedPhotoIds.length} selected',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Photos',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              if (!_isSelecting)
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
          if (!_isSelecting) ...[
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
    final isSelected = _selectedPhotoIds.contains(photo.id);

    return GestureDetector(
      onTap: () {
        if (_isSelecting) {
          _toggleSelection(photo.id);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoDetailPage(photo: photo),
            ),
          );
        }
      },
      onLongPress: () {
        if (!_isSelecting) {
          _startSelection(photo.id);
        }
      },
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
              border: isSelected
                  ? Border.all(color: const Color(0xFF2563EB), width: 3)
                  : null,
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
                // Selection overlay
                if (_isSelecting)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.black.withValues(alpha: 0.4),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              Icons.photo_album_outlined,
              'Add to Album',
              () => _addSelectedToAlbum(),
            ),
            _buildActionButton(
              Icons.delete_outline,
              'Delete',
              () => _deleteSelected(),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : const Color(0xFF2563EB);
    return GestureDetector(
      onTap: _selectedPhotoIds.isEmpty ? null : onTap,
      child: Opacity(
        opacity: _selectedPhotoIds.isEmpty ? 0.4 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
