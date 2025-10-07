import 'package:flutter/material.dart';
import 'package:heaven_book_app/themes/app_colors.dart';
import 'package:heaven_book_app/widgets/appbar_custom_widget.dart';
import 'package:heaven_book_app/widgets/textfield_custom_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordValid = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasMinLength = false;
  String _passwordStrengthText = 'Weak password';
  Color _progressBarColor = Colors.grey;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;

  void _validatePassword(String value) {
    setState(() {
      _hasUppercase = _newPasswordController.text.contains(RegExp(r'[A-Z]'));
      _hasNumber = _newPasswordController.text.contains(RegExp(r'[0-9]'));
      _hasMinLength = _newPasswordController.text.length >= 8;

      int conditionsMet = 0;
      if (_hasUppercase) conditionsMet++;
      if (_hasNumber) conditionsMet++;
      if (_hasMinLength) conditionsMet++;

      switch (conditionsMet) {
        case 0:
          _progressBarColor = Colors.grey;
          _passwordStrengthText = 'Weak password';
          break;
        case 1:
          _progressBarColor = Colors.red;
          _passwordStrengthText = 'Weak password';
          break;
        case 2:
          _progressBarColor = Colors.orange;
          _passwordStrengthText = 'Medium password';
          break;
        case 3:
          _progressBarColor = Colors.green;
          _passwordStrengthText = 'Strong password';
          break;
      }

      _isPasswordValid =
          _hasUppercase &&
          _hasNumber &&
          _hasMinLength &&
          _newPasswordController.text == _confirmPasswordController.text &&
          _newPasswordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustomWidget(title: ''),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.background],
            stops: [0.3, 1],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.0,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(64.0),
                      border: Border.all(color: Colors.black87, width: 4.0),
                    ),
                    child: Icon(Icons.lock, size: 64.0, color: Colors.black87),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 28.0,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 4),
                          blurRadius: 4.0,
                          color: Colors.black26,
                        ),
                      ],
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Update your password to keep your account secure',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.0, color: Colors.black54),
                  ),
                  SizedBox(height: 32.0),
                  LabelTextField(
                    label: 'Current Password',
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrentPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.black60,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  LabelTextField(
                    label: 'New Password',
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    onChanged: _validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.black60,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  LabelTextField(
                    label: 'Confirm New Password',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    onChanged: _validatePassword,
                  ),

                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _progressBarColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 4,
                        decoration: BoxDecoration(
                          color:
                              _hasUppercase && _hasNumber
                                  ? _progressBarColor
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 4,
                        decoration: BoxDecoration(
                          color:
                              _hasUppercase && _hasNumber && _hasMinLength
                                  ? _progressBarColor
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _passwordStrengthText,
                          style: TextStyle(
                            color: _progressBarColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        _hasUppercase ? Icons.check_circle : Icons.close,
                        color: _hasUppercase ? Colors.green : Colors.grey,
                      ),
                      SizedBox(width: 8.0),
                      Text('At least 1 uppercase'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        _hasNumber ? Icons.check_circle : Icons.close,
                        color: _hasNumber ? Colors.green : Colors.grey,
                      ),
                      SizedBox(width: 8.0),
                      Text('At least 1 number'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        _hasMinLength ? Icons.check_circle : Icons.close,
                        color: _hasMinLength ? Colors.green : Colors.grey,
                      ),
                      SizedBox(width: 8.0),
                      Text('At least 8 characters'),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isPasswordValid ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
