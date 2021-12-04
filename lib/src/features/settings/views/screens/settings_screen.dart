import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  static route() => MaterialPageRoute(builder: (_) => SettingsScreen());

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          Form(child: Text('test form')),
          Form(child: Text('test form')),
          Form(child: Text('test form')),
          Form(child: Text('test form'))
        ],
      ),
    );
  }
}
