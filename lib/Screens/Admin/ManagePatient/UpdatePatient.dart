import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../Database/Database.dart';
import '../../../Widget/AppBar.dart';
import '../../../Widget/AppButtons.dart';
import '../../../Widget/AppColor.dart';
import '../../../Widget/AppConstants.dart';
import '../../../Widget/AppDropList.dart';
import '../../../Widget/AppLoading.dart';
import '../../../Widget/AppMessage.dart';
import '../../../Widget/AppTextFields.dart';
import '../../../Widget/AppValidator.dart';
import '../../../Widget/AppText.dart';

class UpdatePatient extends StatefulWidget {
  final String docId;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final DateTime dateOfBirth;
  final String condition;
  final String therapistName;

  const UpdatePatient({
    Key? key,
    required this.docId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.dateOfBirth,
    required this.condition,
    required this.therapistName,
    required this.email,
  }) : super(key: key);

  @override
  State<UpdatePatient> createState() => _UpdatePatientState();
}

class _UpdatePatientState extends State<UpdatePatient> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailPathController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController therapistNameController = TextEditingController();
  GlobalKey<FormState> updateKey = GlobalKey();
  String? selectedCondition;
  DateTime? selectedDateOfBirth;

  static const String dateOfBirthLabel = 'Date of Birth';

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    dateOfBirthController.text =
        DateFormat('yyyy-MM-dd').format(widget.dateOfBirth);
    emailPathController.text = widget.email;
    phoneController.text = widget.phone;
    selectedCondition = widget.condition;
    therapistNameController.text = widget.therapistName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: AppMessage.updatePatient),
      body: Form(
        key: updateKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
              AppTextFields(
                controller: firstNameController,
                labelText: AppMessage.firstName,
                validator: (v) => AppValidator.validatorName(v),
                obscureText: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextFields(
                controller: lastNameController,
                labelText: AppMessage.lastName,
                validator: (v) => AppValidator.validatorName(v),
                obscureText: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextFields(
                controller: emailPathController,
                labelText: AppMessage.emailTx,
                validator: (v) => AppValidator.validatorEmail(v),
                obscureText: false,
                enable: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextFields(
                controller: phoneController,
                labelText: AppMessage.phoneTx,
                validator: (v) => AppValidator.validatorPhone(v),
                obscureText: false,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextFields(
                controller: dateOfBirthController,
                labelText: dateOfBirthLabel,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: widget.dateOfBirth,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          primaryColor: Colors.black,
                        ),
                        child: child!,
                      );
                    },
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        this.selectedDateOfBirth = selectedDate;
                        dateOfBirthController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                      });
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppMessage.mandatoryTx;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              AppDropList(
                listItem: AppConstants.conditionMenu,
                validator: (v) {
                  if (v == null) {
                    return AppMessage.mandatoryTx;
                  } else {
                    return null;
                  }
                },
                onChanged: (selectedItem) {
                  setState(() {
                    selectedCondition = selectedItem;
                  });
                  print('selectedCondition: $selectedCondition');
                },
                hintText: selectedCondition,
                dropValue: selectedCondition,
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextFields(
                controller: therapistNameController,
                labelText: AppMessage.therapist,
                validator: (v) {
                  if (v == null) {
                    return AppMessage.mandatoryTx;
                  } else {
                    return null;
                  }
                },
                obscureText: false,
                enable: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              AppButtons(
                text: AppMessage.update,
                bagColor: AppColor.iconColor,
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (updateKey.currentState?.validate() == true) {
                    AppLoading.show(context, '', 'lode');
                    Database.updatePatient(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      phone: phoneController.text,
                      dateOfBirth: selectedDateOfBirth!,
                      condition: selectedCondition!,
                      docId: widget.docId,
                    ).then((v) {
                      if (v == "done") {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        AppLoading.show(
                            context, AppMessage.update, AppMessage.done);
                      } else {
                        Navigator.pop(context);
                        AppLoading.show(
                            context, AppMessage.update, AppMessage.error);
                      }
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
