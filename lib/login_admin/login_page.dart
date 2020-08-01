import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/auth/auth.dart';
import 'package:recipes/login_admin/menu_page.dart';
import 'package:recipes/model/user_model.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignIn});
  final BaseAuth auth;
  final VoidCallback onSignIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }
enum SelectSource { camara, galery }

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _name;
  String _tell;
  String _itemCity;
  String _address;
  String _urlPhoto;
  String _user;

  bool _obcureText = true;
  FormType _formType = FormType.login;
  List<DropdownMenuItem<String>> _cityItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _cityItems = getCityItems();
      _itemCity = _cityItems[0].value;
    });
  }

  //get data of firebase
  getData() async {
    return await Firestore.instance.collection('Cities').getDocuments();
  }

  //dropdownList from fireStore
  List<DropdownMenuItem<String>> getCityItems() {
    List<DropdownMenuItem<String>> items = List();
    QuerySnapshot dataCities;

    getData().then((data) {
      dataCities = data;
      dataCities.documents.forEach((obj) {
        print('${obj.documentID} ${obj['name']}');
        items.add(DropdownMenuItem(
          value: obj.documentID,
          child: Text(obj['name']),
        ));
      });
    }).catchError((error) => print('hay un error......' + error));

    items.add(DropdownMenuItem(
      value: '0',
      child: Text('- Seleccione -'),
    ));
    return items;
  }

//this method is to validate the data is save or not
  bool _validateSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

//create a method than validateSend data
  void _validateSend() async {
    if (_validateSave()) {
      try {
        String userId =
            await widget.auth.signInEmailPassword(_email, _password);
        print('Usuario logueado :$userId');
        widget.onSignIn();
        HomePage(
          auth: widget.auth,
        ); //menu_page.dart
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        AlertDialog alert = new AlertDialog(
          content: Text("Error en la Autenticacion"),
          title: Text("Error"),
          actions: <Widget>[],
        );
        showDialog(context: context, child: alert);
      }
    }
  }

//method to validate register
  void _validateRegister() async {
    if (_validateSave()) {
      try {
        User user = User(
            name: _name,
            address: _address,
            tell: _tell,
            city: _itemCity,
            photo: _urlPhoto,
            password: _password,
            email: _email);
        String userId = await widget.auth.signUpEmailPassword(user);
        print('Usuario logueado : $userId');
        widget.onSignIn();
        HomePage(auth: widget.auth);
        Navigator.of(context).pop();
      } catch (e) {
        print("error......$e");
        AlertDialog alert = new AlertDialog(
          content: Text("Error en el registro"),
          title: Text("Error"),
          actions: <Widget>[],
        );
        showDialog(context: context, child: alert);
      }
    }
  }

//method go to register
  void _goRegister() {
    setState(() {
      formKey.currentState.reset();
      _formType = FormType.register;
    });
  }

//method go to login
  void _goLogin() {
    setState(() {
      formKey.currentState.reset();
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recetas")),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Center(
                child: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                        ),
                        Text('Recetas mundiales \n Mis recetas',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17.0)),
                        Padding(padding: EdgeInsets.only(bottom: 15.0))
                      ] +
                      buildInputs() +
                      buildSubmitButtons()),
            )),
          )),
    );
  }

  //list of inputs
  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        //list or array
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(FontAwesomeIcons.envelope),
          ),
          validator: (value) =>
              value.isEmpty ? 'El campo Email está vacio' : null,
          onSaved: (value) => _email = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: _obcureText,
          decoration: InputDecoration(
              labelText: 'Contraseña',
              icon: Icon(FontAwesomeIcons.key),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obcureText = !_obcureText;
                  });
                },
                child: Icon(
                  _obcureText ? Icons.visibility : Icons.visibility_off,
                ),
              )),
          validator: (value) => value.isEmpty
              ? 'El campo password debe tener\nal menos 6 caracteres'
              : null,
          onSaved: (value) => _password = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
      ];
    } else {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        Text(
          'Registro Usuario',
          style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: 'Nombre', icon: Icon(FontAwesomeIcons.user)),
          validator: (value) =>
              value.isEmpty ? 'El campo Nombre esta vacio' : null,
          onSaved: (value) => _name = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Celular',
            icon: Icon(FontAwesomeIcons.phone),
          ),
          validator: (value) =>
              value.isEmpty ? 'El campo Telefono esta vacio' : null,
          onSaved: (value) => _tell = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        DropdownButtonFormField(
          validator: (value) =>
              value == '0' ? 'Debe seleccionar una ciudad' : null,
          decoration: InputDecoration(
              labelText: 'Ciudad', icon: Icon(FontAwesomeIcons.city)),
          value: _itemCity,
          items: _cityItems,
          onChanged: (value) {
            setState(() {
              _itemCity = value;
            });
          }, //seleccionarCiudadItem,
          onSaved: (value) => _itemCity = value,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Dirección',
              icon: Icon(Icons.person_pin_circle),
            ),
            validator: (value) =>
                value.isEmpty ? 'El campo Direccion está vacio' : null,
            onSaved: (value) => _address = value.trim()),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(FontAwesomeIcons.envelope),
          ),
          validator: (value) =>
              value.isEmpty ? 'El campo Email esta vacio' : null,
          onSaved: (value) => _email = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          obscureText: _obcureText, //password
          decoration: InputDecoration(
              labelText: 'Contraseña',
              icon: Icon(FontAwesomeIcons.key),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obcureText = !_obcureText;
                  });
                },
                child: Icon(
                  _obcureText ? Icons.visibility : Icons.visibility_off,
                ),
              )),
          validator: (value) => value.isEmpty
              ? 'El campo password debe tener\nal menos 6 caracteres'
              : null,
          onSaved: (value) => _password = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
      ];
    }
  }
  //list buttons

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          onPressed: _validateSend,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Ingresar",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              Icon(
                FontAwesomeIcons.checkCircle,
                color: Colors.white,
              )
            ],
          ),
          color: Colors.orangeAccent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          elevation: 8.0,
        ),
        FlatButton(
            child: Text(
              'Crear una cuenta', //create new acount
              style: TextStyle(fontSize: 20.0, color: Colors.grey),
            ),
            onPressed: _goRegister),
      ];
    } else {
      return [
        RaisedButton(
          onPressed: _validateRegister,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Registrar Cuenta", //register new acount
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              Icon(
                FontAwesomeIcons.plusCircle,
                color: Colors.white,
              )
            ],
          ),
          color: Colors.orangeAccent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          elevation: 8.0,
        ),
        FlatButton(
          child: Text(
            '¿Ya tienes una Cuenta?',
            style: TextStyle(fontSize: 20.0, color: Colors.grey),
          ),
          onPressed: _goLogin,
        )
      ];
    }
  }
}
