import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaven_book_app/bloc/user/user_bloc.dart';
import 'package:heaven_book_app/bloc/user/user_event.dart';
import 'package:heaven_book_app/bloc/user/user_state.dart';
import 'package:heaven_book_app/widgets/appbar_custom_widget.dart';
import 'package:intl/intl.dart';
import 'package:heaven_book_app/themes/app_colors.dart';
import 'package:heaven_book_app/widgets/textfield_custom_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  String? selectedGender;
  String dateOfBirthForServer = '';

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 EditProfileScreen initState called');

    // Trigger load user data từ API
    context.read<UserBloc>().add(LoadUserInfo());

    // Load data từ AuthBloc state hiện tại
    _loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authState = context.read<UserBloc>().state;

    if (authState is UserLoaded) {
      final user = authState.userData;
      nameController.text = user.name;
      selectedGender = user.gender;
      phoneController.text = user.phone ?? '';

      if (user.dateOfBirth != null) {
        dateOfBirthController.text = DateFormat(
          'dd-MM-yyyy',
        ).format(user.dateOfBirth!);
        dateOfBirthForServer = DateFormat(
          'yyyy-MM-dd',
        ).format(user.dateOfBirth!);
      }
    } else {
      context.read<UserBloc>().add(LoadUserInfo());
    }
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black54, width: 1.0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedGender,
                hint: Text(
                  'Select Gender',
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
                items:
                    ['Male', 'Female', 'Other'].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(
                          gender,
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );
        } else {
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }

        if (state is UserLoaded) {
          _loadUserData();

          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.message ?? 'Operation successful',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.all(16),
                duration: Duration(seconds: 3),
                elevation: 8,
              ),
            );
          }
        } else if (state is UserError) {
          // Hiển thị thông báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.all(16),
              duration: Duration(seconds: 4),
              elevation: 8,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppbarCustomWidget(title: ''),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.background],
              stops: [0.21, 0.21],
            ),
          ),
          padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 100.0, bottom: 12.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 8.0,
                          shadowColor: Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 70.0,
                              left: 24.0,
                              right: 24.0,
                              bottom: 16.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 36.0),
                                TextfieldCustomWidget(
                                  label: 'Name',
                                  controller: nameController,
                                ),
                                SizedBox(height: 8.0),
                                TextfieldCustomWidget(
                                  label: 'Phone',
                                  controller: phoneController,
                                ),
                                SizedBox(height: 8.0),
                                DatePickerCustomWidget(
                                  label: 'Day of Birth',
                                  controller: dateOfBirthController,
                                  onDateChanged: (serverFormat) {
                                    dateOfBirthForServer = serverFormat;
                                  },
                                ),
                                SizedBox(height: 8.0),
                                _buildGenderSelector(),
                                SizedBox(height: 40.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Transform.translate(
                            offset: Offset(0, 0),
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 8.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: NetworkImage(
                                  'https://i.pinimg.com/1200x/15/b2/dd/15b2dde4fae9ee8f9b748b8b2a832415.jpg',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              border: Border.all(
                                color: Colors.white,
                                width: 4.0,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(
                          UpdateUser(
                            name: nameController.text,
                            dateOfBirth: dateOfBirthForServer,
                            phone: phoneController.text,
                            gender: selectedGender ?? '',
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: AppColors.primaryDark,
                        shadowColor: Colors.black26,
                        elevation: 6,
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DatePickerCustomWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(String)? onDateChanged;

  const DatePickerCustomWidget({
    super.key,
    required this.label,
    required this.controller,
    this.onDateChanged,
  });

  @override
  State<DatePickerCustomWidget> createState() => _DatePickerCustomWidgetState();
}

class _DatePickerCustomWidgetState extends State<DatePickerCustomWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: widget.controller,
            readOnly: true,
            style: TextStyle(color: Colors.black54, fontSize: 17),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.black54,
                ),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateFormat('dd-MM-yyyy').parse(
                      widget.controller.text.isNotEmpty
                          ? widget.controller.text
                          : '01-01-2000',
                    ),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      widget.controller.text =
                          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    });
                    // Gọi callback với format yyyy-MM-dd cho server
                    if (widget.onDateChanged != null) {
                      widget.onDateChanged!(
                        DateFormat('yyyy-MM-dd').format(pickedDate),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
