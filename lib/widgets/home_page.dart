import 'package:flutter/material.dart';
import 'package:recipes/auth/auth.dart';

import 'food_body.dart';
import 'food_top.dart';

class HomePageRecipes extends StatefulWidget {
  @override
  _HomePageRecipesState createState() => _HomePageRecipesState();
}

class _HomePageRecipesState extends State<HomePageRecipes> {
  String userID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      Auth().currentUser().then((value) {
        userID = value;
        print("el futuro cheft $userID");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Text(
                  "Mas Buscado",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Align(
            alignment: Alignment.topCenter,
             child: FoodTop(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                child: Text(
              "Recetas Mundiales",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            )),
          ),
           Expanded(child: FoodBody())
        ],
      ),
    );
  }
}
