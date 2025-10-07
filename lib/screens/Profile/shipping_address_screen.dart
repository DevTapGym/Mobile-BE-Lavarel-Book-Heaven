import 'package:flutter/material.dart';
import 'package:heaven_book_app/themes/app_colors.dart';
import 'package:heaven_book_app/widgets/address_card_widget.dart';
import 'package:heaven_book_app/widgets/appbar_custom_widget.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  // Fake data array
  List<Map<String, dynamic>> addresses = [
    {
      'title': 'Home',
      'name': 'Huỳnh Công Tiến',
      'phone': '0966098786',
      'address':
          '72/52 Đường Dương Đình Hội, Phường Tậy Thạnh, Quận Tân Phú, TP. Hồ Chí Minh',
      'isDefault': true,
    },
    {
      'title': 'School',
      'name': 'Huỳnh Văn Tuấn',
      'phone': '096752124',
      'address':
          '72/52 Đường Dương Đình Hội, Phường Tậy Thạnh, Quận Tân Phú, TP. Hồ Chí Minh',
      'isDefault': false,
    },
    {
      'title': 'Office',
      'name': 'Huỳnh Công Tiến',
      'phone': '096947174',
      'address':
          '72/52 Đường Dương Đình Hội, Phường Tậy Thạnh, Quận Tân Phú, TP. Hồ Chí Minh',
      'isDefault': false,
    },
  ];

  // Controllers for edit dialog
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _showEditDialog(int index) {
    // Set initial values for controllers
    _titleController.text = addresses[index]['title'];
    _nameController.text = addresses[index]['name'];
    _phoneController.text = addresses[index]['phone'];
    _addressController.text = addresses[index]['address'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Address'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    addresses[index] = {
                      'title': _titleController.text,
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'address': _addressController.text,
                      'isDefault': addresses[index]['isDefault'],
                    };
                  });
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Delete Address',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            backgroundColor: Colors.white,
            content: Text(
              'Are you sure you want to delete this address?',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.primaryDark),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    addresses.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustomWidget(title: 'Shipping Address'),
      body: Container(
        color: AppColors.background,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(height: 10.0),
                  AddressCardWidget(
                    title: addresses[index]['title'],
                    name: addresses[index]['name'],
                    phone: addresses[index]['phone'],
                    address: addresses[index]['address'],
                    isDefault: addresses[index]['isDefault'],
                    onEdit: () => _showEditDialog(index),
                    onDelete: () => _showDeleteDialog(index),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 360,
            margin: EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-address');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: AppColors.primaryDark,
              ),
              child: Text(
                'Add Address',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
