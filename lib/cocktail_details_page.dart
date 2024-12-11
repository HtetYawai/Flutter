import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CocktailDetailsPage extends StatelessWidget {
  final String? drinkId;
  final Map<String, dynamic>? localCocktail;

  CocktailDetailsPage({this.drinkId, this.localCocktail});

  Future<Map<String, dynamic>?> fetchDrinkDetails() async {
    if (drinkId == null)
      return null; // No API fetch for locally added cocktails
    final url = Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$drinkId');

    try {
      final response = await http.get(url);
      print('API Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['drinks'] == null || data['drinks'].isEmpty) {
          print('No drink details found for ID: $drinkId');
          return null;
        }

        return data['drinks'][0];
      } else {
        throw Exception('Failed to load drink details');
      }
    } catch (e) {
      print('Error fetching drink details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (localCocktail != null) {
      // Display locally added cocktail details
      return Scaffold(
        appBar: AppBar(
          title: Text(localCocktail!['strDrink'] ?? 'Cocktail Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (localCocktail!['strDrinkThumb'] != null)
                Image.network(
                  localCocktail!['strDrinkThumb']!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16),
              Text(
                localCocktail!['strDrink'] ?? 'Unnamed Cocktail',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Category: ${localCocktail!['strCategory'] ?? 'Unknown'}'),
              SizedBox(height: 8),
              Text(
                  'Instructions: ${localCocktail!['strInstructions'] ?? 'No Instructions'}'),
            ],
          ),
        ),
      );
    }

    // Fetch details for API-loaded cocktails
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktail Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchDrinkDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Failed to load cocktail details.'),
            );
          }

          final drink = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (drink['strDrinkThumb'] != null)
                  Image.network(
                    drink['strDrinkThumb'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 16),
                Text(
                  drink['strDrink'] ?? 'Unknown',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Category: ${drink['strCategory'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Alcoholic: ${drink['strAlcoholic'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Ingredients:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                for (int i = 1; i <= 15; i++)
                  if (drink['strIngredient$i'] != null &&
                      drink['strIngredient$i'].isNotEmpty)
                    Text(
                        '${drink['strIngredient$i']} - ${drink['strMeasure$i'] ?? 'as needed'}'),
                SizedBox(height: 16),
                Text(
                  'Instructions:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  drink['strInstructions'] ?? 'N/A',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
