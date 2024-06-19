import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:money_handler/firebase/FirebaseUtils.dart';
import 'package:money_handler/screens/authentication/login_screen.dart';
import 'package:money_handler/screens/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../utils/ColorsUtil.dart';
import '../../widgets/Textformfield.dart';
import '../../widgets/animated_text_kit.dart';
import '../../widgets/button.dart';
import '../homepage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.darkBg,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SafeArea(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: const AssetImage(
                    "assets/expense icon.png",
                  ),
                  height: 120,
                  width: 120,
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
                            "Sign Up",
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
                      const SizedBox(height: 30),
                      Obx(
                        () => Button(
                          text: "Sign Up",
                          isLoading: isLoading.value,
                          onTap: () async {
                            try {
                              if (_formkey.currentState!.validate()) {
                                isLoading.value = true;
                                UserCredential user = await FirebaseAuth
                                    .instance
                                    .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                                FirebaseUtils.addUser(user.user);
                                emailController.clear();
                                passwordController.clear();
                                Get.offAll(const UserDetails());
                              }
                            } on FirebaseAuthException catch (e) {
                              print('error-------${e.message}');
                              print(e.code);
                            }
                          },
                          bRadius: 10,
                          buttonStyle: Buttonstyle.primary,
                          height: 40,
                          width: 150,
                        ),
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
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Log in',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => const LoginScreen(),
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
      ),
    );
  }
}
