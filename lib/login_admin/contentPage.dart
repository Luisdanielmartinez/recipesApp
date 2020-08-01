import 'package:recipes/pages/admin/show_recipe.dart';
import 'package:recipes/widgets/home_page.dart';

abstract class Content {
  Future<HomePageRecipes> list();
  // Future<InitialPage> recipes(String id);
  // Future <MapsPage>map();
  // Future<ListMyRecipe>myRecipe(String id);
  Future<InitialPage> admin();
}

class ContentPage implements Content {
  Future<HomePageRecipes> list() async {
    return HomePageRecipes();
  }

  // Future<InitialPage> recipes(String id) async {
  //   print("en content page $id");
  //   return InitialPage(id: id);
  // }

  Future<InitialPage> admin() async {
    return InitialPage();
  }

  //  Future<ListMyRecipe>myRecipe(String id) async{
  //    print("listado de mi recetas $id");
  //    return ListMyRecipe(id:id);
  //  }
  //  Future <MapsPage>map()async{
  //    return MapsPage();
  //  }
}
