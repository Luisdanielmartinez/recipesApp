import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipes/auth/auth.dart';
import 'package:recipes/login_admin/contentPage.dart';
import 'package:recipes/widgets/home_page.dart';

const PrimaryColor = const Color(0xFF19212B);

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String user = "Usuario";
  String userEmail = "email";
  String id;

  Content page = ContentPage();
  Widget contentPage = HomePageRecipes(); //esta es la pagina principal

  void _signOut() async {
    try {
      widget.auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.infoUser().then((onValue) => {
          setState(() {
            user = onValue.displayName;
            userEmail = onValue.email;
            id = onValue.uid;

            print("id del menu $id");
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          elevation: 30.0,
          child: Container(
            color: Color(0xFF19212B),
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    maxRadius: 10.0,
                    backgroundImage: AssetImage('assets/images/cocina.jpg'),
                  ),
                  accountName: Text(
                    '$user',
                    style: TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    '$userEmail',
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xFF262F3D),
                      image: DecorationImage(
                        alignment: Alignment(1.0, 0),
                        image: AssetImage('assets/images/misanplas.jpg'),
                        fit: BoxFit.scaleDown,
                      )),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    page.list().then((value) {
                      setState(() {
                        contentPage = value;
                      });
                    });
                  },
                  leading: Icon(
                    Icons.home,
                    color: Color(0xFF4FC3F7),
                  ),
                  title: Text(
                    'Casa',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Divider(height: 2.0, color: Colors.white),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).pop();
                    // page.myRecipe(id).then((value) {
                    //   print(value);
                    //   setState(() {
                    //     contentPage = value;
                    //   });
                    // });
                  },
                  leading: Icon(
                    FontAwesomeIcons.pizzaSlice,
                    color: Color(0xFF4FC3F7),
                  ),
                  title: Text(
                    'Mi Recetas',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    page.admin().then((value) {
                      print(value);
                      setState(() {
                        contentPage = value;
                      });
                    });
                  },
                  leading: Icon(
                    Icons.contact_mail,
                    color: Color(0xFF4FC3F7),
                  ),
                  title: Text(
                    'Administrador',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).pop();
                    // page.map(id).then((value) {
                    //   print(value);
                    //   setState(() {
                    //     contentPage = value;
                    //   });
                    // });
                  },
                  leading: Icon(
                    FontAwesomeIcons.map,
                    color: Color(0xFF4FC3F7),
                  ),
                  title: Text(
                    'Mapa de tiendas',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Salir',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Color(0xFF4FC3F7),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _signOut();
                  },
                )
              ],
            ),
          )),
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text('Recetas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.grid_on),
            tooltip: 'Grid',
            onPressed: () {
              // Route route =
              //     MaterialPageRoute(builder: (context) => GridPageInicio());
              // Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: contentPage,
    );
  }
}
