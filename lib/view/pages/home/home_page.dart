import 'package:flutter/material.dart';
import 'package:orun_test/view_model/baseAuth.dart';
import 'package:orun_test/model/drawer_item.dart';
import 'package:orun_test/view/pages/menu/profile.dart';
import 'package:orun_test/view/pages/menu/home.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  final drawerItems = [
    new DrawerItem("Home", Icons.home, new Home()),
    new DrawerItem("Perfil", Icons.settings, new Profile()),
    new DrawerItem("Salir", Icons.exit_to_app, null)
  ];

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    if (widget.drawerItems.length - 1 == pos) {
      widget._signOut();
    } else {
      var menuItem = widget.drawerItems[pos];
      if (menuItem.menuContext != null) {
        return menuItem.menuContext;
      } else {
        return new Center(
          child: new Text(
            "Error al cargar el menu",
            style: TextStyle(fontSize: 24.0),
          ),
        );
      }
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Text(widget.drawerItems[_selectedDrawerIndex] != null &&
                  widget.drawerItems.length - 1 != _selectedDrawerIndex
              ? widget.drawerItems[_selectedDrawerIndex].title
              : ""),
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text("German Flores"),
                accountEmail: new Text("gfloresf@outlook.com"),
                currentAccountPicture: new Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
              new Column(children: drawerOptions)
            ],
          ),
        ),
        body: _getDrawerItemWidget(_selectedDrawerIndex));
  }
}
