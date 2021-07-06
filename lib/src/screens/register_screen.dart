import 'package:auth/main.dart';
import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/exceptions/http_exception.dart';
import 'package:auth/src/common/widgets/alert_widget.dart';
import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/common/widgets/go_back.dart';
import 'package:auth/src/common/widgets/main_text_field.dart';
import 'package:auth/src/common/widgets/next_button.dart';
import 'package:auth/src/common/widgets/underlined_button.dart';
import 'package:auth/src/screens/home_screen.dart';
import 'package:auth/src/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = '';
  String _email = '';
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
        backgroundColor: theme.accentColor,
        topSmallCircleColor: theme.primaryColor,
        topMediumCircleColor: theme.primaryColor,
        topRightCircleColor: theme.accentColor,
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
                  height: 40,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 40,
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
                  label: 'Email',
                  onChanged: (value) => setState(() {
                    _email = value;
                  }),
                  emailField: true,
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

                    _register(context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Spacer(),
                    NextButton(
                      onPressed: () => _register(context),
                      loading: _loading,
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    UnderlinedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        LoginScreen.routeName,
                      ),
                      child: Text('Sign In'),
                      color: theme.highlightColor,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _register(BuildContext context) async {
    if (_loading || !_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _loading = true;
    });

    try {
      await provider.register(
        _username,
        _email,
        _passwordController.text,
      );

      await Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        (_) => false,
      );
    } on HttpException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertWidget(
          title: e.error ?? e.message,
          description: e.message,
        ),
      );

      _passwordController.text = '';
    }

    setState(() {
      _loading = false;
    });
  }
}
