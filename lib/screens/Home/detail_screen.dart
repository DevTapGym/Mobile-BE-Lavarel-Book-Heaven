import '../../widgets/review_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:heaven_book_app/widgets/book_section_widget.dart';
import '../../themes/app_colors.dart';
import 'dart:async';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late Timer _timer;
  bool isFavorite = false;
  int quantity = 1;
  int _currentImageIndex = 0;

  // Social media options data
  final List<Map<String, dynamic>> _socialMediaOptions = [
    {
      'title': 'Facebook',
      'icon': Icons.facebook,
      'color': const Color(0xFF1877F2),
      'platform': 'facebook',
    },
    {
      'title': 'Instagram',
      'icon': Icons.camera_alt,
      'color': const Color(0xFFE4405F),
      'platform': 'instagram',
    },
    {
      'title': 'Telegram',
      'icon': Icons.send,
      'color': const Color(0xFF0088CC),
      'platform': 'telegram',
    },
    {
      'title': 'WhatsApp',
      'icon': Icons.chat,
      'color': const Color(0xFF25D366),
      'platform': 'whatsapp',
    },
    {
      'title': 'Twitter',
      'icon': Icons.alternate_email,
      'color': const Color(0xFF1DA1F2),
      'platform': 'twitter',
    },
    {
      'title': 'LinkedIn',
      'icon': Icons.work,
      'color': const Color(0xFF0077B5),
      'platform': 'linkedin',
    },
    {
      'title': 'TikTok',
      'icon': Icons.music_note,
      'color': const Color(0xFF000000),
      'platform': 'tiktok',
    },
    {
      'title': 'Discord',
      'icon': Icons.forum,
      'color': const Color(0xFF5865F2),
      'platform': 'discord',
    },
  ];

  // Sample book data
  final Map<String, dynamic> bookData = {
    'title': 'The Great Gatsby',
    'author': 'F. Scott Fitzgerald',
    'rating': 4.6,
    'reviewCount': 15420,
    'price': 18.99,
    'originalPrice': 24.99,
    'discount': 25,
    'publisher': 'Penguin Classics',
    'publishDate': '2023',
    'pages': 180,
    'language': 'English',
    'isbn': '978-0-14-243724-7',
    'category': 'Classic Literature',
    'images': [
      'https://example.com/book_image1.jpg',
      'https://example.com/book_image2.jpg',
      'https://example.com/book_image3.jpg',
      'https://example.com/book_image4.jpg',
    ],
    'description':
        'Set in the Jazz Age on prosperous Long Island and in New York City, The Great Gatsby provides a critical social history of Prohibition-era America during the Jazz Age. F. Scott Fitzgerald\'s masterpiece is a classic tale of impossible love, dreams, and the decline of the American Dream.',
    'features': [
      'Premium paper quality',
      'Classic cover design',
      'Introduction by literary scholar',
      'Bibliography included',
    ],
    'inStock': true,
    'stockCount': 15,
  };

  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Sarah Johnson',
      'rating': 5.0,
      'date': '2024-08-10',
      'comment':
          'Absolutely brilliant! Fitzgerald\'s writing is mesmerizing and the story is timeless.',
      'helpful': 12,
      'images': [
        'https://example.com/review1_image1.jpg',
        'https://example.com/review1_image2.jpg',
        'https://example.com/review1_image2.jpg',
        'https://example.com/review1_image2.jpg',
        'https://example.com/review1_image2.jpg',
      ],
    },
    {
      'name': 'Mike Chen',
      'rating': 4.0,
      'date': '2024-08-08',
      'comment':
          'A classic that lives up to its reputation. Great character development and beautiful prose.',
      'helpful': 8,
      'images': ['https://example.com/review2_image1.jpg'],
    },
    {
      'name': 'Emily Davis',
      'rating': 5.0,
      'date': '2024-08-05',
      'comment':
          'One of my favorite books ever! The symbolism and themes are incredible.',
      'helpful': 15,
      'images': [],
    },
  ];

  final List<Map<String, dynamic>> relatedBooks = [
    {
      'title': 'To Kill a Mockingbird',
      'author': 'Harper Lee',
      'price': 16.99,
      'rating': 4.8,
    },
    {
      'title': 'Pride and Prejudice',
      'author': 'Jane Austen',
      'price': 14.99,
      'rating': 4.7,
    },
    {'title': '1984', 'author': 'George Orwell', 'price': 15.99, 'rating': 4.9},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && bookData['images'].isNotEmpty) {
        _currentImageIndex =
            (_currentImageIndex + 1) % (bookData['images'].length as int);
        _pageController.animateToPage(
          _currentImageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  String formatReviewCount(int count) {
    if (count >= 1000) {
      double thousands = count / 1000.0;
      return '${thousands.toStringAsFixed(1).replaceAll('.0', '')}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          _buildSliverAppBar(),

          // Book content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book info section
                _buildBookInfoSection(),

                // Action buttons
                _buildActionButtons(),

                // Tab section
                _buildTabSection(),

                // Divider 1
                Container(height: 12, color: Colors.grey[100]),

                // Reviews section
                ReviewSectionWidget(
                  reviews: reviews,
                  bookData: bookData,
                  formatReviewCount: formatReviewCount,
                ),

                // Divider 1
                Container(height: 12, color: Colors.grey[100]),

                // Related books
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: BookSectionWidget(
                    title: 'You Might Also Like',
                    books: relatedBooks,
                  ),
                ),

                // Bottom spacing
                const SizedBox(height: 24), // Space for bottom buttons
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.share, color: AppColors.primary, size: 20),
          ),
          onPressed: () {
            _showShareBottomSheet();
          },
        ),
        IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : AppColors.primary,
              size: 20,
            ),
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Book cover với hiệu ứng carousel
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Book cover carousel
                      SizedBox(
                        width: 220,
                        height: 320,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemCount: bookData['images'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  color: Colors.grey[100],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.menu_book,
                                        size: 80,
                                        color: AppColors.primaryDark,
                                      ),
                                      const SizedBox(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          bookData['title'],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.text,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Image ${index + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Dots indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          bookData['images'].length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImageIndex == index ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  _currentImageIndex == index
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookInfoSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and author
          Text(
            bookData['title'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'by ${bookData['author']}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          // Rating and reviews
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < bookData['rating'].floor()
                        ? Icons.star
                        : index < bookData['rating']
                        ? Icons.star_half
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                '${bookData['rating']} (${formatReviewCount(bookData['reviewCount'])} reviews)',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price section
          Row(
            children: [
              Text(
                '\$${bookData['price'].toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 12),
              if (bookData['originalPrice'] > bookData['price'])
                Text(
                  '\$${bookData['originalPrice'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              if (bookData['discount'] > 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${bookData['discount']}% OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Stock status
          Row(
            children: [
              Icon(
                bookData['inStock'] ? Icons.check_circle : Icons.cancel,
                color: bookData['inStock'] ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                bookData['inStock']
                    ? 'In Stock (${bookData['stockCount']} available)'
                    : 'Out of Stock',
                style: TextStyle(
                  color: bookData['inStock'] ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Quantity selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed:
                      quantity > 1
                          ? () {
                            setState(() {
                              quantity--;
                            });
                          }
                          : null,
                  icon: const Icon(Icons.remove),
                  iconSize: 18,
                ),
                Container(
                  width: 32,
                  alignment: Alignment.center,
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 18,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Add to wishlist button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? 'Added to wishlist!'
                          : 'Removed from wishlist!',
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : AppColors.primary,
              ),
              label: Text(
                'Wishlist',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: 'Description'), Tab(text: 'Details')],
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
          ),
          // Sử dụng kích thước động thay vì chiều cao cố định
          Container(
            constraints: BoxConstraints(
              minHeight: 200,
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [_buildDescriptionTab(), _buildDetailsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookData['description'],
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            ...bookData['features']
                .map<Widget>(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildDetailRow('Publisher', bookData['publisher']),
            _buildDetailRow('Publication Date', bookData['publishDate']),
            _buildDetailRow('Pages', '${bookData['pages']} pages'),
            _buildDetailRow('Language', bookData['language']),
            _buildDetailRow('ISBN', bookData['isbn']),
            _buildDetailRow('Category', bookData['category']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: AppColors.text)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Add to cart button
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Buy now button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Buy Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Share Product',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Section 1: Social Media
              const Text(
                'Share to social media',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _socialMediaOptions.length,
                  itemBuilder: (context, index) {
                    final option = _socialMediaOptions[index];
                    return Container(
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 12,
                        right: index == _socialMediaOptions.length - 1 ? 0 : 0,
                      ),
                      child: _buildSocialMediaOption(
                        option['title'],
                        option['icon'],
                        option['color'],
                        () => _shareTo(option['platform']),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Divider
              Container(height: 1, color: Colors.grey[200]),

              const SizedBox(height: 20),

              // Section 2: User Share Options
              const Text(
                'More options',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),

              _buildUserShareOption(
                Icons.copy_rounded,
                'Copy Link',
                'Copy product link to clipboard',
                () => _copyLink(),
              ),
              _buildUserShareOption(
                Icons.save_alt_rounded,
                'Save Image',
                'Save product image to gallery',
                () => _saveImage(),
              ),
              _buildUserShareOption(
                Icons.more_horiz_rounded,
                'More Options',
                'View more sharing options',
                () => _showMoreOptions(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialMediaOption(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70, // Fixed width for consistent spacing
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserShareOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.grey[700], size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _shareTo(String platform) {
    Navigator.pop(context);
    _showMessage('Sharing via $platform...');
  }

  void _copyLink() {
    Navigator.pop(context);
    _showMessage('Product link copied to clipboard');
  }

  void _saveImage() {
    Navigator.pop(context);
    _showMessage('Saving product image...');
  }

  void _showMoreOptions() {
    Navigator.pop(context);
    _showMessage('Opening more sharing options...');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
