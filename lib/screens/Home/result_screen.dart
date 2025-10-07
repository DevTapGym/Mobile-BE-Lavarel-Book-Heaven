import 'package:flutter/material.dart';
import 'package:heaven_book_app/themes/app_colors.dart';

class ResultScreen extends StatefulWidget {
  final String? searchQuery;
  final String? category;
  final String? sectionTitle;

  const ResultScreen({
    super.key,
    this.searchQuery,
    this.category,
    this.sectionTitle,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> _filteredBooks = [];
  String _selectedSortOption = 'Popular';
  String _selectedViewType = 'grid'; // grid or list
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _sortOptions = [
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Newest',
    'Title A-Z',
  ];

  final List<String> _categories = [
    'All',
    'Fiction',
    'Science Fiction',
    'Mystery',
    'Romance',
    'Biography',
    'Self-Help',
    'History',
    'Technology',
    'Children',
  ];

  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadSampleBooks();
    _searchController.text = widget.searchQuery ?? '';
    _selectedCategory = widget.category ?? 'All';
    _filterBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSampleBooks() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _books = _getSampleBooks();
        _isLoading = false;
        _filterBooks();
      });
    });
  }

  List<Map<String, dynamic>> _getSampleBooks() {
    return [
      {
        'id': '1',
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'price': 12.99,
        'originalPrice': 15.99,
        'rating': 4.5,
        'reviewCount': 1250,
        'category': 'Fiction',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 19,
        'tags': ['classic', 'american literature'],
        'description': 'A classic American novel set in the Jazz Age.',
      },
      {
        'id': '2',
        'title': 'To Kill a Mockingbird',
        'author': 'Harper Lee',
        'price': 10.99,
        'originalPrice': 13.99,
        'rating': 4.8,
        'reviewCount': 2100,
        'category': 'Fiction',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 21,
        'tags': ['classic', 'drama'],
        'description':
            'A gripping tale of racial injustice and childhood innocence.',
      },
      {
        'id': '3',
        'title': 'Dune',
        'author': 'Frank Herbert',
        'price': 16.99,
        'originalPrice': 19.99,
        'rating': 4.7,
        'reviewCount': 1850,
        'category': 'Science Fiction',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 15,
        'tags': ['epic', 'space opera'],
        'description':
            'A science fiction masterpiece about politics, religion, and ecology.',
      },
      {
        'id': '4',
        'title': '1984',
        'author': 'George Orwell',
        'price': 11.99,
        'originalPrice': 14.99,
        'rating': 4.6,
        'reviewCount': 3200,
        'category': 'Fiction',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 20,
        'tags': ['dystopian', 'political'],
        'description': 'A dystopian social science fiction novel.',
      },
      {
        'id': '5',
        'title': 'The Girl with the Dragon Tattoo',
        'author': 'Stieg Larsson',
        'price': 13.99,
        'originalPrice': 16.99,
        'rating': 4.4,
        'reviewCount': 1650,
        'category': 'Mystery',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 18,
        'tags': ['thriller', 'crime'],
        'description': 'A psychological thriller mystery novel.',
      },
      {
        'id': '6',
        'title': 'Pride and Prejudice',
        'author': 'Jane Austen',
        'price': 9.99,
        'originalPrice': 12.99,
        'rating': 4.7,
        'reviewCount': 2800,
        'category': 'Romance',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 23,
        'tags': ['classic', 'romance'],
        'description': 'A romantic novel of manners.',
      },
      {
        'id': '7',
        'title': 'Steve Jobs',
        'author': 'Walter Isaacson',
        'price': 18.99,
        'originalPrice': 22.99,
        'rating': 4.5,
        'reviewCount': 1200,
        'category': 'Biography',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 17,
        'tags': ['biography', 'technology'],
        'description': 'The exclusive biography of Steve Jobs.',
      },
      {
        'id': '8',
        'title': 'Atomic Habits',
        'author': 'James Clear',
        'price': 15.99,
        'originalPrice': 18.99,
        'rating': 4.8,
        'reviewCount': 4500,
        'category': 'Self-Help',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 16,
        'tags': ['productivity', 'habits'],
        'description': 'An easy and proven way to build good habits.',
      },
      {
        'id': '9',
        'title': 'Sapiens',
        'author': 'Yuval Noah Harari',
        'price': 17.99,
        'originalPrice': 21.99,
        'rating': 4.6,
        'reviewCount': 3100,
        'category': 'History',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 18,
        'tags': ['anthropology', 'history'],
        'description': 'A brief history of humankind.',
      },
      {
        'id': '10',
        'title': 'Clean Code',
        'author': 'Robert C. Martin',
        'price': 24.99,
        'originalPrice': 29.99,
        'rating': 4.5,
        'reviewCount': 850,
        'category': 'Technology',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 17,
        'tags': ['programming', 'software'],
        'description': 'A handbook of agile software craftsmanship.',
      },
      {
        'id': '11',
        'title': 'Harry Potter and the Philosopher\'s Stone',
        'author': 'J.K. Rowling',
        'price': 8.99,
        'originalPrice': 10.99,
        'rating': 4.9,
        'reviewCount': 5200,
        'category': 'Children',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 18,
        'tags': ['fantasy', 'magic'],
        'description': 'The boy who lived begins his magical journey.',
      },
      {
        'id': '12',
        'title': 'The Alchemist',
        'author': 'Paulo Coelho',
        'price': 12.99,
        'originalPrice': 15.99,
        'rating': 4.3,
        'reviewCount': 2400,
        'category': 'Fiction',
        'imageUrl': 'https://via.placeholder.com/150x200',
        'discount': 19,
        'tags': ['philosophical', 'journey'],
        'description': 'A philosophical book about following your dreams.',
      },
    ];
  }

  void _filterBooks() {
    setState(() {
      _filteredBooks =
          _books.where((book) {
            bool matchesSearch = true;
            bool matchesCategory = true;

            // Search filter
            if (_searchController.text.isNotEmpty) {
              final query = _searchController.text.toLowerCase();
              matchesSearch =
                  book['title'].toString().toLowerCase().contains(query) ||
                  book['author'].toString().toLowerCase().contains(query) ||
                  book['category'].toString().toLowerCase().contains(query) ||
                  (book['tags'] as List).any(
                    (tag) => tag.toString().toLowerCase().contains(query),
                  );
            }

            // Category filter
            if (_selectedCategory != 'All') {
              matchesCategory = book['category'] == _selectedCategory;
            }

            return matchesSearch && matchesCategory;
          }).toList();

      _sortBooks();
    });
  }

  void _sortBooks() {
    switch (_selectedSortOption) {
      case 'Price: Low to High':
        _filteredBooks.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price: High to Low':
        _filteredBooks.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'Rating':
        _filteredBooks.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case 'Newest':
        // Simulate newest first (using id as proxy)
        _filteredBooks.sort((a, b) => b['id'].compareTo(a['id']));
        break;
      case 'Title A-Z':
        _filteredBooks.sort((a, b) => a['title'].compareTo(b['title']));
        break;
      default: // Popular
        _filteredBooks.sort(
          (a, b) => b['reviewCount'].compareTo(a['reviewCount']),
        );
        break;
    }
  }

  String _getPageTitle() {
    if (widget.searchQuery?.isNotEmpty == true) {
      return 'Search Results';
    } else if (widget.category != null) {
      return widget.category!;
    } else if (widget.sectionTitle != null) {
      return widget.sectionTitle!;
    }
    return 'Books';
  }

  String _getPageSubtitle() {
    if (widget.searchQuery?.isNotEmpty == true) {
      return 'for "${widget.searchQuery}"';
    } else if (widget.category != null) {
      return '${_filteredBooks.length} books found';
    }
    return '${_filteredBooks.length} books available';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getPageTitle(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getPageSubtitle(),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _selectedViewType == 'grid' ? Icons.view_list : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _selectedViewType =
                    _selectedViewType == 'grid' ? 'list' : 'grid';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchAndFilterBar(),

          // Results
          Expanded(
            child:
                _isLoading
                    ? _buildLoadingWidget()
                    : _filteredBooks.isEmpty
                    ? _buildEmptyWidget()
                    : _selectedViewType == 'grid'
                    ? _buildGridView()
                    : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books, authors, categories...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryDark,
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterBooks();
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) => _filterBooks(),
            ),
          ),

          const SizedBox(height: 12),

          // Category and Sort Row
          Row(
            children: [
              // Category Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryDark,
                      ),
                      items:
                          _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                          _filterBooks();
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Sort Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSortOption,
                      icon: const Icon(
                        Icons.sort,
                        color: AppColors.primaryDark,
                      ),
                      items:
                          _sortOptions.map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(
                                option,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSortOption = value!;
                          _sortBooks();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Loading books...',
            style: TextStyle(fontSize: 16, color: AppColors.text),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No books found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedCategory = 'All';
                _filterBooks();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.55,
        ),
        itemCount: _filteredBooks.length,
        itemBuilder: (context, index) {
          return _buildBookGridCard(_filteredBooks[index]);
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredBooks.length,
      itemBuilder: (context, index) {
        return _buildBookListCard(_filteredBooks[index]);
      },
    );
  }

  Widget _buildBookGridCard(Map<String, dynamic> book) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Cover
          Stack(
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.book,
                    size: 50,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              // Discount Badge
              if (book['discount'] > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '-${book['discount']}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Favorite Button
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 16,
                    ),
                    onPressed: () {},
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),

          // Book Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book['author'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        book['rating'].toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 6),
                      Container(width: 1, height: 12, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        '22 sold',
                        style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${book['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      if (book['originalPrice'] != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            '\$${book['originalPrice'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookListCard(Map<String, dynamic> book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Book Cover
          Stack(
            children: [
              Container(
                width: 100,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.book,
                    size: 40,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              if (book['discount'] > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '-${book['discount']}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Book Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        book['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  book['author'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  book['category'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${book['rating']} (${book['reviewCount']})',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Container(width: 1, height: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '23 sold',
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${book['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    if (book['originalPrice'] != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '\$${book['originalPrice'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
