import 'package:flutter/material.dart';
import 'package:heaven_book_app/themes/app_colors.dart';
import 'package:heaven_book_app/widgets/address_card_widget.dart';
import 'package:heaven_book_app/widgets/appbar_custom_widget.dart';
import 'package:heaven_book_app/widgets/custom_circle_checkbox.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool isChecked = false;

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
              shadows: [
                if (isBold)
                  Shadow(
                    color: Colors.black12,
                    offset: Offset(1, 2),
                    blurRadius: 8,
                  ),
              ],
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

  Widget _buildAddressSection() {
    return AddressCardWidget(
      title: 'Home',
      name: 'John Doe',
      phone: '+1 234 567 890',
      address: '123 Main St, City, Country',
      isDefault: false,
      hasEditButton: false,
      hasDeleteButton: false,
      isTappable: true,
      onTap: () {},
      onEdit: () {},
      onDelete: () {},
    );
  }

  Widget _buildProductItem({
    required String title,
    required String price,
    required String originalPrice,
    required String discount,
    required String quantity,
    String? gift,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 90,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppColors.primaryDark,
              ),
              child: Icon(Icons.image, size: 30, color: Colors.grey[300]),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (gift != null) Text(gift),
                  Text('- Free shipping'),
                  SizedBox(height: 12.0),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        originalPrice,
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
                          discount,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        quantity,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey, height: 32.0),
      ],
    );
  }

  Widget _buildGiftItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.topLeft, child: Text('Free gift:')),
        SizedBox(height: 8.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppColors.primaryDark,
              ),
              child: Icon(Icons.image, size: 20, color: Colors.grey[300]),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trốn Lên Mái Nhà Để Khóc',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Free',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'x1',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 18.0, right: 18.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProductItem(
            title: 'Cho Tôi Xin Một Vé Đi Tuổi Thơ',
            price: '300.000 đ',
            originalPrice: '400.000 đ',
            discount: '-25%',
            quantity: 'x1',
            gift: '- Free bookmark',
          ),
          _buildProductItem(
            title: 'Tuổi Trẻ Đáng Giá Bao Nhiêu',
            price: '100.000 đ',
            originalPrice: '120.000 đ',
            discount: '-25%',
            quantity: 'x1',
            gift: '- Free bookmark',
          ),
          _buildGiftItem(),
        ],
      ),
    );
  }

  Widget _buildDiscountSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 18.0, right: 18.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.discount_rounded,
                    color: AppColors.black60,
                    size: 30,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Discount:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      border: Border.all(
                        color: AppColors.primaryDark,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'Free Ship',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.discountRed.withAlpha(40),
                      border: Border.all(
                        color: AppColors.discountRed,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '-60.000 đ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.discountRed,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primaryDark,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryDark, size: 30),
          SizedBox(width: 8.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: AppColors.black70,
            ),
          ),
          Spacer(),
          CustomCircleCheckbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 18.0, right: 18.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: AppColors.black60, size: 30),
              SizedBox(width: 8.0),
              Text(
                'Payment Method',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          _buildPaymentMethodItem('Momo E-Wallet', Icons.credit_card),
          _buildPaymentMethodItem('Zalo Pay', Icons.credit_card),
          _buildPaymentMethodItem('Cash on Delivery', Icons.credit_card),
          Divider(color: Colors.black54, height: 32.0, thickness: 1.5),
          SizedBox(height: 12.0),
          Row(
            children: [
              Icon(
                Icons.currency_exchange_rounded,
                color: Colors.black,
                size: 30,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 4.0),
                    Text(
                      'View All Options',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 18.0, right: 18.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.price_change, color: AppColors.black60, size: 30),
              SizedBox(width: 8.0),
              Text(
                'Order Summary',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.0),
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
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 160,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 4.0),
              Text(
                '(3 items)',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black70,
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '460.000 đ',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.red,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Save 80.000 đ',
                    style: TextStyle(
                      letterSpacing: -1,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustomWidget(title: 'Order Summary'),
      body: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAddressSection(),
              _buildProductsSection(),
              _buildDiscountSection(),
              _buildPaymentSection(),
              _buildOrderSummarySection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
