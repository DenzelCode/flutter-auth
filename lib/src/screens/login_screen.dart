import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/common/widgets/go_back.dart';
import 'package:auth/src/common/widgets/main_text_field.dart';
import 'package:auth/src/common/widgets/next_button.dart';
import 'package:auth/src/common/widgets/scrollable_form.dart';
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

    return Scaffold(
      body: CirclesBackground(
        backgroundColor: Colors.white,
        topSmallCircleColor: theme.accentColor,
        topMediumCircleColor: theme.primaryColor,
        topRightCircleColor: theme.highlightColor,
        bottomRightCircleColor: Colors.white,
        child: Stack(
          children: [
            GoBack(),
            Column(
              children: [
                ScrollableForm(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        SizedBox(
                          height: 70,
                        ),
                        _form(node, context),
                        _thirdPartySignInButtons(context),
                      ],
                    ),
                  ],
                ),
                _FooterButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _form(FocusScopeNode node, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _thirdPartySignInButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        // if (Platform.isIOS)
        SignInButton(
          Buttons.AppleDark,
          text: "Sign in with Apple",
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
        )
      ],
    );
  }

  _login(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return _loginWith(context, () {
      return provider.authenticate(
        _username,
        _passwordController.text,
      );
    });
  }

  _loginWithFacebook(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return _loginWith(context, () => provider.loginWithFacebook(context));
  }

  _loginWithGoogle(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return _loginWith(context, () => provider.loginWithGoogle(context));
  }

  _loginWithApple(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return _loginWith(context, () => provider.loginWithApple(context));
  }

  _loginWith(BuildContext context, Future<void> Function() method) async {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await method();

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

class _FooterButtons extends StatelessWidget {
  const _FooterButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
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
    );
  }
}
