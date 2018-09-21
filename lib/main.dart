import 'package:flutter/material.dart';
import 'package:orun_test/view/pages/root_page.dart';
import 'package:orun_test/view_model/auth.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'OrUnTest',
      theme: new ThemeData(
        primaryColor: Colors.purple,
        // primaryColorLight: Color(0xff0a0a0a),
        // primaryColorDark: Color(0xff000000),
      ),
      home: RootPage(auth: new Auth()),
      debugShowCheckedModeBanner: false,
    );
  }
}
