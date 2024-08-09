import 'package:digi_card/constant/color_pallete.dart';
import 'package:digi_card/constant/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: ColorPallete.gradiantColor,
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                imageConst.imageLogin,
                width: 200,
                height: 200,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 8.0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            errorText:
                                _validate ? "Value can't be Empty" : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: ColorPallete.color3),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelStyle: const TextStyle(
                              color: ColorPallete.colorSelect,
                            ),
                            labelText: "Email",
                            hintText: "Enter your email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: const Icon(
                              Icons.email_outlined,
                              color: ColorPallete.colorSelect,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 8.0),
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            errorText:
                                _validate ? "Value can't be Empty" : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: ColorPallete.color3),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelStyle: const TextStyle(
                              color: ColorPallete.colorSelect,
                            ),
                            labelText: "First Name",
                            hintText: "Enter your First Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: const Icon(
                              Iconsax.user_square,
                              color: ColorPallete.colorSelect,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 8.0),
                        child: TextFormField(
                          controller: lastNameeController,
                          decoration: InputDecoration(
                            errorText:
                                _validate ? "Value can't be Empty" : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: ColorPallete.color3),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelStyle: const TextStyle(
                              color: ColorPallete.colorSelect,
                            ),
                            labelText: "Last Name",
                            hintText: "Enter your Last Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: const Icon(
                              Iconsax.user_square,
                              color: ColorPallete.colorSelect,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 8.0),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            errorText:
                                _validate ? "Value can't be Empty" : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: ColorPallete.color3),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelStyle: const TextStyle(
                              color: ColorPallete.colorSelect,
                            ),
                            labelText: "Phone",
                            hintText: "Enter your Phone Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: const Icon(
                              Iconsax.call_add,
                              color: ColorPallete.colorSelect,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 8.0),
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            errorText:
                                _validate ? "Value can't be Empty" : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: ColorPallete.color3),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelStyle: const TextStyle(
                              color: ColorPallete.colorSelect,
                            ),
                            labelText: "Address",
                            hintText: "Enter your Adress",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: const Icon(
                              Iconsax.map,
                              color: ColorPallete.colorSelect,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 8.0),
                        child: TextFormField(
                          controller: passController,
                          decoration: InputDecoration(
                            errorText:
                                _validate ? "Value can't be Empty" : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: ColorPallete.color3),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelStyle: const TextStyle(
                              color: ColorPallete.colorSelect,
                            ),
                            labelText: "Password",
                            hintText: "Enter your Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: const Icon(
                              Iconsax.lock_1,
                              color: ColorPallete.colorSelect,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 8.0),
                        child: TextFormField(
                          controller: confPassController,
                          decoration: InputDecoration(
                            errorText:
                                _validate ? "Value can't be Empty" : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: ColorPallete.color3),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelStyle: const TextStyle(
                              color: ColorPallete.colorSelect,
                            ),
                            labelText: "Confirm Password",
                            hintText: "re_enter your Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: const Icon(
                              Iconsax.lock_1,
                              color: ColorPallete.colorSelect,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          width: 450,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _validate = emailController.text.isEmpty;
                                _validate = passController.text.isEmpty;
                                _validate = confPassController.text.isEmpty;
                                _validate = addressController.text.isEmpty;
                                _validate = phoneController.text.isEmpty;
                                _validate = lastNameeController.text.isEmpty;
                                _validate = firstNameController.text.isEmpty;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPallete.colorSelect,
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Already have an account?",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  letterSpacing: 1),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " Login",
                                    style: const TextStyle(
                                        color: ColorPallete.colorSelect,
                                        fontSize: 16),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {}),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
