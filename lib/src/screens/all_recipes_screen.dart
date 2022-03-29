import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:recipes/db/recipe_db.dart';
import 'package:recipes/src/model/recipe.dart';
import 'package:recipes/src/screens/edit_recipe_screen.dart';
import 'package:recipes/src/widgets/no_recipes.dart';
import 'package:recipes/src/widgets/recipe_detail_view.dart';
import 'package:share/share.dart';

class AllRecipesScreen extends StatefulWidget {
  const AllRecipesScreen({Key? key}) : super(key: key);

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

late Future<List<Recipe>> recipeList;

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  @override
  Widget build(BuildContext context) {
    recipeList = DBProvider.db.showRecipeList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text(
          'All Recipes',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/new').then((value) => setState(() {
                    recipeList = DBProvider.db.showRecipeList();
                  }));
            },
            icon: const Icon(
              Icons.add_to_photos_rounded,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Recipe>>(
        future: recipeList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // still waiting for data to come
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // got data from snapshot but it is empty
            return const NoRecipes();
          } else {
            // got data and it is not empty
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        // Delete ---------------------------
                        SlidableAction(
                          onPressed: (context) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('You are about to delete a recipe'),
                                  content: const Text('This will delete your recipe, Are you sure?'),
                                  elevation: 8.0,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          DBProvider.db.deleteRecipe(
                                            snapshot.data![index].id,
                                          );
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        // Edit ---------------------------
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditRecipeScreen(
                                  recipe: snapshot.data![index],
                                ),
                              ),
                            ).then((value) => setState(() {
                                  recipeList = DBProvider.db.showRecipeList();
                                }));
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => EditRecipeScreen(
                            //       recipe: snapshot.data![index],
                            //     ),
                            //   ),
                            // );
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        // share ---------------------------
                        SlidableAction(
                          onPressed: (context) async {
                            final temp = snapshot.data![index].image.path;
                            await Share.shareFiles(
                              [temp],
                              subject: snapshot.data![index].title,
                              text:
                                  'Check out my ${snapshot.data![index].title} recipe\n${snapshot.data![index].description}',
                            );
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          icon: Icons.share,
                          label: 'Share',
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 90.0,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => RecipeDetailView(
                                title: snapshot.data![index].title,
                                description: snapshot.data![index].description,
                                ingredients: snapshot.data![index].ingredients,
                                image: snapshot.data![index].image,
                              ),
                            );
                            // showCupertinoModalPopup(
                            //   context: context,
                            //   builder: (context) => Container(
                            //     color: Colors.white,
                            //     child: const Text("Recipe detail"),
                            //   ),
                            // );
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 5.0,
                            color: Colors.lightGreen.shade200,
                            child: Row(
                              children: [
                                //--------------------------------------------- image
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreen.shade300,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Image.file(
                                    snapshot.data![index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //--------------------------------------------- title
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                        ),
                                        child: Text(
                                          snapshot.data![index].title,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      //--------------------------------------------- description
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 3,
                                        ),
                                        child: Text(
                                          snapshot.data![index].description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
