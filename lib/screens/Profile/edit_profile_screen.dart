import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                initialValue: 'Huỳnh Công Tiến',
                              ),
                              SizedBox(height: 8.0),
                              TextfieldCustomWidget(
                                label: 'Email',
                                initialValue: 'tienhuynh303@gmail.com',
                              ),
                              SizedBox(height: 8.0),
                              DatePickerCustomWidget(
                                label: 'Day of Birth',
                                initialValue: '10-09-2004',
                              ),
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
                            border: Border.all(color: Colors.white, width: 4.0),
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
                SizedBox(height: 94),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () {},
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
    );
  }
}

class DatePickerCustomWidget extends StatefulWidget {
  final String label;
  final String initialValue;

  const DatePickerCustomWidget({
    super.key,
    required this.label,
    required this.initialValue,
  });

  @override
  State<DatePickerCustomWidget> createState() => _DatePickerCustomWidgetState();
}

class _DatePickerCustomWidgetState extends State<DatePickerCustomWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            controller: _controller,
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
                    initialDate: DateFormat(
                      'dd-MM-yyyy',
                    ).parse(widget.initialValue),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _controller.text =
                          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    });
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
