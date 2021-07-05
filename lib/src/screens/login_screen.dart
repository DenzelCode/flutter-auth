import 'dart:async';

import 'package:auth/main.dart';
import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/exceptions/http_exception.dart';
import 'package:auth/src/common/widgets/alert_widget.dart';
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
      appBar: AppBar(
        title: Text('Login'),
        // actions: [_loading ? CircularProgressIndicator() : Container()],
        actions: [
          _loadingWidget(),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Text(
            'Sign into your account',
            style: TextStyle(
              fontSize: 26,
            ),
          ),
          Divider(),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
              suffixIcon: Icon(Icons.person),
            ),
            onChanged: (value) => setState(() {
              _username = value;
            }),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              suffixIcon: Icon(Icons.lock),
            ),
            controller: _passwordController,
            maxLength: 60,
            obscureText: true,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Sign in'),
            ),
          )
        ],
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
