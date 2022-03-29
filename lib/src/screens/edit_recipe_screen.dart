import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/db/recipe_db.dart';
import 'package:recipes/src/model/recipe.dart';

class EditRecipeScreen extends StatefulWidget {
  Recipe recipe;

  EditRecipeScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  late final Recipe _recipe = widget.recipe;
  int response = 0;
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit recipe',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 2.0,
        ),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            //------------------------------------------------------------ image...
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .4,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.file(
                _recipe.image,
                fit: BoxFit.cover,
              ),
              alignment: Alignment.center,
            ),
            const SizedBox(width: 10),
            //------------------------------------------------------------ gallery and camera buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    imagePicker(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: TextButton.styleFrom(
                    primary: Colors.lightGreen,
                  ),
                ),
                const SizedBox(width: 10.0),
                TextButton.icon(
                  onPressed: () {
                    imagePicker(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text('Camera'),
                  style: TextButton.styleFrom(
                    primary: Colors.lightGreen,
                  ),
                ),
              ],
            ),
            //------------------------------------------------------------ title text field
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                initialValue: _recipe.title,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _recipe.title = value;
                  });
                },
              ),
            ),
            //------------------------------------------------------------ Ingredients text field
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                initialValue: _recipe.ingredients,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Ingredients',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _recipe.ingredients = value;
                  });
                },
              ),
            ),
            //------------------------------------------------------------ description text field
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: TextFormField(
                initialValue: _recipe.description,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Directions',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _recipe.description = value;
                  });
                },
              ),
            ),
            //------------------------------------------------------------ button
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 50.0, right: 50.0, bottom: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    var recipe = Recipe(
                      _recipe.id,
                      _recipe.title,
                      _recipe.description,
                      _recipe.ingredients,
                      _recipe.image,
                    );

                    var result = DBProvider.db.updateRecipe(recipe);

                    result.then((value) {
                      response = value;
                      if (response > 0) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Resipe edited successfully'),
                          backgroundColor: Colors.green,
                        ));
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Somthing went wrong!'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.lightGreen,
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: const Text(
                    'Save changes',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future imagePicker(ImageSource source) async {
    try {
      final imageTemp = await ImagePicker().pickImage(source: source);

      setState(() {
        _recipe.image = File(imageTemp!.path);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('image field connot be null!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
