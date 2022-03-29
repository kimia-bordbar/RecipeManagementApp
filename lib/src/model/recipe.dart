import 'dart:io';

class Recipe {
  int id;
  String title;
  String description;
  String ingredients;
  File image;

  Recipe(
    this.id,
    this.title,
    this.description,
    this.ingredients,
    this.image,
  );
}
