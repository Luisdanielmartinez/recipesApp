import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/model/user_model.dart';

abstract class BaseAuth {
  Future<String> signInEmailPassword(String _email, String _password);
  Future<String> signUpEmailPassword(User user);
  Future<void> signOut();
  Future<String> currentUser();
  Future<FirebaseUser> infoUser();
}

class Auth implements BaseAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInEmailPassword(String _email, String _password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password)).user;
    return user.uid;
  }

  //method regiter user
  Future<String> signUpEmailPassword(User userModel) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email, password: userModel.password)).user;

    UserUpdateInfo userInfo = UserUpdateInfo();
    await user.updateProfile(userInfo);
    await user
        .sendEmailVerification()
        .then((onValue) => print('email de verificacion enviado'))
        .catchError(
            (onError) => print('error de email de verificacion: $onError'));

    await Firestore.instance
        .collection("User")
        .document('${user.uid}')
        .setData({
          'name': userModel.name,
          'tell': userModel.tell,
          'email': userModel.email,
          'city': userModel.city,
          'address': userModel.address
        })
        .then((onValue) => print("Usuario registrado en la db"))
        .catchError(
            (onError) => print("error con el registro del usuari: $onError"));
    return user.uid;
  }
  Future<void>signOut() async{
   return _firebaseAuth.signOut();
  }
  Future<String>currentUser()async{
    FirebaseUser user=await _firebaseAuth.currentUser();
    String userId= user==null? user.uid:'no_login';
    return userId;
  }
   Future<FirebaseUser> infoUser()async{
     FirebaseUser user=await _firebaseAuth.currentUser();
      String userId= user==null? user.uid:'No se puede recuperar el usuario';
      print("Recuperando el usuario: $userId");
      return user;
   }
}
