import 'package:flutter/material.dart';
import 'package:album_frontend/models/photo_model.dart';

class PhotoDetailPage extends StatefulWidget {
  final PhotoModel photo;
  final String? fromAlbum;

  const PhotoDetailPage({
    super.key,
    required this.photo,
    this.fromAlbum,
  });

  @override
  State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.photo.isFavorite;
  }

  void _showPhotoOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFromAlbum = widget.fromAlbum != null;

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
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              const Text('Photo Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              _buildOptionItem(
                icon: Icons.photo_album_outlined,
                title: 'Add to Album',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showAlbumPicker(
                    title: 'Add to Album',
                    onDone: (albums) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Photo added to ${albums.length} album(s)'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
                        );
                      }
                    },
                  );
                },
              ),
              if (isFromAlbum) ...[
                _buildOptionItem(
                  icon: Icons.copy,
                  title: 'Copy to Another Album',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showAlbumPicker(
                      title: 'Copy to Album',
                      excludeAlbum: widget.fromAlbum,
                      onDone: (albums) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Photo copied to ${albums.length} album(s)'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
                          );
                        }
                      },
                    );
                  },
                ),
                _buildOptionItem(
                  icon: Icons.swap_horiz,
                  title: 'Move to Another Album',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showAlbumPicker(
                      title: 'Move to Album',
                      excludeAlbum: widget.fromAlbum,
                      onDone: (albums) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Photo moved to ${albums.length} album(s)'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
                          );
                        }
                      },
                    );
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                _buildOptionItem(
                  icon: Icons.remove_circle_outline,
                  title: 'Remove from Album',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showConfirmationDialog(
                      title: 'Remove Photo',
                      content: 'Remove "${widget.photo.title}" from ${widget.fromAlbum}?',
                      onConfirm: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
              const Divider(indent: 16, endIndent: 16),
              _buildOptionItem(
                icon: Icons.delete_outline,
                title: 'Delete Photo',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showConfirmationDialog(
                    title: 'Delete Photo',
                    content: 'Are you sure you want to permanently delete this photo?',
                    onConfirm: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final color = isDestructive ? Colors.red : const Color(0xFF2563EB);
    return InkWell(
      onTap: onTap,
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

  void _showAlbumPicker({
    required String title,
    String? excludeAlbum,
    required Function(List<String>) onDone,
  }) {
    final albums = ['Nature', 'Travel', 'Work', 'Family', 'Food', 'City', 'Fitness', 'Memories']
        .where((a) => a != excludeAlbum)
        .toList();
    List<String> selectedAlbums = [];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: albums.map((album) {
              final isSelected = selectedAlbums.contains(album);
              return InkWell(
                onTap: () => setDialogState(() { if (isSelected) { selectedAlbums.remove(album); } else { selectedAlbums.add(album); } }),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.grey[400]!, width: 2), color: isSelected ? const Color(0xFF2563EB) : Colors.transparent),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                    ),
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
              onPressed: () { Navigator.pop(dialogContext); onDone(selectedAlbums); },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title), content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { Navigator.pop(dialogContext); onConfirm(); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: widget.photo.id,
                  flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                    return Material(color: Colors.transparent, child: toHeroContext.widget);
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: double.infinity,
                      decoration: BoxDecoration(color: _getColorForPhoto(widget.photo)),
                    ),
                  ),
                ),
                _buildContent(isDark),
              ],
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildGlassAppBar()),
        ],
      ),
    );
  }

  Widget _buildGlassAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 44, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.5)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                customBorder: const CircleBorder(),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.5)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isFavorite ? 'Added to Favorites' : 'Removed from Favorites'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    customBorder: const CircleBorder(),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.5)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showPhotoOptions(),
                    customBorder: const CircleBorder(),
                    child: const Icon(Icons.more_horiz, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF6B7280);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final tagBgColor = isDark ? const Color(0xFF3B82F6).withValues(alpha: 0.15) : const Color(0xFF3B82F6).withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.photo.title, style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        if (widget.photo.caption != null) ...[
          const SizedBox(height: 6),
          Text(widget.photo.caption!, style: TextStyle(color: subtitleColor, fontSize: 15)),
        ],
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))]),
          child: Row(children: [
            const Icon(Icons.calendar_today, color: Color(0xFF2563EB), size: 20),
            const SizedBox(width: 12),
            Text(_formatDate(widget.photo.dateAdded), style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w500)),
          ]),
        ),
        const SizedBox(height: 20),
        if (widget.photo.tags.isNotEmpty) ...[
          Text('Tags', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: widget.photo.tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: tagBgColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3))),
              child: Text('#$tag', style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 13, fontWeight: FontWeight.w500)),
            );
          }).toList()),
        ],
        const SizedBox(height: 40),
      ]),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getColorForPhoto(PhotoModel photo) {
    final colors = const [Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFFF97316), Color(0xFF10B981), Color(0xFF06B6D4), Color(0xFF6366F1), Color(0xFFF43F5E)];
    final index = int.tryParse(photo.id) ?? 0;
    return colors[index % colors.length];
  }
}