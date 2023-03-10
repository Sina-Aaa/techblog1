import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tec/controller/register_controller.dart';
import 'package:tec/gen/assets.gen.dart';
import 'package:tec/constant/my_strings.dart';

import 'package:validators/validators.dart';

// ignore: must_be_immutable
class RegisterIntro extends StatelessWidget {
  RegisterIntro({Key? key}) : super(key: key);

  var registerController = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.images.tcbot.path,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: MyStrings.welcom,
                  style: textTheme.headlineMedium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ElevatedButton(
                onPressed: () {
                  _showEmailBottomSheet(context, size, textTheme);
                },
                child: const Text("بزن بریم"),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future<dynamic> _showEmailBottomSheet(
      BuildContext context, Size size, TextTheme textTheme) {
    var isValidate;
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: ((context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: size.height / 2,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  MyStrings.insertYourEmail,
                  style: textTheme.headlineMedium,
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextFormField(
                    controller: registerController.emailTextEditingController,
                    onChanged: (value) {
                      debugPrint(
                          value + " is Email : " + isEmail(value).toString());
                      isValidate = EmailValidator.validate(
                          registerController.emailTextEditingController.text);
                    },
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "techblog@gmail.com",
                      hintStyle: textTheme.headlineSmall,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (() async {
                    if (registerController
                        .emailTextEditingController.text.isEmpty) {
                      Get.snackbar(
                          "خطا", "لطفا ایمیل خود را به درستی وارد کنید");
                    } else {
                      if (isValidate) {
                        registerController.register();
                        Navigator.pop(context);
                        _activateCodeBottomSheet(context, size, textTheme);
                      } else {
                        Get.snackbar("خطا", "فرمت ایمیل درست نمیباشد, لطفا ایمیل خود را به درستی وارد کنید");
                      }
                    }
                  }),
                  child: const Text("ادامه"),
                ),
              ],
            )),
          ),
        );
      }),
    );
  }

  Future<dynamic> _activateCodeBottomSheet(
      BuildContext context, Size size, TextTheme textTheme) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: ((context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: size.height / 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        MyStrings.activateCode,
                        style: textTheme.headlineMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: TextField(
                          controller: registerController
                              .activeCodeTextEditingController,
                          onChanged: (value) {
                            debugPrint(value +
                                " is Email : " +
                                isEmail(value).toString());
                          },
                          style: textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: "******",
                              hintStyle: textTheme.headlineSmall),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: (() {
                            registerController.verify();
                          }),
                          child: const Text("ادامه"))
                    ]),
              ),
            ),
          );
        }));
  }
}
