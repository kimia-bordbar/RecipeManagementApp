import 'dart:io';

import 'package:flutter/material.dart';

class RecipeDetailView extends StatelessWidget {
  const RecipeDetailView({
    Key? key,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.image,
  }) : super(key: key);
  final String title;
  final String description;
  final String ingredients;
  final File image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40.0),
                    // title ------------------------------
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // image ------------------------------
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // ingredients ------------------------------
                    const Text(
                      'Ingredients:',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(
                        ingredients,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // description ------------------------------
                    const Text(
                      'Directions:',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // back button ------------------------------
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Go back',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
