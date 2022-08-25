import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    print(res);
    
    if (res == 'success') {
      
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: Provider.of<ColorProvider>(context).primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64),
              TextFieldInput(
                isPass: false,
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                isPass: true,
                textEditingController: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Log in'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account?"),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
