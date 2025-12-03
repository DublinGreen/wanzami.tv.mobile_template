import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_stream_clone/src/components/custom_button.dart';
import 'package:video_stream_clone/src/core/app_color.dart';
import 'package:video_stream_clone/src/core/app_const.dart';
import 'package:video_stream_clone/src/core/app_extension.dart';
import 'package:video_stream_clone/src/presentation/privacy_policy/helper/router.dart';
import 'package:video_stream_clone/src/presentation/Auth/signin/signin_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SignUpPage extends StatefulWidget {
  final GraphQLClient dataClient;

  const SignUpPage({super.key, required this.dataClient});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isAcceptPrivacy = true;
  bool isLoading = false;

  static const String signupUserQuery = r'''
    mutation CreateUser($firstName: String!, $lastName: String!, $email: String!, $password: String!) {
      createUser(
        firstName: $firstName
        lastName: $lastName
        email: $email
        password: $password
      ) {
        id
        firstName
        lastName
        email
        role
      }
    }
  ''';

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (!isAcceptPrivacy) {
      _showSnack("Accept Terms & Privacy Policy");
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await widget.dataClient.mutate(
        MutationOptions(
          document: gql(signupUserQuery),
          variables: {
            "firstName": firstNameCtrl.text.trim(),
            "lastName": lastNameCtrl.text.trim(),
            "email": emailCtrl.text.trim(),
            "password": passwordCtrl.text,
          },
        ),
      );

      if (result.hasException) {
        final msg = result.exception!.graphqlErrors.isNotEmpty
            ? result.exception!.graphqlErrors.first.message
            : "Registration failed";

        _showSnack(msg);
      } else {
        final user = result.data?['createUser'];
        _showSnack("Welcome ${user['firstName']} 🎉");

        Navigator.pushReplacement(
          context,
          CustomRouter(widget: SignInPage(client: widget.dataClient)),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 44, 44, 44),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 70.h),

                  _buildField(
                    hint: "First Name",
                    icon: "assets/icons/ic_user.png",
                    controller: firstNameCtrl,
                    validator: (v) => v!.isEmpty ? "Enter first name" : null,
                  ),
                  SizedBox(height: 10.h),

                  _buildField(
                    hint: "Last Name",
                    icon: "assets/icons/ic_user.png",
                    controller: lastNameCtrl,
                    validator: (v) => v!.isEmpty ? "Enter last name" : null,
                  ),
                  SizedBox(height: 10.h),

                  _buildField(
                    hint: "Email",
                    icon: "assets/icons/ic_email.png",
                    controller: emailCtrl,
                    keyboard: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.isEmpty) return "Enter email";
                      if (!_isValidEmail(v)) return "Invalid email";
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),

                  _buildField(
                    hint: "Password",
                    icon: "assets/icons/ic_password.png",
                    controller: passwordCtrl,
                    obscure: true,
                    validator: (v) {
                      if (v!.isEmpty) return "Enter password";
                      if (v.length < 6) return "At least 6 characters";
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),

                  _buildField(
                    hint: "Confirm Password",
                    icon: "assets/icons/ic_password.png",
                    controller: confirmCtrl,
                    obscure: true,
                    validator: (v) {
                      if (v!.isEmpty) return "Confirm password";
                      if (v != passwordCtrl.text) return "Passwords do not match";
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  Transform.translate(
                    offset: Offset(-8.w, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isAcceptPrivacy,
                          onChanged: (newValue) {
                            setState(() => isAcceptPrivacy = newValue!);
                          },
                          side: WidgetStateBorderSide.resolveWith(
                                (states) => const BorderSide(width: 2.0, color: Colors.white),
                          ),
                          checkColor: Colors.black,
                          activeColor: Colors.white,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              children: [
                                const TextSpan(text: 'By Signing in you accept '),
                                TextSpan(
                                  text: 'Terms',
                                  style: const TextStyle(
                                    color: AppColor.pinkColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: const TextStyle(
                                    color: Colors.pink,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),

                  /// ✅ FIXED onTap for CustomPrimaryButton
                  CustomPrimaryButton(
                    text: isLoading ? "PLEASE WAIT..." : "REGISTER",
                    onTap: () {
                      if (!isLoading) _registerUser();
                    },
                  ),

                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                          fontSize: 13.3,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 7.w),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CustomRouter(widget: SignInPage(client: widget.dataClient)),
                          );
                        },
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return AppColor.linearGradientPrimary.createShader(rect);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Container(
                      width: context.width / 3.5,
                      height: 3.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: AppColor.linearGradientPrimary,
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

  Widget _buildField({
    required String hint,
    required String icon,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Transform.scale(
      scaleY: 0.9,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        cursorColor: Colors.white,
        keyboardType: keyboard,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w100,
            fontSize: 17,
          ),
          prefixIcon: Transform.scale(
            scale: 0.7,
            child: Image.asset(icon),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(54, 61, 80, 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
