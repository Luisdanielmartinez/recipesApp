import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:recipes/auth/auth.dart';
import 'package:recipes/login_admin/login_page.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({this.auth, this.onSignIn});
  final BaseAuth auth;
  final VoidCallback onSignIn;
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

enum AuthState { noSignIn, signIn }

class _IntroScreenState extends State<IntroScreen> {
  AuthState _authState = AuthState.noSignIn;
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((onValue) => {
          setState(() {
            print(onValue);
            _authState =
                onValue == 'no_login' ? AuthState.noSignIn : AuthState.signIn;
          })
        });
    //pages slides intro
    slides.add(new Slide(
      title: "Ingredientes",
      maxLineTitle: 2,
      styleTitle: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono'),
      description: "Crea tus propias recetas",
      styleDescription: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway'),
      marginDescription:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
      centerWidget: Text("Deslice para pasar siguiente pantalla",
          style: TextStyle(color: Colors.white)),
      backgroundImage: 'assets/images/huevos.gif',
      onCenterItemPress: () {},
    ));
    //two
    slides.add(
      new Slide(
        title: "Recetas Mundiales",
        styleTitle: TextStyle(
            color: Colors.blueAccent,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Waffles, Postres, Tortas, Comida Thailandesa, Arabe, Mexicana, Peruana, Italiana, Argentina...",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        backgroundImage: "assets/images/azucar.gif",
      ),
    );
    //three page
    slides.add(
      new Slide(
        title: "Receta pizza italiana",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Ordena todo antes de iniciar la preparacion, vamos adelante...",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        backgroundImage: "assets/images/pizzacaliente.gif",
        maxLineTextDescription: 3,
      ),
    );
  }

  void onDonePress() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage(auth: widget.auth, onSignIn: widget.onSignIn)));
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.white,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.white,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      //list sliders
      slides: this.slides,
      //skip btn
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Colors.orangeAccent,
      highlightColorSkipBtn: Color(0xff000000),
      //next btn
      renderNextBtn: this.renderNextBtn(),

      //done btn
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Colors.blueAccent,
      highlightColorDoneBtn: Color(0xff69303),

      //dot indicator
      colorDot: Colors.white,
      colorActiveDot: Colors.orangeAccent[200],
      sizeDot: 13.0,

      //show or hide status bar

      shouldHideStatusBar: true,
      backgroundColorAllSlides: Colors.grey,
    );
  }
}
