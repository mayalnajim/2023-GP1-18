import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
import '../../../Widget/generalWidget.dart';

class AddNewTherapist extends StatefulWidget {
  const AddNewTherapist({Key? key}) : super(key: key);

  @override
  State<AddNewTherapist> createState() => _AddNewTherapistState();
}

class _AddNewTherapistState extends State<AddNewTherapist> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailPathController = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();
  String? generatedPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: AppMessage.addTherapist),
      body: Form(
        key: addKey,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
//==============================first name===============================================================
              AppTextFields(
                controller: firstNameController,
                labelText: AppMessage.firstName,
                validator: (v) => AppValidator.validatorName(v),
                obscureText: false,
              ),
              SizedBox(
                height: 10.h,
              ),
//==============================last name===============================================================
              AppTextFields(
                controller: lastNameController,
                labelText: AppMessage.lastName,
                validator: (v) => AppValidator.validatorName(v),
                obscureText: false,
              ),
              SizedBox(
                height: 10.h,
              ),
//==============================email name===============================================================
              AppTextFields(
                controller: emailPathController,
                labelText: AppMessage.emailTx,
                validator: (v) => AppValidator.validatorEmail(v),
                obscureText: false,
              ),
              SizedBox(
                height: 10.h,
              ),
//==============================phone number===============================================================
              AppTextFields(
                  controller: phoneController,
                  labelText: AppMessage.phoneTx,
                  validator: (v) => AppValidator.validatorPhone(v),
                  obscureText: false,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number),
              SizedBox(
                height: 10.h,
              ),
//==============================Add Button===============================================================
              AppButtons(
                text: AppMessage.add,
                bagColor: AppColor.iconColor,
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (addKey.currentState?.validate() == true) {
                    generatedPassword = AppWidget.randomUpper(1) +
                        AppWidget.randomLower(1) +
                        AppWidget.randomCode(1) +
                        AppWidget.randomNumber(5);
                    AppLoading.show(context, '', 'lode');
                    Database.therapistSingUp(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailPathController.text,
                      password: generatedPassword!,
                      phone: phoneController.text,
                    ).then((v) {
                    
                      if (v == "done") {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        AppLoading.show(context, AppMessage.add, AppMessage.done);
                      } else if (v == 'email-already-in-use') {
                        Navigator.pop(context);
                        AppLoading.show(
                            context, AppMessage.add, AppMessage.emailFound);
                      } else {
                        Navigator.pop(context);
                        AppLoading.show(
                            context, AppMessage.add, AppMessage.error);
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
