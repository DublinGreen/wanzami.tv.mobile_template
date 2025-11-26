import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:video_stream_clone/main_view.dart';
import 'package:video_stream_clone/src/components/custom_button.dart';
import 'package:video_stream_clone/src/core/app_color.dart';
import 'package:video_stream_clone/src/core/app_const.dart';
import 'package:video_stream_clone/src/core/app_extension.dart';
import 'package:video_stream_clone/src/presentation/privacy_policy/helper/router.dart';
import 'package:video_stream_clone/src/presentation/Auth/signin/social_media_signin_button.dart';
import 'package:video_stream_clone/src/presentation/Auth/signup/signup_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isRememberMe = true;
  bool isAcceptPrivicay = true;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // GraphQL mutation string
  static const String loginMutation = r'''
    mutation Login($email: String!, $password: String!) {
      login(email: $email, password: $password)
    }
  ''';

  Future<void> loginUser() async {
    setState(() => isLoading = true);

    final HttpLink httpLink = HttpLink('http://localhost:5000/graphql');
    final GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );

    final MutationOptions options = MutationOptions(
      document: gql(loginMutation),
      variables: {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(result.exception.toString()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: const Text("OK"))
            ],
          ),
        );
      } else {
        final token = result.data?['login'] ?? '';
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Login Success"),
            content: Text("Token: $token"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: const Text("OK"))
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: const Text("OK"))
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                children: [
                  Row(
                    children: [
                      const Text(
                        "Sign in to continue",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context, CustomRouter(widget: const MainPage()));
                        },
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return AppColor.linearGradientPrimary.createShader(rect);
                          },
                          child: const Text(
                            'Skip',
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
                  SizedBox(height: 40.h),

                  // EMAIL FIELD
                  Transform.scale(
                    scaleY: 0.9,
                    child: TextFormField(
                      controller: emailController,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                            color: Colors.white70,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w100,
                            fontSize: 17),
                        prefixIcon: Transform.scale(
                            scale: 0.7,
                            child: Image.asset("assets/icons/ic_email.png")),
                        filled: true,
                        fillColor: const Color.fromRGBO(54, 61, 80, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: BorderSide.none,
                        ),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // PASSWORD FIELD
                  Transform.scale(
                    scaleY: 0.9,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                            color: Colors.white70,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w100,
                            fontSize: 17),
                        prefixIcon: Transform.scale(
                            scale: 0.7,
                            child: Image.asset("assets/icons/ic_password.png")),
                        filled: true,
                        fillColor: const Color.fromRGBO(54, 61, 80, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: BorderSide.none,
                        ),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      MSHCheckbox(
                        size: 20,
                        value: isRememberMe,
                        colorConfig:
                            MSHColorConfig.fromCheckedUncheckedDisabled(
                          checkedColor: AppColor.pinkColor,
                        ),
                        style: MSHCheckboxStyle.fillScaleColor,
                        onChanged: (selected) {
                          setState(() {
                            isRememberMe = selected;
                          });
                        },
                      ),
                      SizedBox(width: 10.w),
                      const Text(
                        'Remember Me',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 13.7,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                          fontSize: 13.7,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Transform.translate(
                    offset: Offset(-8.w, 0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isAcceptPrivicay,
                          onChanged: (newValue) {
                            setState(() {
                              isAcceptPrivicay = newValue!;
                            });
                          },
                          side: WidgetStateBorderSide.resolveWith(
                            (states) =>
                                const BorderSide(width: 2.0, color: Colors.white),
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
                                  color: Colors.white),
                              children: [
                                const TextSpan(text: 'By Signing in you accept '),
                                TextSpan(
                                  text: 'Terms',
                                  style: const TextStyle(
                                      color: AppColor.pinkColor,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: const TextStyle(
                                      color: Colors.pink,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  CustomPrimaryButton(
                    text: isLoading ? "LOADING..." : "LOGIN",
                    onTap: () {
                      if (!isLoading && (_formKey.currentState?.validate() ?? false)) {
                        loginUser();
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    'Or Continue with',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      SignInSocialButton(
                        mainColor: const Color.fromRGBO(56, 125, 242, 1),
                        subColor: const Color.fromRGBO(81, 142, 248, 1),
                        text: 'Facebook',
                        onTap: () {},
                        icon: FontAwesomeIcons.facebookF,
                      ),
                      SizedBox(width: 20.w),
                      SignInSocialButton(
                        mainColor: const Color.fromRGBO(209, 54, 42, 1),
                        subColor: const Color.fromRGBO(241, 68, 54, 1),
                        text: 'Google',
                        icon: FontAwesomeIcons.google,
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                          fontSize: 13.3,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              CustomRouter(widget: const SignUpPage()));
                        },
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return AppColor.linearGradientPrimary.createShader(rect);
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 16.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                          gradient: AppColor.linearGradientPrimary),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
