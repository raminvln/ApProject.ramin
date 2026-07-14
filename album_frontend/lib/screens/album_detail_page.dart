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
  String _filterBy = 'All';
  String _sortBy = 'Latest';

  @override
  void initState() {
    super.initState();
    _allFilteredPhotos = List.from(widget.album.photos);
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
      _allFilteredPhotos = List.from(widget.album.photos);
    } else {
      _allFilteredPhotos = SearchService.searchAll(
        query,
        widget.album.photos,
        {},
      );
    }
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    List<PhotoModel> photos = List.from(_allFilteredPhotos);
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
          case 'Most Liked':
            groupPhotos.sort((a, b) => b.likes.compareTo(a.likes));
            break;
        }
        sortedGrouped[key] = groupPhotos;
      }
      grouped = sortedGrouped;
    }

    setState(() => _groupedPhotos = grouped);
  }

  void _showOptionsMenu() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
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
                Text(
                  widget.album.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
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
                const Divider(indent: 16, endIndent: 16),
                InkWell(
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _deleteAlbumDialog();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        SizedBox(width: 14),
                        Text(
                          'Delete Album',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
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
              color: isSelected
                  ? _getColorForAlbum(widget.album)
                  : Colors.grey[500],
              size: 20,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isSelected ? _getColorForAlbum(widget.album) : null,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: _getColorForAlbum(widget.album),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  void _deleteAlbumDialog() {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Album'),
        content: Text('Delete "${widget.album.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dCtx);
              Navigator.pop(context);
              if (mounted)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Album deleted'),
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

  String _getLastUpdated() {
    if (widget.album.photos.isEmpty) return 'No photos';
    return _formatDate(
      widget.album.photos
          .reduce((a, b) => a.dateAdded.isAfter(b.dateAdded) ? a : b)
          .dateAdded,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final photoDate = DateTime(date.year, date.month, date.day);
    if (photoDate == today) return 'Today';
    if (photoDate == today.subtract(const Duration(days: 1)))
      return 'Yesterday';
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
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
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
                    decelerationRate: ScrollDecelerationRate.fast,
                  ),
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _groupedPhotos.keys.length,
                  itemBuilder: (context, index) => _buildDateSection(
                    _groupedPhotos.keys.elementAt(index),
                    _groupedPhotos[_groupedPhotos.keys.elementAt(index)]!,
                    isDark,
                  ),
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
              _circleBtn(
                cardColor,
                Icons.arrow_back,
                () => Navigator.pop(context),
                textColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.album.name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _circleBtn(
                cardColor,
                Icons.more_horiz,
                _showOptionsMenu,
                textColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoCard(),
          const SizedBox(height: 16),
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

  Widget _circleBtn(
    Color color,
    IconData icon,
    VoidCallback onTap,
    Color iconColor,
  ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
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
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getColorForAlbum(widget.album),
            _getColorForAlbum(widget.album).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getColorForAlbum(widget.album).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoItem(
            Icons.calendar_today,
            'Created',
            _formatDate(widget.album.createdAt),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          _infoItem(Icons.update, 'Updated', _getLastUpdated()),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          _infoItem(
            Icons.photo_library,
            'Photos',
            '${widget.album.photoCount}',
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection(
    String dateLabel,
    List<PhotoModel> photos,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
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
                  color: _getColorForAlbum(widget.album),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                dateLabel,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getColorForAlbum(widget.album).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${photos.length}',
                  style: TextStyle(
                    color: _getColorForAlbum(widget.album),
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
            children: photos.map((p) => _buildPhotoCard(p)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(PhotoModel photo) {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 3;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PhotoDetailPage(photo: photo, fromAlbum: widget.album.name),
        ),
      ),
      onLongPress: () => _showPhotoActions(photo),
      child: Hero(
        tag: 'album_${photo.id}',
        flightShuttleBuilder: (fCtx, anim, dir, from, to) =>
            Material(color: Colors.transparent, child: to.widget),
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
                    padding: const EdgeInsets.all(8),
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

  void _showPhotoActions(PhotoModel photo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sCtx) => Container(
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
              const SizedBox(height: 16),
              Text(
                photo.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _sheetOpt(
                sCtx,
                Icons.swap_horiz,
                'Move to Album',
                () => _albumPicker(photo, false),
              ),
              _sheetOpt(
                sCtx,
                Icons.copy,
                'Copy to Album',
                () => _albumPicker(photo, true),
              ),
              const Divider(indent: 16, endIndent: 16),
              _sheetOpt(
                sCtx,
                Icons.remove_circle_outline,
                'Remove',
                () => _removeDialog(photo),
                true,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetOpt(
    BuildContext ctx,
    IconData icon,
    String title,
    VoidCallback onTap, [
    bool red = false,
  ]) {
    final color = red ? Colors.red : const Color(0xFF2563EB);
    return InkWell(
      onTap: () {
        Navigator.pop(ctx);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: red ? Colors.red : null),
            ),
          ],
        ),
      ),
    );
  }

  void _albumPicker(PhotoModel photo, bool isCopy) {
    final albums = [
      'Nature',
      'Travel',
      'Work',
      'Family',
      'Food',
      'City',
      'Fitness',
      'Memories',
    ].where((a) => a != widget.album.name).toList();
    List<String> selected = [];

    showDialog(
      context: context,
      builder: (dCtx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(isCopy ? 'Copy' : 'Move'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: albums.map((a) {
                return InkWell(
                  onTap: () => setD(() {
                    if (selected.contains(a)) {
                      selected.remove(a);
                    } else {
                      selected.add(a);
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
                              color: selected.contains(a)
                                  ? const Color(0xFF2563EB)
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                            color: selected.contains(a)
                                ? const Color(0xFF2563EB)
                                : Colors.transparent,
                          ),
                          child: selected.contains(a)
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(a, style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dCtx);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Photo ${isCopy ? "copied" : "moved"}'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
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

  void _removeDialog(PhotoModel photo) {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove'),
        content: Text('Remove "${photo.title}" from ${widget.album.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dCtx);
              if (mounted)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed'),
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
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            _getColorForAlbum(widget.album),
            _getColorForAlbum(widget.album).withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _getColorForAlbum(widget.album).withValues(alpha: 0.4),
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
            MaterialPageRoute(
              builder: (context) => SelectPhotosPage(album: widget.album),
            ),
          ),
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  Color _getColorForAlbum(AlbumModel a) {
    switch (a.coverColor) {
      case 'green':
        return const Color(0xFF10B981);
      case 'blue':
        return const Color(0xFF3B82F6);
      case 'purple':
        return const Color(0xFF8B5CF6);
      case 'orange':
        return const Color(0xFFF97316);
      case 'pink':
        return const Color(0xFFEC4899);
      case 'cyan':
        return const Color(0xFF06B6D4);
      case 'red':
        return const Color(0xFFEF4444);
      case 'indigo':
        return const Color(0xFF6366F1);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  Color _getColorForPhoto(PhotoModel p) {
    final c = const [
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF97316),
      Color(0xFF10B981),
      Color(0xFF06B6D4),
      Color(0xFF6366F1),
      Color(0xFFF43F5E),
    ];
    final index = int.tryParse(p.id) ?? 0;
    return c[index % c.length];
  }
}
