import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaven_book_app/bloc/order/order_bloc.dart';
import 'package:heaven_book_app/bloc/order/order_event.dart';
import 'package:heaven_book_app/bloc/order/order_state.dart';
import 'package:heaven_book_app/themes/app_colors.dart';
import 'package:heaven_book_app/widgets/appbar_custom_widget.dart';

class DetailOrderScreen extends StatefulWidget {
  const DetailOrderScreen({super.key});

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;

      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        final orderId = args['orderId'];
        context.read<OrderBloc>().add(LoadDetailOrder(orderId: orderId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustomWidget(title: 'Order Details'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.background],
            stops: [0.3, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    if (state is OrderLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OrderDetailLoaded) {
                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 20, 14, 4),
                              child: _statusSection(),
                            ),
                            Container(
                              height: 6,
                              width: double.infinity,
                              color: AppColors.background,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: _shippingAddressSection(),
                            ),
                            Container(
                              height: 6,
                              width: double.infinity,
                              color: AppColors.background,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: _itemsSection(),
                            ),
                            Container(
                              height: 6,
                              width: double.infinity,
                              color: AppColors.background,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: _orderSummarySection(),
                            ),
                            Container(
                              height: 6,
                              width: double.infinity,
                              color: AppColors.background,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: _orderDetailsSection(),
                            ),
                          ],
                        ),
                      );
                    } else if (state is OrderError) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('No order details available.'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _statusSection() {
    final List<Map<String, dynamic>> statusHistory = [
      {'status': 'Delivered', 'time': '13:00 07-12-2024'},
      {'status': 'Shipping', 'time': '08:00 05-12-2024'},
      {'status': 'Processing', 'time': '18:15 04-12-2024'},
    ];
    bool showAll = false;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Order:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Timeline card
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: Column(
                children: [
                  // show either single latest or full timeline
                  if (!showAll) ...[
                    Row(
                      children: [
                        // dot
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                statusHistory.first['status'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                statusHistory.first['time'],
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Column(
                      children:
                          statusHistory.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            final isLast = idx == statusHistory.length - 1;
                            Color dotColor = Colors.black54;
                            if ((item['status'] as String).toLowerCase() ==
                                'delivered') {
                              dotColor = Colors.green;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 28,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: dotColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        if (!isLast)
                                          Container(
                                            width: 2,
                                            height: 50,
                                            color: Colors.black54,
                                            margin: const EdgeInsets.only(
                                              top: 6,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['status'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['time'],
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ],

                  // show more/less button
                  const SizedBox(height: 4),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => setState(() => showAll = !showAll),
                      icon: Icon(
                        showAll ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.primary,
                      ),
                      label: Text(
                        showAll ? 'Show less' : 'Show more',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _shippingAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping address:',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Home',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '72/34, Đường Đức Hiền, Tây Thạnh, Tân Phú\nHuyện Hồng Tiến - 073713371',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemsSection() {
    return Column(
      children: [
        _buildOrderItem(
          title: 'A Brief History of Humankind',
          author: 'Yuval Noah Harari',
          price: 360000,
          quantity: 1,
          checkOnDelivery: true,
          freeBookmark: false,
        ),
        _buildOrderItem(
          title: 'Tuổi Trẻ Đáng Giá Bao Nhiêu',
          author: 'Rosie Nguyễn',
          price: 75000,
          quantity: 2,
          checkOnDelivery: true,
          freeBookmark: true,
        ),
      ],
    );
  }

  Widget _orderSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order summary',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildSummaryRow('Subtotal', '510,000 đ'),
        _buildSummaryRow('Shipping', '30,000 đ'),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            'Discounts:',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: _buildSummaryRow('• Product Voucher', '-30,000 đ'),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: _buildSummaryRow('• Shipping Voucher', '-30,000 đ'),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: _buildSummaryRow('• Member Discount', '-20,000 đ'),
        ),
        const Divider(),
        _buildSummaryRow('Total', '460,000 đ', isBold: true),
      ],
    );
  }

  Widget _orderDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order details',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Column(
            children: [
              _buildDetailRow('Order number', 'ORD-TI00904001'),
              _buildDetailRow('Order date', '12/12/2024 14:05'),
              _buildDetailRow('Payment Method', 'COD'),
              _buildDetailRow('Payment time', '16/12/2024 16:30'),
              _buildDetailRow('Delivery time', '16/12/2024 16:30'),
            ],
          ),
        ),

        Center(
          child: TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Export Receipt',
                  style: TextStyle(color: AppColors.primaryDark),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, color: AppColors.primaryDark),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem({
    required String title,
    required String author,
    required int price,
    required int quantity,
    required bool checkOnDelivery,
    required bool freeBookmark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.hardEdge,
              child: const Icon(Icons.book, size: 40),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(author, style: TextStyle(color: Colors.black54)),
                        const SizedBox(height: 8),
                        if (freeBookmark) const Text('• Free Bookmark'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${price.toString()} đ x $quantity'),
                        const Spacer(),
                        Text(
                          '${price * quantity} đ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppColors.primaryDark : Colors.black54,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppColors.primaryDark : Colors.black54,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 15),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black54, fontSize: 15),
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
                label: Text(
                  'Review',
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
                  'Buy Again',
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
}
