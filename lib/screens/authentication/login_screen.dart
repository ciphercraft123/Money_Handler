import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:money_handler/firebase/FirebaseUtils.dart';
import 'package:money_handler/screens/authentication/signup_screen.dart';
import 'package:money_handler/utils/ColorsUtil.dart';
import 'package:money_handler/utils/Utils.dart';
import 'package:money_handler/widgets/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../widgets/Textformfield.dart';
import '../../widgets/button.dart';
import '../homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsUtil.darkBg,
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'image',
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: const AssetImage(
                    "assets/expense icon.png",
                  ),
                  height: 120,
                  width: 120,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              AnimatedTextkit(
                widget: TypewriterAnimatedText(
                  "Join With Expense Tracker",
                  textStyle: GoogleFonts.lato(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffFAAE18),
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
                isRepeat: false,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    AnimatedTextkit(
                        widget: WavyAnimatedText(
                          "Log In",
                          textStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.yellow,
                          ),
                        ),
                        isRepeat: true),
                    TextformField(
                      hinttext: 'Enter Your Email',
                      icon: Icons.email,
                      textController: emailController,
                      keyboardType: TextInputType.emailAddress,
                      isPadding: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Your Email";
                        } else if (!value.contains('@')) {
                          return "Please Enter Valid Email";
                        }
                        return null;
                      },
                    ),
                    TextformField(
                      hinttext: 'Enter Your password',
                      icon: Icons.lock,
                      textController: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      isPadding: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Your Password";
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            if (emailController.text.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Reset Password'),
                                    content: Text(
                                        "Message sent on ${emailController.text}"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          if (emailController.text.isNotEmpty &&
                                              emailController.text
                                                  .contains('@')) {
                                            FirebaseUtils.resetPassword(
                                                emailController.text);
                                            Get.back();
                                          } else if (!emailController.text
                                              .contains('@')) {
                                            Utils.showSnackbar(
                                              "Please enter valid email",
                                              const Duration(seconds: 2),
                                              Colors.red,
                                            );
                                          }
                                        },
                                        child: const Text('Send'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }
                            Utils.showSnackbar(
                              "Please Enter Email",
                              const Duration(seconds: 2),
                              Colors.red,
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () {
                        return Button(
                          text: "Log In",
                          isLoading: isLoading.value,
                          onTap: () async {
                            try {
                              if (_formkey.currentState!.validate()) {
                                isLoading.value = true;
                                UserCredential user = await FirebaseAuth
                                    .instance
                                    .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );

                                FirebaseUtils.cu = user.user;
                                emailController.clear();
                                passwordController.clear();
                                Get.offAll(
                                  const HomePage(),
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              print("Error Code:----${e.code}");
                              print("Error Message:----${e.message}");
                            }
                          },
                          bRadius: 10,
                          buttonStyle: Buttonstyle.primary,
                          height: 40,
                          width: 150,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/google.png",
                          height: 30,
                          width: 30,
                        ),
                        TextButton(
                          onPressed: () async {
                            var data = await FirebaseUtils.googleLogin();
                            FirebaseUtils.addUser(data.user);
                            Get.offAll(
                              const HomePage(),
                              transition: Transition.cupertino,
                            );
                          },
                          child: const Text(
                            "Log in with Google",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => const SignUpScreen(),
                              transition: Transition.cupertino);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
