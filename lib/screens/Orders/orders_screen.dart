import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaven_book_app/bloc/order/order_bloc.dart';
import 'package:heaven_book_app/bloc/order/order_event.dart';
import 'package:heaven_book_app/bloc/order/order_state.dart';
import 'package:heaven_book_app/model/order.dart';
import 'package:heaven_book_app/model/order_item.dart';
import 'package:heaven_book_app/themes/format_price.dart';
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
  List<Order> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _filteredOrders = [];

    // Load orders when screen initializes
    context.read<OrderBloc>().add(LoadAllOrders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> getOrdersByStatus(String status) {
    return _filteredOrders.where((order) {
      if (order.statusHistory.isEmpty) return false;
      // Lấy trạng thái mới nhất
      final latestStatus = order.statusHistory.last.name.toLowerCase();
      return latestStatus == status.toLowerCase();
    }).toList();
  }

  List<Order> _getOrdersForTab(String tab) {
    switch (tab) {
      case 'Pending':
        return getOrdersByStatus('Pending');
      case 'Processing':
        return getOrdersByStatus('Processing');
      case 'Shipping':
        return getOrdersByStatus('Shipped');
      case 'Delivered':
        return getOrdersByStatus('Delivered');
      case 'Canceled':
        return getOrdersByStatus('Cancelled');
      case 'Returned':
        return getOrdersByStatus('Returned');
      default:
        return _filteredOrders;
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
      debugPrint('❌ No date range selected');
      return;
    }

    debugPrint('🔍 Filtering orders by date range:');
    debugPrint(
      '  📅 Start: ${_selectedDateRange!.start.toString().split(' ')[0]}',
    );
    debugPrint('  📅 End: ${_selectedDateRange!.end.toString().split(' ')[0]}');

    // Trigger rebuild to apply the filter
    // The actual filtering logic is handled in _applyDateFilter method
    // which is called from BlocBuilder when state changes
    setState(() {
      // This will cause the UI to rebuild and _applyDateFilter will be called
      debugPrint('🔄 Triggering UI rebuild with date filter...');
    });

    debugPrint('✅ Date filter applied successfully');
  }

  List<Order> _applyDateFilter(List<Order> orders) {
    if (_selectedDateRange == null) {
      debugPrint('📋 No date filter - returning all ${orders.length} orders');
      return orders;
    }

    // Normalize dates to start and end of day for accurate comparison
    final startDate = DateTime(
      _selectedDateRange!.start.year,
      _selectedDateRange!.start.month,
      _selectedDateRange!.start.day,
    );

    final endDate = DateTime(
      _selectedDateRange!.end.year,
      _selectedDateRange!.end.month,
      _selectedDateRange!.end.day,
      23,
      59,
      59,
      999, // End of day
    );

    debugPrint('📅 Applying date filter:');
    debugPrint('  🟢 Start: ${startDate.toString().split(' ')[0]}');
    debugPrint('  🔴 End: ${endDate.toString().split(' ')[0]}');
    debugPrint('  📊 Total orders to filter: ${orders.length}');

    final filteredOrders =
        orders.where((order) {
          // Normalize order date to start of day for comparison
          final orderDateOnly = DateTime(
            order.orderDate.year,
            order.orderDate.month,
            order.orderDate.day,
          );

          final isInRange =
              orderDateOnly.isAtSameMomentAs(startDate) ||
              orderDateOnly.isAtSameMomentAs(endDate) ||
              (orderDateOnly.isAfter(startDate) &&
                  orderDateOnly.isBefore(endDate));

          if (isInRange) {
            debugPrint(
              '  ✅ Order ${order.orderNumber} - ${orderDateOnly.toString().split(' ')[0]} (included)',
            );
          } else {
            debugPrint(
              '  ❌ Order ${order.orderNumber} - ${orderDateOnly.toString().split(' ')[0]} (excluded)',
            );
          }

          return isInRange;
        }).toList();

    debugPrint(
      '📈 Filter result: ${filteredOrders.length}/${orders.length} orders match criteria',
    );
    return filteredOrders;
  }

  void _clearDateFilter() {
    debugPrint('🗑️ Clearing date filter...');
    setState(() {
      _selectedDateRange = null;
    });
    debugPrint('✅ Date filter cleared - showing all orders');
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
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderError) {
            return Center(
              child: Text(
                'Error loading orders: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is OrderLoaded) {
            _filteredOrders =
                _selectedDateRange != null
                    ? _applyDateFilter(state.orders)
                    : state.orders;
          }

          return Container(
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
                      const Tab(
                        child: Text('All', style: TextStyle(fontSize: 16)),
                      ),
                      const Tab(
                        child: Text('Pending', style: TextStyle(fontSize: 16)),
                      ),
                      const Tab(
                        child: Text(
                          'Processing',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const Tab(
                        child: Text('Shipping', style: TextStyle(fontSize: 16)),
                      ),
                      const Tab(
                        child: Text(
                          'Delivered',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const Tab(
                        child: Text('Canceled', style: TextStyle(fontSize: 16)),
                      ),
                      const Tab(
                        child: Text('Returned', style: TextStyle(fontSize: 16)),
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
                      _buildOrderList(_getOrdersForTab('Pending')),
                      _buildOrderList(_getOrdersForTab('Processing')),
                      _buildOrderList(_getOrdersForTab('Shipping')),
                      _buildOrderList(_getOrdersForTab('Delivered')),
                      _buildOrderList(_getOrdersForTab('Canceled')),
                      _buildOrderList(_getOrdersForTab('Returned')),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
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
                onPressed: () {
                  Navigator.pushNamed(context, '/main');
                },
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

  Widget _buildOrderCard(Order order) {
    final isExpanded = expandedOrders.contains(order.orderNumber);
    final itemsToShow = isExpanded ? order.items : [order.items.first];

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
                  'Order ${order.orderNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order.statusHistory.last.name),
              ],
            ),
            Text(
              'Date: ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year} at ${order.orderDate.hour}:${order.orderDate.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            ...itemsToShow.map<Widget>((item) => _buildOrderItem(item)),

            // Show More/Less button if more than 1 item
            if (order.items.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        expandedOrders.remove(order.orderNumber);
                      } else {
                        expandedOrders.add(order.orderNumber);
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
                            : 'Show More (${order.items.length - 1} more items)',
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
                  FormatPrice.formatPrice(order.totalAmount),
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
                        arguments: {'orderId': order.id},
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (order.statusHistory.last.name == 'Delivered')
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
                if (order.statusHistory.last.name == 'Processing')
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

  Widget _buildOrderItem(OrderItem item) {
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
                  item.bookTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity} x ${FormatPrice.formatPrice(item.unitPrice)}',
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
      case 'Pending':
      case 'Processing':
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
