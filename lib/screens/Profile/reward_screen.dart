import 'package:flutter/material.dart';
import 'package:heaven_book_app/themes/app_colors.dart';
import 'package:heaven_book_app/widgets/voucher_card_widget.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
              weight: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Rewards',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: const [Tab(text: 'Member'), Tab(text: 'Voucher')],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: TabBarView(children: [MemberTab(), VoucherTab()]),
      ),
    );
  }
}

// Widget cho tab Member
class MemberTab extends StatelessWidget {
  const MemberTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildMemberCard(),
            SizedBox(height: 16.0),
            _buildMemberBenefits(),
            SizedBox(height: 16.0),
            _buildMemberVouchers(),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

// Widget cho tab Voucher
class VoucherTab extends StatelessWidget {
  const VoucherTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildVoucherSection(
              context,
              title: 'Expiring soon',
              vouchers: [
                VoucherCardWidget(
                  title: 'Save up to 20k',
                  minimumOrder: '80k',
                  points: 2000,
                  validUntil: '12-12-2015',
                  type: 'Free Shipping',
                  showRedeemButton: false,
                  onTap: () => _showVoucherDetails(context),
                ),
                VoucherCardWidget(
                  title: 'Save up to 20k',
                  minimumOrder: '80k',
                  points: 2000,
                  validUntil: '12-12-2015',
                  type: 'Free Shipping',
                  showRedeemButton: false,
                  onTap: () {
                    Navigator.pushNamed(context, '/detail-voucher');
                  },
                ),
                VoucherCardWidget(
                  title: 'Save up to 20k',
                  minimumOrder: '80k',
                  points: 2000,
                  validUntil: '12-12-2015',
                  type: 'Free Shipping',
                  showRedeemButton: false,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _buildVoucherSection(
              context,
              title: 'Free shipping',
              vouchers: [
                VoucherCardWidget(
                  title: 'Save up to 20k',
                  minimumOrder: '80k',
                  points: 2000,
                  validUntil: '12-12-2015',
                  type: 'Free Shipping',
                  showRedeemButton: false,
                ),
                VoucherCardWidget(
                  title: 'Save up to 20k',
                  minimumOrder: '80k',
                  points: 2000,
                  validUntil: '12-12-2015',
                  type: 'Free Shipping',
                  showRedeemButton: false,
                ),
                VoucherCardWidget(
                  title: 'Save up to 20k',
                  minimumOrder: '80k',
                  points: 2000,
                  validUntil: '12-12-2015',
                  type: 'Free Shipping',
                  showRedeemButton: false,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _buildVoucherSection(
              context,
              title: 'Discount vouchers',
              vouchers: [
                VoucherCardWidget(
                  title: 'Save up to 20k',
                  minimumOrder: '80k',
                  points: 2000,
                  validUntil: '12-12-2015',
                  type: 'Free Shipping',
                  showRedeemButton: false,
                ),
                VoucherCardWidget(
                  title: 'Save up to 20k',
                  minimumOrder: '80k',
                  points: 2000,
                  validUntil: '12-12-2015',
                  type: 'Free Shipping',
                  showRedeemButton: false,
                ),
                VoucherCardWidget(
                  title: 'Save up to 20k',
                  minimumOrder: '80k',
                  points: 2000,
                  validUntil: '12-12-2015',
                  type: 'Free Shipping',
                  showRedeemButton: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherSection(
    BuildContext context, {
    required String title,
    required List<Widget> vouchers,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Container(height: 2, color: AppColors.text)),
          ],
        ),
        SizedBox(height: 8.0),
        ...vouchers,
      ],
    );
  }

  void _showVoucherDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text('Voucher Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title: Save up to 20k'),
              Text('Minimum Order: 80k'),
              Text('Points Required: 2000'),
              Text('Valid Until: 12-12-2015'),
              Text('Type: Free Shipping'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildMemberCard() {
  return Container(
    padding: EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0, bottom: 30.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18.0),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFA500), Color(0xFFFFD700)],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GOLD',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 2.0,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        Text(
          'Huỳnh Công Tiến',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                offset: Offset(0, 0),
                blurRadius: 12.0,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          padding: EdgeInsets.only(top: 12.0, left: 8, right: 8, bottom: 14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2.0,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maintenance conditions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  // Phần Order
                  SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Text(
                              '12',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Text('/10'),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        LinearProgressIndicator(
                          value: 1.0,
                          borderRadius: BorderRadius.circular(4.0),
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryDark,
                          ),
                          minHeight: 6.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 72.0,
                    width: 2.0,
                    color: Colors.black26,
                    margin: EdgeInsets.symmetric(horizontal: 12.0),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spending',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Text(
                              '1,200,000 đ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Text('/2,000,000 đ'),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        LinearProgressIndicator(
                          value: 1200000 / 2000000,
                          borderRadius: BorderRadius.circular(4.0),
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryDark,
                          ),
                          minHeight: 6.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.0),
              Text(
                'Ranking will be updated after 12-31-2025',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildMemberBenefits() {
  return Container(
    margin: EdgeInsets.all(12),
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 12.0,
          spreadRadius: 2.0,
          offset: Offset(0, 0),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primaryDark, size: 28.0),
            SizedBox(width: 8.0),
            Text(
              'Membership benefits',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          '- Free shipping over 200k',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        SizedBox(height: 4.0),
        Text(
          '- 10% off orders above 200k',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        SizedBox(height: 4.0),
        Text(
          '- 30% off on birthday',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ],
    ),
  );
}

Widget _buildMemberVouchers() {
  return Column(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Points Redemption',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: Container(height: 2, color: AppColors.text)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.stars_rounded, color: AppColors.primaryDark),
              SizedBox(width: 4),
              Text(
                '2000',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 8.0),
      VoucherCardWidget(
        title: 'Save up to 20k',
        minimumOrder: '80k',
        points: 2000,
        validUntil: '12-12-2015',
        type: 'Free Shipping',
      ),
      VoucherCardWidget(
        title: 'Save up to 20k',
        minimumOrder: '80k',
        points: 2000,
        validUntil: '12-12-2015',
        type: 'Free Shipping',
      ),
      VoucherCardWidget(
        title: 'Save up to 20k',
        minimumOrder: '80k',
        points: 2000,
        validUntil: '12-12-2015',
        type: 'Free Shipping',
      ),
    ],
  );
}
