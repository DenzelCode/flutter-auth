import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/common/widgets/go_back.dart';
import 'package:auth/src/common/widgets/main_text_field.dart';
import 'package:auth/src/common/widgets/next_button.dart';
import 'package:auth/src/common/widgets/scroll_close_keyboard.dart';
import 'package:auth/src/common/widgets/underlined_button.dart';
import 'package:auth/src/screens/home_screen.dart';
import 'package:auth/src/screens/recover_screen.dart';
import 'package:auth/src/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = '';
  bool _loading = false;

  @override
  void dispose() {
    super.dispose();

    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final node = FocusScope.of(context);

    return ScrollCloseKeyboard(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CirclesBackground(
          backgroundColor: Colors.white,
          topSmallCircleColor: theme.accentColor,
          topMediumCircleColor: theme.primaryColor,
          topRightCircleColor: theme.highlightColor,
          bottomRightCircleColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GoBack(),
                  SizedBox(
                    height: 65,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 250),
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                  MainTextField(
                    label: 'Username',
                    usernameField: true,
                    onChanged: (value) => setState(() {
                      _username = value;
                    }),
                    onEditingComplete: () => node.nextFocus(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MainTextField(
                    label: 'Password',
                    controller: _passwordController,
                    passwordField: true,
                    onSubmitted: (_) {
                      node.unfocus();

                      _login(context);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Spacer(),
                      NextButton(
                        onPressed: () => _login(context),
                        loading: _loading,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SignInButton(
                    Buttons.AppleDark,
                    text: "Sign up with Apple",
                    onPressed: () => _loginWithApple(context),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SignInButton(
                    Buttons.Facebook,
                    text: "Sign in with Facebook",
                    onPressed: () => _loginWithFacebook(context),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SignInButton(
                    Buttons.GoogleDark,
                    text: "Sign in with Google",
                    onPressed: () => _loginWithGoogle(context),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      UnderlinedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RegisterScreen.routeName,
                        ),
                        child: Text('Sign Up'),
                        color: theme.highlightColor,
                      ),
                      Spacer(),
                      UnderlinedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RecoverScreen.routeName,
                        ),
                        child: Text('Forgot Password'),
                        color: theme.accentColor,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    if (_loading || !_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _loading = true;
    });

    try {
      await provider.authenticate(
        _username,
        _passwordController.text,
      );

      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        (_) => false,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  _loginWithFacebook(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _loading = true;
    });

    try {
      await provider.loginWithFacebook(context);

      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        (_) => false,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  _loginWithGoogle(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _loading = true;
    });

    try {
      await provider.loginWithGoogle(context);

      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        (_) => false,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  _loginWithApple(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _loading = true;
    });

    try {
      await provider.loginWithApple(context);

      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        (_) => false,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
