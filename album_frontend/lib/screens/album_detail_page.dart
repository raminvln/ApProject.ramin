import 'package:flutter/material.dart';
import 'package:album_frontend/models/album_model.dart';
import 'package:album_frontend/models/photo_model.dart';
import 'package:album_frontend/screens/photo_detail_page.dart';
import 'package:album_frontend/screens/select_photos_page.dart';
import 'package:album_frontend/services/mock_data.dart';
import 'package:album_frontend/services/search_service.dart';

class AlbumDetailPage extends StatefulWidget {
  final AlbumModel album;

  const AlbumDetailPage({super.key, required this.album});

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Map<String, List<PhotoModel>> _groupedPhotos;
  late List<PhotoModel> _allFilteredPhotos;
  String _selectedFilter = 'All';
  String _sortBy = 'Latest';

  @override
  void initState() {
    super.initState();
    _allFilteredPhotos = List.from(widget.album.photos);
    _applyFilter('All');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _allFilteredPhotos = List.from(widget.album.photos);
      } else {
        _allFilteredPhotos =
            SearchService.searchAll(query, widget.album.photos, {});
      }
      _applyFilter(_selectedFilter);
      _sortPhotos(_sortBy);
    });
  }

  void _applyFilter(String filter) {
    List<PhotoModel> filteredPhotos;
    final now = DateTime.now();

    switch (filter) {
      case 'This Week':
        final weekAgo = now.subtract(const Duration(days: 7));
        filteredPhotos = _allFilteredPhotos
            .where((p) => p.dateAdded.isAfter(weekAgo))
            .toList();
        break;
      case 'This Month':
        final monthAgo = now.subtract(const Duration(days: 30));
        filteredPhotos = _allFilteredPhotos
            .where((p) => p.dateAdded.isAfter(monthAgo))
            .toList();
        break;
      default:
        filteredPhotos = _allFilteredPhotos;
    }

    setState(() {
      _selectedFilter = filter;
      _groupedPhotos = MockData.groupByDate(filteredPhotos);
    });
    _sortPhotos(_sortBy);
  }

  void _sortPhotos(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      List<PhotoModel> photos = [];
      for (var key in _groupedPhotos.keys) {
        photos.addAll(_groupedPhotos[key]!);
      }

      switch (sortBy) {
        case 'A-Z':
          photos.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Most Liked':
          photos.sort((a, b) => b.likes.compareTo(a.likes));
          break;
        default:
          photos.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      }

      _groupedPhotos = MockData.groupByDate(photos);
    });
  }

  String _getLastUpdated() {
    if (widget.album.photos.isEmpty) return 'No photos';
    final lastPhoto = widget.album.photos
        .reduce((a, b) => a.dateAdded.isAfter(b.dateAdded) ? a : b);
    return _formatDate(lastPhoto.dateAdded);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final photoDate = DateTime(date.year, date.month, date.day);
    if (photoDate == today) return 'Today';
    if (photoDate == today.subtract(const Duration(days: 1))) return 'Yesterday';
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thickness: 4,
                radius: const Radius.circular(8),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast),
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _groupedPhotos.keys.length,
                  itemBuilder: (context, index) {
                    String dateKey =
                        _groupedPhotos.keys.elementAt(index);
                    List<PhotoModel> photos =
                        _groupedPhotos[dateKey]!;
                    return _buildDateSection(dateKey, photos, isDark);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: cardColor,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))]),
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () => Navigator.pop(context),
                        customBorder: const CircleBorder(),
                        child: Icon(Icons.arrow_back, color: textColor, size: 22))),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(widget.album.name,
                      style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold))),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: cardColor,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))]),
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () => _showAlbumOptions(),
                        customBorder: const CircleBorder(),
                        child: Icon(Icons.more_horiz, color: textColor, size: 22))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [_getColorForAlbum(widget.album), _getColorForAlbum(widget.album).withValues(alpha: 0.7)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: _getColorForAlbum(widget.album).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(Icons.calendar_today, 'Created', _formatDate(widget.album.createdAt)),
                  Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                  _buildInfoItem(Icons.update, 'Updated', _getLastUpdated()),
                  Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                  _buildInfoItem(Icons.photo_library, 'Photos', '${widget.album.photoCount}'),
                ]),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', isDark),
                _buildFilterChip('This Week', isDark),
                _buildFilterChip('This Month', isDark),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSortChip('Latest', isDark),
                _buildSortChip('A-Z', isDark),
                _buildSortChip('Most Liked', isDark),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search in album...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      })
                  : null,
              filled: true,
              fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: const Color(0xFF2563EB).withValues(alpha: 0.5))),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(children: [
      Icon(icon, color: Colors.white, size: 20),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10)),
    ]);
  }

  Widget _buildFilterChip(String label, bool isDark) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _applyFilter(label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: isSelected ? _getColorForAlbum(widget.album) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSelected ? _getColorForAlbum(widget.album) : Colors.transparent)),
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, bool isDark) {
    final isSelected = _sortBy == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _sortPhotos(label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
              color: isSelected ? _getColorForAlbum(widget.album).withValues(alpha: 0.1) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSelected ? _getColorForAlbum(widget.album) : Colors.transparent)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(label == 'Latest' ? Icons.access_time : label == 'A-Z' ? Icons.sort_by_alpha : Icons.favorite, size: 14, color: isSelected ? _getColorForAlbum(widget.album) : Colors.grey[500]),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isSelected ? _getColorForAlbum(widget.album) : Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    );
  }

  Widget _buildDateSection(String dateLabel, List<PhotoModel> photos, bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Row(children: [
          Container(width: 4, height: 20, decoration: BoxDecoration(color: _getColorForAlbum(widget.album), borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Text(dateLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor)),
          const SizedBox(width: 10),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _getColorForAlbum(widget.album).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Text('${photos.length}', style: TextStyle(color: _getColorForAlbum(widget.album), fontSize: 13, fontWeight: FontWeight.w600))),
        ]),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(spacing: 8, runSpacing: 8, children: photos.map((photo) => _buildPhotoCard(photo)).toList())),
    ]);
  }

  Widget _buildPhotoCard(PhotoModel photo) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 3;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoDetailPage(photo: photo, fromAlbum: widget.album.name)));
      },
      onLongPress: () => _showPhotoActions(photo),
      child: Hero(
        tag: 'album_${photo.id}',
        flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) => Material(color: Colors.transparent, child: toHeroContext.widget),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: cardWidth, height: cardWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: _getColorForPhoto(photo),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))]),
            child: Stack(children: [
              Center(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(photo.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)))),
              Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent])))),
              if (photo.caption != null) Positioned(bottom: 6, left: 8, right: 8, child: Text(photo.caption!, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ]),
          ),
        ),
      ),
    );
  }

  void _showPhotoActions(PhotoModel photo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(photo.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            _buildSheetOption(sheetContext, Icons.swap_horiz, 'Move to Another Album', () {
              _showAlbumPickerForPhoto(photo, isCopy: false);
            }),
            _buildSheetOption(sheetContext, Icons.copy, 'Copy to Another Album', () {
              _showAlbumPickerForPhoto(photo, isCopy: true);
            }),
            const Divider(indent: 16, endIndent: 16),
            _buildSheetOption(sheetContext, Icons.remove_circle_outline, 'Remove from Album', () {
              _showRemoveFromAlbumDialog(photo);
            }, isDestructive: true),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _buildSheetOption(BuildContext sheetContext, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red : const Color(0xFF2563EB);
    return InkWell(
      onTap: () {
        Navigator.pop(sheetContext);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(fontSize: 16, color: isDestructive ? Colors.red : null)),
        ]),
      ),
    );
  }

  void _showAlbumPickerForPhoto(PhotoModel photo, {required bool isCopy}) {
    final albums = ['Nature', 'Travel', 'Work', 'Family', 'Food', 'City', 'Fitness', 'Memories'].where((a) => a != widget.album.name).toList();
    List<String> selectedAlbums = [];
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isCopy ? 'Copy to Album' : 'Move to Album'),
          content: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: albums.map((album) {
                  final isSelected = selectedAlbums.contains(album);
                  return InkWell(
                    onTap: () => setDialogState(() => isSelected ? selectedAlbums.remove(album) : selectedAlbums.add(album)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(children: [
                        Container(
                            width: 22, height: 22,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.grey[400]!, width: 2), color: isSelected ? const Color(0xFF2563EB) : Colors.transparent),
                            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null),
                        const SizedBox(width: 12),
                        Text(album, style: const TextStyle(fontSize: 15)),
                      ]),
                    ),
                  );
                }).toList()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Photo ${isCopy ? "copied" : "moved"} to ${selectedAlbums.length} album(s)'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveFromAlbumDialog(PhotoModel photo) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Photo'),
        content: Text('Remove "${photo.title}" from ${widget.album.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Removed from ${widget.album.name}'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAlbumOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(widget.album.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.pop(sheetContext);
                _showDeleteAlbumDialog();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(children: [
                  Icon(Icons.delete_outline, color: Colors.red, size: 22),
                  SizedBox(width: 16),
                  Text('Delete Album', style: TextStyle(fontSize: 16, color: Colors.red)),
                ]),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  void _showDeleteAlbumDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Album'),
        content: Text('Are you sure you want to delete "${widget.album.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Album "${widget.album.name}" deleted'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 60, height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [_getColorForAlbum(widget.album), _getColorForAlbum(widget.album).withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: _getColorForAlbum(widget.album).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SelectPhotosPage(album: widget.album))),
          customBorder: const CircleBorder(),
          child: const Center(child: Icon(Icons.add, color: Colors.white, size: 30)),
        ),
      ),
    );
  }

  Color _getColorForAlbum(AlbumModel album) {
    switch (album.coverColor) {
      case 'green': return const Color(0xFF10B981);
      case 'blue': return const Color(0xFF3B82F6);
      case 'purple': return const Color(0xFF8B5CF6);
      case 'orange': return const Color(0xFFF97316);
      case 'pink': return const Color(0xFFEC4899);
      case 'cyan': return const Color(0xFF06B6D4);
      case 'red': return const Color(0xFFEF4444);
      case 'indigo': return const Color(0xFF6366F1);
      default: return const Color(0xFF3B82F6);
    }
  }

  Color _getColorForPhoto(PhotoModel photo) {
    final colors = const [
      Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFFEC4899),
      Color(0xFFF97316), Color(0xFF10B981), Color(0xFF06B6D4),
      Color(0xFF6366F1), Color(0xFFF43F5E),
    ];
    final index = int.tryParse(photo.id) ?? 0;
    return colors[index % colors.length];
  }
}