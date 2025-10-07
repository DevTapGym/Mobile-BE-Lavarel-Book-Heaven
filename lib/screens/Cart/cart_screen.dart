import 'package:flutter/material.dart';
import 'package:heaven_book_app/themes/app_colors.dart';
import 'package:heaven_book_app/widgets/custom_circle_checkbox.dart';
import 'package:intl/intl.dart'; // Thêm import cho intl

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Định dạng số với dấu chấm ngăn cách 3 số
  final NumberFormat _currencyFormat = NumberFormat('#,##0', 'vi_VN');
  bool isEditMode = false;

  // Sample data for cart items
  final List<Map<String, dynamic>> cartItems = [
    {
      'title': 'The Little Prince',
      'author': 'Antoine de Saint-Exupéry',
      'price': 120000,
      'originalPrice': 140000,
      'discount': '10%',
      'inStock': 23,
      'isSelected': false,
      'quantity': 1,
    },
    {
      'title': 'Hooked',
      'author': 'Nir Eyal',
      'price': 225000,
      'originalPrice': 250000,
      'discount': '10%',
      'inStock': 13,
      'isSelected': false,
      'quantity': 1,
    },
  ];

  // Sample data for recommended items
  final List<Map<String, dynamic>> recommendedItems = [
    {
      'title': 'Harry Potter',
      'author': 'J.K. Rowling',
      'price': 225000,
      'originalPrice': 250000,
      'discount': '-10%',
      'rating': 4.8,
      'sold': 120,
    },
    {
      'title': 'Tứ Trí Đăng Giai Rắc Nhiêu',
      'author': 'Nguyễn Nhật Ánh',
      'price': 225000,
      'originalPrice': 250000,
      'discount': '-10%',
      'rating': 4.5,
      'sold': 56,
    },
    {
      'title': 'Dune',
      'author': 'Frank Herbert',
      'price': 180000,
      'originalPrice': 210000,
      'discount': '-15%',
      'rating': 4.7,
      'sold': 80,
    },
    {
      'title': 'The Great Gatsby',
      'author': 'F. Scott Fitzgerald',
      'price': 150000,
      'originalPrice': 170000,
      'discount': '-12%',
      'rating': 4.6,
      'sold': 42,
    },
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'price': 200000,
      'originalPrice': 230000,
      'discount': '-13%',
      'rating': 4.9,
      'sold': 200,
    },
    {
      'title': 'Clean Code',
      'author': 'Robert C. Martin',
      'price': 300000,
      'originalPrice': 350000,
      'discount': '-14%',
      'rating': 4.8,
      'sold': 150,
    },
  ];

  // Calculate total price of selected items
  double _calculateTotalPrice() {
    return cartItems.fold<double>(0, (sum, item) {
      if (item['isSelected'] == true) {
        return sum + (item['price'] as num) * (item['quantity'] as num);
      }
      return sum;
    });
  }

  // Calculate total savings
  double _calculateTotalSavings() {
    return cartItems.fold<double>(0, (sum, item) {
      if (item['isSelected'] == true) {
        return sum +
            ((item['originalPrice'] as num) - (item['price'] as num)) *
                (item['quantity'] as num);
      }
      return sum;
    });
  }

  void _addToWishlist() {
    //final selectedItems = cartItems.where((item) => item['isSelected'] == true).toList();
  }

  void _removeSelectedItems() {
    setState(() {
      cartItems.removeWhere((item) => item['isSelected'] == true);
    });
  }

  // Show total price popup using BottomSheet
  void _showTotalPricePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 48),
                  Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              // Main title
              Divider(),
              SizedBox(height: 4),
              // Subtitle
              Center(
                child: Text(
                  'Please review your order before checkout',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ),
              SizedBox(height: 18),
              // Order summary details
              _buildSummaryRow('Subtotal', '510.000 đ'),
              _buildSummaryRow('Shipping', '30.000 đ'),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'Discounts:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: _buildSummaryRow('• Product Voucher', '-30.000 đ'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: _buildSummaryRow('• Shipping Voucher', '-30.000 đ'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: _buildSummaryRow('• Member Discount', '-20.000 đ'),
              ),
              Divider(),
              _buildSummaryRow('Total Discounts', '-80.000 đ', isBold: true),
              _buildSummaryRow('Final amount', '460.000 đ', isBold: true),
              SizedBox(height: 18),
              // Checkout button
              Container(
                margin: EdgeInsets.only(bottom: 32),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle checkout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Check out',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
              color: isBold ? AppColors.primaryDark : AppColors.black70,
              fontSize: isBold ? 17 : 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? AppColors.primaryDark : AppColors.black70,
              fontSize: isBold ? 16 : 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          'Shopping Cart (${cartItems.length})',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text(
              isEditMode ? 'Done' : 'Edit',
              style: TextStyle(color: AppColors.black70, fontSize: 16),
            ),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.background),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCartItemsSection(),
              _buildRecommendedHeader(),
              _buildRecommendedItemsGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Widget for the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    final hasSelected = cartItems.any((item) => item['isSelected'] == true);
    return Container(
      width: double.infinity,
      height: 100,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: [
              CustomCircleCheckbox(
                value: cartItems.every((item) => item['isSelected'] == true),
                onChanged: (value) {
                  setState(() {
                    for (var item in cartItems) {
                      item['isSelected'] = value;
                    }
                  });
                },
              ),
              SizedBox(width: 8),
              Text(
                'All',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Spacer(),
          if (!isEditMode) ...[
            GestureDetector(
              onTap: hasSelected ? () => _showTotalPricePopup(context) : null,
              child: Opacity(
                opacity: hasSelected ? 1.0 : 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${_currencyFormat.format(_calculateTotalPrice())} đ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primaryDark,
                        ),
                      ],
                    ),
                    Text(
                      'Save ${_currencyFormat.format(_calculateTotalSavings())} đ',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              width: 140,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  if (hasSelected) {
                    Navigator.pushNamed(context, '/check-out');
                  }
                },
                child: Text(
                  'Check out (${cartItems.where((item) => item['isSelected'] == true).length})',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color:
                    hasSelected
                        ? AppColors.primaryDark
                        : AppColors.primaryDark.withAlpha(125),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: hasSelected ? _addToWishlist : null,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledForegroundColor: Colors.white70,
                ),
                child: Text(
                  'Add to Wish List',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color:
                    hasSelected
                        ? AppColors.discountRed
                        : AppColors.discountRed.withAlpha(125),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: hasSelected ? _removeSelectedItems : null,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledForegroundColor: Colors.white70,
                ),
                child: Text(
                  'Remove',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget for the cart items section
  Widget _buildCartItemsSection() {
    return Column(
      children: cartItems.map((item) => _buildCartItem(item)).toList(),
    );
  }

  // Widget for a single cart item
  Widget _buildCartItem(Map<String, dynamic> item) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, top: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 16),
            CustomCircleCheckbox(
              value: item['isSelected'] ?? false,
              onChanged: (value) {
                setState(() {
                  item['isSelected'] = value;
                });
              },
            ),
            SizedBox(width: 10),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: 100,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.book, size: 40, color: Colors.grey[600]),
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: SizedBox(
                height: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          item['author']!,
                          style: TextStyle(color: Colors.black54, fontSize: 15),
                        ),
                        Text(
                          '${_currencyFormat.format(item['price'])} đ',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${_currencyFormat.format(item['originalPrice'])} đ',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.grey,
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.discountRed,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                item['discount']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'In stock: ${item['inStock']}',
                          style: TextStyle(
                            color: AppColors.black70,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                          height: 32,
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black54,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.remove, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      if (item['quantity'] > 1) {
                                        item['quantity']--;
                                      }
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  '${item['quantity']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.add, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      if (item['quantity'] < item['inStock']) {
                                        item['quantity']++;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 50),
            Container(
              width: 100,
              height: 192,
              decoration: BoxDecoration(
                color: AppColors.discountRed,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.white, size: 38),
                onPressed: () {
                  setState(() {
                    cartItems.remove(item);
                  });
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the recommended items header
  Widget _buildRecommendedHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        children: [
          Expanded(child: Container(height: 2, color: AppColors.black60)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'You Might Also Like',
              style: TextStyle(
                color: AppColors.black60,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Container(height: 2, color: AppColors.black60)),
        ],
      ),
    );
  }

  // Widget for the recommended items grid
  Widget _buildRecommendedItemsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.55,
        ),
        itemCount: recommendedItems.length > 6 ? 6 : recommendedItems.length,
        itemBuilder:
            (context, index) => _buildRecommendedItem(recommendedItems[index]),
      ),
    );
  }

  // Widget for a single recommended item
  Widget _buildRecommendedItem(Map<String, dynamic> book) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 180,
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
              if (book['discount'] != null && book['discount'] != '')
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
                      book['discount'],
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
                    book['author'] != null ? 'by ${book['author']}' : '',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        book['rating'] != null
                            ? book['rating'].toString()
                            : '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black70,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(
                        width: 12,
                        height: 16,
                        child: VerticalDivider(
                          color: AppColors.black70,
                          thickness: 1.5,
                        ),
                      ),
                      Text(
                        book['sold'] != null ? '${book['sold']} sold' : '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${_currencyFormat.format(book['price'])} đ',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
