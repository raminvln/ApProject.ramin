import 'package:flutter/material.dart';
import 'package:album_frontend/models/photo_model.dart';
import 'package:album_frontend/screens/photo_detail_page.dart';
import 'package:album_frontend/services/mock_data.dart';
import 'package:album_frontend/services/search_service.dart';
import 'package:album_frontend/widgets/bottom_nav_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  List<PhotoModel> _allPhotos = [];
  List<PhotoModel> _searchResults = [];
  Map<String, List<String>> _albumPhotoMap = {};
  String _selectedFilter = 'All';
  DateTime? _selectedDate;
  bool _isSearching = false;

  final List<String> _recentSearches = [];
  final List<String> _trendingTags = [
    'nature', 'sunset', 'travel', 'beach', 'mountain', 'city'
  ];

  @override
  void initState() {
    super.initState();
    _allPhotos = MockData.getPhotos();
    _albumPhotoMap = MockData.getAlbumPhotoMap();
    _searchResults = [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query, {bool saveToHistory = false}) {
    if (_selectedFilter == 'Date') return;

    setState(() {
      _isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        _searchResults = [];
        return;
      }

      switch (_selectedFilter) {
        case 'Name':
          _searchResults = SearchService.searchByName(query, _allPhotos);
          break;
        case 'Tag':
          _searchResults = SearchService.searchByTag(query, _allPhotos);
          break;
        case 'Album':
          _searchResults =
              SearchService.searchByAlbum(query, _allPhotos, _albumPhotoMap);
          break;
        case 'Comment':
          _searchResults = SearchService.searchByComment(query, _allPhotos);
          break;
        default: // All
          _searchResults =
              SearchService.searchAll(query, _allPhotos, _albumPhotoMap);
      }

      // فقط وقتی saveToHistory باشه ذخیره کن
      if (saveToHistory &&
          query.isNotEmpty &&
          !_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      }
    });
  }

  void _performDateSearch() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _isSearching = true;
        _searchResults = SearchService.searchByDate(date, _allPhotos);
        _searchController.text = _formatDate(date);

        // ذخیره در تاریخچه
        final dateString = _formatDate(date);
        if (!_recentSearches.contains(dateString)) {
          _recentSearches.insert(0, dateString);
          if (_recentSearches.length > 5) {
            _recentSearches.removeLast();
          }
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
              child: _isSearching
                  ? _buildResults(isDark)
                  : _buildSuggestions(isDark),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildHeader(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        children: [
          // Title
          Row(
            children: [
              Text(
                'Search',
                style: TextStyle(
                  color: textColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_isSearching)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchController.clear();
                      _searchResults = [];
                      _isSearching = false;
                      _selectedDate = null;
                      _searchFocusNode.unfocus();
                    });
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Field
          TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: (value) {
              _performSearch(value);
            },
            onSubmitted: (value) {
              _performSearch(value, saveToHistory: true);
            },
            onTap: () {
              if (_selectedFilter == 'Date') {
                _performDateSearch();
              }
            },
            readOnly: _selectedFilter == 'Date',
            decoration: InputDecoration(
              hintText: _selectedFilter == 'Date'
                  ? 'Tap to pick a date...'
                  : 'Search photos...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchResults = [];
                          _isSearching = false;
                          _selectedDate = null;
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor:
                  isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
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
          const SizedBox(height: 16),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', isDark),
                _buildFilterChip('Name', isDark),
                _buildFilterChip('Tag', isDark),
                _buildFilterChip('Album', isDark),
                _buildFilterChip('Comment', isDark),
                _buildFilterChip('Date', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isDark) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = label;
            _searchController.clear();
            _searchResults = [];
            _isSearching = false;
            _selectedDate = null;
          });
          if (label == 'Date') {
            _performDateSearch();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2563EB)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[500],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : const Color(0xFF6B7280);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _recentSearches.clear());
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: const Color(0xFF2563EB),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._recentSearches.map((search) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      _searchController.text = search;
                      _performSearch(search, saveToHistory: true);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.history, color: subtitleColor, size: 18),
                        const SizedBox(width: 12),
                        Text(search, style: TextStyle(color: subtitleColor)),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 28),
          ],
          // Trending Tags
          Text(
            'Trending Tags',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trendingTags.map((tag) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = tag;
                  _selectedFilter = 'Tag';
                  _performSearch(tag, saveToHistory: true);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Text(
            '${_searchResults.length} Results',
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : Scrollbar(
                  controller: _scrollController,
                  thickness: 4,
                  radius: const Radius.circular(8),
                  child: GridView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return _buildPhotoCard(_searchResults[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(PhotoModel photo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoDetailPage(photo: photo),
          ),
        );
      },
      child: Hero(
        tag: 'search_${photo.id}',
        flightShuttleBuilder: (flightContext, animation, flightDirection,
            fromHeroContext, toHeroContext) {
          return Material(
            color: Colors.transparent,
            child: toHeroContext.widget,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForPhoto(PhotoModel photo) {
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFFF97316),
      const Color(0xFF10B981),
      const Color(0xFF06B6D4),
      const Color(0xFF6366F1),
      const Color(0xFFF43F5E),
    ];
    final index = int.tryParse(photo.id) ?? 0;
    return colors[index % colors.length];
  }
}