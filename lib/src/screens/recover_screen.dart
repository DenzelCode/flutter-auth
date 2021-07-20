import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/widgets/alert_widget.dart';
import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/common/widgets/go_back.dart';
import 'package:auth/src/common/widgets/main_text_field.dart';
import 'package:auth/src/common/widgets/next_button.dart';
import 'package:auth/src/common/widgets/scroll_close_keyboard.dart';
import 'package:auth/src/common/widgets/underlined_button.dart';
import 'package:auth/src/screens/login_screen.dart';
import 'package:auth/src/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoverScreen extends StatefulWidget {
  static const routeName = '/recover';

  RecoverScreen({Key? key}) : super(key: key);

  @override
  _RecoverScreenState createState() => _RecoverScreenState();
}

class _RecoverScreenState extends State<RecoverScreen> {
  final _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final node = FocusScope.of(context);

    return ScrollCloseKeyboard(
      child: Scaffold(
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
                    height: 40,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 20,
                  ),
                  MainTextField(
                    label: 'Email',
                    controller: _emailController,
                    emailField: true,
                    onSubmitted: (_) {
                      node.unfocus();

                      _recover(context);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Recover',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Spacer(),
                      NextButton(
                        onPressed: () => _recover(context),
                        loading: _loading,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      UnderlinedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          LoginScreen.routeName,
                        ),
                        child: Text('Sign In'),
                        color: theme.highlightColor,
                      ),
                      Spacer(),
                      UnderlinedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RegisterScreen.routeName,
                        ),
                        child: Text('Sign Up'),
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

  _recover(BuildContext context) async {
    if (_loading || !_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _loading = true;
    });

    try {
      await provider.recover(
        _emailController.text,
      );

      _emailController.text = '';

      showDialog(
        context: context,
        builder: (context) => AlertWidget(
          title: 'Success',
          description: 'Check your email and change your password!',
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
