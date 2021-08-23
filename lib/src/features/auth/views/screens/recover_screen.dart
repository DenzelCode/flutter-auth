import 'package:auth/src/features/auth/providers/auth_provider.dart';
import 'package:auth/src/features/auth/views/screens/login_screen.dart';
import 'package:auth/src/features/auth/views/screens/register_screen.dart';
import 'package:auth/src/shared/views/widgets/alert_widget.dart';
import 'package:auth/src/shared/views/widgets/circles_background.dart';
import 'package:auth/src/shared/views/widgets/go_back.dart';
import 'package:auth/src/shared/views/widgets/main_text_field.dart';
import 'package:auth/src/shared/views/widgets/next_button.dart';
import 'package:auth/src/shared/views/widgets/scrollable_form.dart';
import 'package:auth/src/shared/views/widgets/underlined_button.dart';
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
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        'Forgot Password',
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
      ],
    );
  }

  _recover(BuildContext context) async {
    if (_loading) {
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
            child: Text('Sign In'),
            color: theme.accentColor,
            onPressed: () => Navigator.pushNamed(
              context,
              LoginScreen.routeName,
            ),
          ),
          Spacer(),
          UnderlinedButton(
            child: Text('Sign Up'),
            color: theme.highlightColor,
            onPressed: () => Navigator.pushNamed(
              context,
              RegisterScreen.routeName,
            ),
          ),
        ],
      ),
    );
  }
}
