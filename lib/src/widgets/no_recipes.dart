import 'package:flutter/material.dart';

class NoRecipes extends StatelessWidget {
  const NoRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          SizedBox(height: 100),
          Icon(
            Icons.no_food_outlined,
            color: Colors.black54,
            size: 60,
          ),
          SizedBox(height: 10),
          Text(
            'No recipes to view',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
