import 'dart:io';

import 'package:recipes/src/model/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  late Database _database;

  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'recipe.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "create table tbl_recipes(id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR(50), description TEXT, ingredients TEXT, image TEXT)");
      },
    );
  }

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    final res = db.rawInsert(
        "INSERT INTO tbl_recipes(title, description, ingredients, image) VALUES(?,?,?,?)",
        [
          recipe.title,
          recipe.description,
          recipe.ingredients,
          recipe.image.path
        ]);
    return res;
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    final res = db.rawDelete('DELETE FROM tbl_recipes WHERE id = ?', [id]);

    return res;
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    final res = await db.rawUpdate(
        'UPDATE tbl_recipes SET title = ?, description = ?, ingredients = ?, image = ?  WHERE id = ?'
        ,
        [
          recipe.title,
          recipe.description,
          recipe.ingredients,
          recipe.image.path,
          recipe.id,
        ]
        );
    return res;
  }

  Future<List<Recipe>> showRecipeList() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM tbl_recipes");
    List<Recipe> recipeList = [];
    for (var element in res) {
      Map item = element;
      int id = item['id'];
      String title = item['title'];
      String description = item['description'];
      String ingredients = item['ingredients'];
      File image = File(item['image']);

      var recipe = Recipe(id, title, description, ingredients, image);
      recipeList.add(recipe);
    }
    return recipeList;
  }
}
