import 'package:digi_card/constant/color_pallete.dart';
import 'package:digi_card/constant/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool? isChecked = false;
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: ColorPallete.gradiantColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80.0),
                SvgPicture.asset(
                  imageConst.imageLogin,
                  width: 200,
                  height: 200,
                ),
                const Text("Welcome Back",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2.0),
                const Text(
                  "Sign in with your email and password.",
                  style: TextStyle(fontSize: 12.0),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, right: 20.0, left: 20.0, bottom: 8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      errorText: _validate ? "Value can't be Empty" : null,
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
                const SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0, left: 20.0, bottom: 10.0),
                  child: TextFormField(
                    controller: passController,
                    decoration: InputDecoration(
                      errorText: _validate ? "Value can't be Empty" : null,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: ColorPallete.color3),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelStyle: const TextStyle(
                        color: ColorPallete.colorSelect,
                      ),
                      labelText: "Password",
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      suffixIcon: const Icon(
                        Icons.lock_outline,
                        color: ColorPallete.colorSelect,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Forgot Password");
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: ColorPallete.color3,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    width: 450,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _validate = emailController.text.isEmpty;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPallete.colorSelect,
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account?",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            letterSpacing: 1),
                        children: <TextSpan>[
                          TextSpan(
                              text: " Sign Up",
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
      ),
    );
  }
}
