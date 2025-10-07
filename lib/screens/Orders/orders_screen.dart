import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Track which orders have expanded items view
  Set<String> expandedOrders = {};

  // Date range filter variables
  DateTimeRange? _selectedDateRange;
  List<Map<String, dynamic>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _filteredOrders = List.from(allOrders);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Hardcoded order data
  final List<Map<String, dynamic>> allOrders = [
    {
      'id': 'ORD-001',
      'status': 'Processing',
      'date': '2024-08-10',
      'total': 45.99,
      'items': [
        {'title': 'The Great Gatsby', 'price': 12.99, 'quantity': 1},
        {'title': 'To Kill a Mockingbird', 'price': 15.99, 'quantity': 1},
        {'title': '1984', 'price': 17.01, 'quantity': 1},
      ],
    },
    {
      'id': 'ORD-003',
      'status': 'Delivered',
      'date': '2024-08-05',
      'total': 28.97,
      'items': [
        {'title': 'Pride and Prejudice', 'price': 13.99, 'quantity': 1},
        {'title': 'The Catcher in the Rye', 'price': 14.98, 'quantity': 1},
      ],
    },
    {
      'id': 'ORD-004',
      'status': 'Cancelled',
      'date': '2024-08-03',
      'total': 19.99,
      'items': [
        {'title': 'Lord of the Flies', 'price': 19.99, 'quantity': 1},
      ],
    },
    {
      'id': 'ORD-005',
      'status': 'Delivered',
      'date': '2024-08-01',
      'total': 67.95,
      'items': [
        {'title': 'Dune', 'price': 22.99, 'quantity': 1},
        {'title': 'Foundation', 'price': 21.99, 'quantity': 1},
        {'title': 'Ender\'s Game', 'price': 22.97, 'quantity': 1},
      ],
    },
  ];

  List<Map<String, dynamic>> getOrdersByStatus(String status) {
    final ordersToFilter =
        _selectedDateRange != null ? _filteredOrders : allOrders;
    return ordersToFilter.where((order) => order['status'] == status).toList();
  }

  List<Map<String, dynamic>> _getOrdersForTab(String tab) {
    switch (tab) {
      case 'Shipping':
        return getOrdersByStatus('Shipped');
      case 'Delivered':
        return getOrdersByStatus('Delivered');
      case 'Canceled':
        final ordersToFilter =
            _selectedDateRange != null ? _filteredOrders : allOrders;
        return ordersToFilter
            .where(
              (order) =>
                  (order['status'] as String).toLowerCase() == 'canceled' ||
                  (order['status'] as String).toLowerCase() == 'cancelled',
            )
            .toList();
      case 'Return':
        return getOrdersByStatus('Return');
      default:
        return _selectedDateRange != null ? _filteredOrders : allOrders;
    }
  }

  void _showDateRangeFilter() async {
    DateTime? tempStartDate = _selectedDateRange?.start;
    DateTime? tempEndDate = _selectedDateRange?.end;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 450,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Filter Orders by Date Range',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Date selection buttons
                    Row(
                      children: [
                        // Start Date Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: tempStartDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: tempEndDate ?? DateTime.now(),
                                helpText: 'Select Start Date',
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: AppColors.primary,
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Colors.black87,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setDialogState(() {
                                  tempStartDate = picked;
                                  // If end date is before start date, reset it
                                  if (tempEndDate != null &&
                                      tempEndDate!.isBefore(picked)) {
                                    tempEndDate = null;
                                  }
                                });
                              }
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              color:
                                  tempStartDate != null
                                      ? AppColors.primary
                                      : Colors.grey[600],
                              size: 18,
                            ),
                            label: Text(
                              tempStartDate != null
                                  ? '${tempStartDate!.day}/${tempStartDate!.month}/${tempStartDate!.year}'
                                  : 'Start Date',
                              style: TextStyle(
                                color:
                                    tempStartDate != null
                                        ? AppColors.primary
                                        : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color:
                                    tempStartDate != null
                                        ? AppColors.primary
                                        : Colors.grey[400]!,
                                width: 1.5,
                              ),
                              backgroundColor:
                                  tempStartDate != null
                                      ? AppColors.primary.withValues(
                                        alpha: 0.05,
                                      )
                                      : null,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // To text
                        Text(
                          'to',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // End Date Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed:
                                tempStartDate != null
                                    ? () async {
                                      final DateTime?
                                      picked = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            tempEndDate ?? tempStartDate!,
                                        firstDate: tempStartDate!,
                                        lastDate: DateTime.now(),
                                        helpText: 'Select End Date',
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: AppColors.primary,
                                                onPrimary: Colors.white,
                                                surface: Colors.white,
                                                onSurface: Colors.black87,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (picked != null) {
                                        setDialogState(() {
                                          tempEndDate = picked;
                                        });
                                      }
                                    }
                                    : null,
                            icon: Icon(
                              Icons.calendar_today,
                              color:
                                  tempEndDate != null
                                      ? AppColors.primary
                                      : Colors.grey[400],
                              size: 18,
                            ),
                            label: Text(
                              tempEndDate != null
                                  ? '${tempEndDate!.day}/${tempEndDate!.month}/${tempEndDate!.year}'
                                  : 'End Date',
                              style: TextStyle(
                                color:
                                    tempEndDate != null
                                        ? AppColors.primary
                                        : Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color:
                                    tempEndDate != null
                                        ? AppColors.primary
                                        : Colors.grey[400]!,
                                width: 1.5,
                              ),
                              backgroundColor:
                                  tempEndDate != null
                                      ? AppColors.primary.withValues(
                                        alpha: 0.05,
                                      )
                                      : null,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Current selection display
                    if (tempStartDate != null && tempEndDate != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.event,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Selected Date Range:',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${tempStartDate!.day}/${tempStartDate!.month}/${tempStartDate!.year}',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '  to  ',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${tempEndDate!.day}/${tempEndDate!.month}/${tempEndDate!.year}',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Cancel Button
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Apply Button
                        ElevatedButton(
                          onPressed:
                              (tempStartDate != null && tempEndDate != null)
                                  ? () {
                                    setState(() {
                                      _selectedDateRange = DateTimeRange(
                                        start: tempStartDate!,
                                        end: tempEndDate!,
                                      );
                                      _filterOrdersByDateRange();
                                    });
                                    Navigator.pop(context);
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Apply Filter',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _filterOrdersByDateRange() {
    if (_selectedDateRange == null) {
      _filteredOrders = List.from(allOrders);
      return;
    }

    _filteredOrders =
        allOrders.where((order) {
          final orderDate = DateTime.parse(order['date']);
          return orderDate.isAfter(
                _selectedDateRange!.start.subtract(const Duration(days: 1)),
              ) &&
              orderDate.isBefore(
                _selectedDateRange!.end.add(const Duration(days: 1)),
              );
        }).toList();
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDateRange = null;
      _filteredOrders = List.from(allOrders);
    });
  }

  Widget _buildDateFilterChip() {
    if (_selectedDateRange == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Chip(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.date_range, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        deleteIcon: Icon(Icons.close, size: 16, color: AppColors.primary),
        onDeleted: _clearDateFilter,
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 24,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showDateRangeFilter,
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.date_range,
                color: Colors.white,
                size: 20,
              ),
            ),
            tooltip: 'Filter by date range',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        color: AppColors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: AppColors.primary,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.background,
                labelColor: AppColors.background,
                unselectedLabelColor: Colors.white60,
                isScrollable: true,
                tabs: [
                  const Tab(child: Text('All', style: TextStyle(fontSize: 16))),
                  const Tab(
                    child: Text('Shipping', style: TextStyle(fontSize: 16)),
                  ),
                  const Tab(
                    child: Text('Delivered', style: TextStyle(fontSize: 16)),
                  ),
                  const Tab(
                    child: Text('Canceled', style: TextStyle(fontSize: 16)),
                  ),
                  const Tab(
                    child: Text('Return', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),

            // Date filter chip
            _buildDateFilterChip(),

            // Tab bar view
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(_getOrdersForTab('All')),
                  _buildOrderList(_getOrdersForTab('Shipping')),
                  _buildOrderList(_getOrdersForTab('Delivered')),
                  _buildOrderList(_getOrdersForTab('Canceled')),
                  _buildOrderList(_getOrdersForTab('Return')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Orders Yet',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You haven\'t placed any orders yet.\nStart shopping to see your orders here!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Shop Now!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final isExpanded = expandedOrders.contains(order['id']);
    final items = order['items'] as List;
    final itemsToShow = isExpanded ? items : items.take(1).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ${order['id']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order['status']),
              ],
            ),
            Text(
              'Date: ${order['date']}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // Order Items (show only first item or all items based on expansion)
            ...itemsToShow.map<Widget>((item) => _buildOrderItem(item)),

            // Show More/Less button if more than 1 item
            if (items.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        expandedOrders.remove(order['id']);
                      } else {
                        expandedOrders.add(order['id']);
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isExpanded
                            ? 'Show Less'
                            : 'Show More (${items.length - 1} more items)',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Divider(height: 24),

            // Order Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${order['total'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/detail-order',
                        arguments: order,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (order['status'] == 'Delivered')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Re-order',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (order['status'] == 'Processing')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.book, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item['quantity']} × \$${item['price'].toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Processing':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      case 'Shipped':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        break;
      case 'Delivered':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      case 'Cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
