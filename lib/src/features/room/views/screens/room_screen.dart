import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoomScreen extends StatefulWidget {
  static const routeName = '/room';

  static route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => RoomScreen(roomId: settings.arguments as String),
    );
  }

  final String roomId;

  const RoomScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomId),
      ),
      body: Text('Test'),
    );
  }
}
