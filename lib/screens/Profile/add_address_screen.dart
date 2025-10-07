import 'package:flutter/material.dart';
import 'package:heaven_book_app/themes/app_colors.dart';
import 'package:heaven_book_app/widgets/appbar_custom_widget.dart';
import 'package:heaven_book_app/widgets/textfield_custom_widget.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final List<String> fakeTags = [
    'Home',
    'Office',
    'School',
    'Company',
    'Other',
  ];
  String? selectedTag;
  final ValueNotifier<bool> defaultSwitch = ValueNotifier<bool>(true);

  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> wards = [];
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedWard;

  @override
  void initState() {
    super.initState();
    loadAddressData();
  }

  Future<void> loadAddressData() async {
    final String response = await rootBundle.loadString(
      'assets/data/vietnamAddress.json',
    );
    final data = await json.decode(response);
    setState(() {
      provinces = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustomWidget(title: 'New Address'),
      body: Container(
        color: AppColors.background,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
            padding: EdgeInsets.only(top: 32.0, left: 24.0, right: 24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12.0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextfieldCustomWidget(
                    label: 'Name',
                    initialValue: 'Huỳnh Công Tiến',
                  ),
                  SizedBox(height: 6.0),

                  TextfieldCustomWidget(
                    label: 'Phone',
                    initialValue: '0967654817',
                  ),
                  SizedBox(height: 6.0),

                  LocationPickerField(
                    label: 'Location Information',
                    value:
                        selectedProvince != null &&
                                selectedDistrict != null &&
                                selectedWard != null
                            ? '$selectedWard, $selectedDistrict, $selectedProvince'
                            : null,
                    onTap: () async {
                      String? province = selectedProvince;
                      String? district = selectedDistrict;
                      String? ward = selectedWard;
                      await showDialog(
                        context: context,
                        builder: (context) {
                          List<dynamic> tempDistricts =
                              province != null
                                  ? provinces.firstWhere(
                                    (p) => p['Name'] == province,
                                  )['Districts']
                                  : [];
                          List<dynamic> tempWards =
                              district != null
                                  ? tempDistricts.firstWhere(
                                    (d) => d['Name'] == district,
                                  )['Wards']
                                  : [];
                          String? tempProvince = province;
                          String? tempDistrict = district;
                          String? tempWard = ward;
                          return StatefulBuilder(
                            builder: (context, setStateDialog) {
                              return AlertDialog(
                                title: Text('Select Location'),
                                backgroundColor: Colors.white,
                                shadowColor: Colors.black26,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButtonFormField<String>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        labelText: 'Province/City',
                                      ),
                                      value: tempProvince,
                                      items:
                                          provinces
                                              .map<DropdownMenuItem<String>>((
                                                province,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: province['Name'],
                                                  child: Text(province['Name']),
                                                );
                                              })
                                              .toList(),
                                      onChanged: (value) {
                                        setStateDialog(() {
                                          tempProvince = value;
                                          tempDistrict = null;
                                          tempWard = null;
                                          tempDistricts =
                                              provinces.firstWhere(
                                                (p) => p['Name'] == value,
                                              )['Districts'];
                                          tempWards = [];
                                        });
                                      },
                                    ),
                                    SizedBox(height: 8.0),
                                    DropdownButtonFormField<String>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        labelText: 'District',
                                      ),
                                      value: tempDistrict,
                                      items:
                                          tempDistricts
                                              .map<DropdownMenuItem<String>>((
                                                district,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: district['Name'],
                                                  child: Text(district['Name']),
                                                );
                                              })
                                              .toList(),
                                      onChanged: (value) {
                                        setStateDialog(() {
                                          tempDistrict = value;
                                          tempWard = null;
                                          tempWards =
                                              tempDistricts.firstWhere(
                                                (d) => d['Name'] == value,
                                              )['Wards'];
                                        });
                                      },
                                    ),
                                    SizedBox(height: 8.0),
                                    DropdownButtonFormField<String>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        labelText: 'Ward/Commune',
                                      ),
                                      value: tempWard,
                                      items:
                                          tempWards
                                              .map<DropdownMenuItem<String>>((
                                                ward,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: ward['Name'],
                                                  child: Text(ward['Name']),
                                                );
                                              })
                                              .toList(),
                                      onChanged: (value) {
                                        setStateDialog(() {
                                          tempWard = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryDark,
                                    ),
                                    onPressed:
                                        tempProvince != null &&
                                                tempDistrict != null &&
                                                tempWard != null
                                            ? () {
                                              setState(() {
                                                selectedProvince = tempProvince;
                                                selectedDistrict = tempDistrict;
                                                selectedWard = tempWard;
                                                districts =
                                                    provinces.firstWhere(
                                                      (p) =>
                                                          p['Name'] ==
                                                          tempProvince,
                                                    )['Districts'];
                                                wards =
                                                    districts.firstWhere(
                                                      (d) =>
                                                          d['Name'] ==
                                                          tempDistrict,
                                                    )['Wards'];
                                              });
                                              Navigator.of(context).pop();
                                            }
                                            : null,
                                    child: Text(
                                      'Done',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 6.0),

                  TextfieldCustomWidget(
                    label: 'Address Description',
                    initialValue: 'Ấp 1, nhà 32, cụm dân phố 1',
                  ),
                  SizedBox(height: 6.0),

                  AddressTagWidget(
                    tags: fakeTags,
                    selectedTag: selectedTag,
                    onTagSelected: (tag) {
                      setState(() {
                        selectedTag = tag;
                      });
                    },
                  ),
                  SizedBox(height: 6.0),

                  ValueListenableBuilder<bool>(
                    valueListenable: defaultSwitch,
                    builder: (context, value, child) {
                      return Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Set as Default',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Switch(
                            value: value,
                            onChanged: (bool newValue) {
                              defaultSwitch.value = newValue;
                            },
                            inactiveThumbColor: Colors.black45,
                            activeColor: AppColors.primaryDark,
                          ),
                          onTap: () {
                            defaultSwitch.value = !defaultSwitch.value;
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 340,
            margin: EdgeInsets.only(bottom: 30.0),
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
                'Done',
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
}

class AddressTagWidget extends StatelessWidget {
  final List<String> tags;
  final String? selectedTag;
  final Function(String) onTagSelected;

  const AddressTagWidget({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          children:
              tags.map((tag) {
                return ChoiceChip(
                  label: Text(
                    tag,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  selected: selectedTag == tag,
                  onSelected: (selected) {
                    if (selected) {
                      onTagSelected(tag);
                    }
                  },
                  selectedColor: Colors.blue[100],
                  backgroundColor: Colors.grey[200],
                  checkmarkColor: AppColors.primaryDark,
                  labelStyle: TextStyle(
                    color:
                        selectedTag == tag
                            ? AppColors.primaryDark
                            : Colors.black,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class LocationPickerField extends StatelessWidget {
  final String? value;
  final VoidCallback onTap;
  final String label;
  const LocationPickerField({
    super.key,
    required this.value,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextfieldCustomWidget(
          label: label,
          initialValue: value ?? '',
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
