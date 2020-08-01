import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes/auth/auth.dart';
import 'package:recipes/login_admin/sliders_page.dart';

import 'menu_page.dart';
//esto es para saber si el usuario se logeo

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  _RootPageState createState() => _RootPageState();
}

enum AuthStatu { noSignIn, signIn }

class _RootPageState extends State<RootPage> {
  AuthStatu _authStatu = AuthStatu.noSignIn;
  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((onValue) => {
          setState(() {
            print(onValue);
            _authStatu =
                onValue == 'no_login' ? AuthStatu.noSignIn : AuthStatu.signIn;
          })
        });
  }

  void _signIn() {
    setState(() {
      _authStatu = AuthStatu.signIn;
    });
  }

  void _signOut() {
    setState(() {
      _authStatu = AuthStatu.noSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    //aqui si esta logeado lo manda a homepage y sino a registro
    switch (_authStatu) {
      case AuthStatu.noSignIn:
        return IntroScreen(
          auth: widget.auth,
          onSignIn: _signIn,
        );
        break;
      case AuthStatu.signIn:
        return HomePage(
          auth: widget.auth,
          onSignOut: _signOut,
        );
        break;
    }
    return _widget;
  }
}
