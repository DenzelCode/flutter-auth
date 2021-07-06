import 'dart:async';

import 'package:auth/main.dart';
import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/exceptions/http_exception.dart';
import 'package:auth/src/common/widgets/alert_widget.dart';
import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/common/widgets/go_back.dart';
import 'package:auth/src/common/widgets/main_text_field.dart';
import 'package:auth/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: CirclesBackground(
        backgroundColor: Colors.white,
        topSmallCircleColor: Color(0xffFD969C),
        topMediumCircleColor: Color(0xff8A4C7D),
        topRightCircleColor: Color(0xffE4DB7C),
        bottomRightCircleColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoBack(),
              Spacer(),
              Text(
                'Sign into your account',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Divider(),
              MainTextField(
                label: 'Username',
                onChanged: (value) => setState(() {
                  _username = value;
                }),
              ),
              SizedBox(
                height: 20,
              ),
              MainTextField(
                label: 'Password',
                controller: _passwordController,
                maxLength: 60,
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Sign in',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff8A4C7D),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () => _login(context),
                      icon: Icon(Icons.arrow_forward),
                    ),
                  )
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _loading = true;
    });

    try {
      await provider.authenticate(
        _username,
        _passwordController.text,
      );

      await Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        (_) => false,
      );
    } on HttpException catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertWidget(title: e.error ?? e.message, description: e.message),
      );

      _passwordController.text = '';
    }

    setState(() {
      _loading = false;
    });
  }

  Widget _loadingWidget() {
    return _loading
        ? Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Container();
  }
}
