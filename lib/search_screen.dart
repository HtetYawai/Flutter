import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String resultMessage = '';
  Map<String, dynamic>? cocktailData;

  Future<void> fetchCocktail(String query) async {
    final url = Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['drinks'] != null && data['drinks'].isNotEmpty) {
          setState(() {
            cocktailData = data['drinks'][0];
            resultMessage = 'Cocktail found!';
          });
        } else {
          setState(() {
            cocktailData = null;
            resultMessage = 'Cocktail "$query" is Unavailable.';
          });
        }
      } else {
        setState(() {
          resultMessage = 'Error: Unable to fetch data.';
          cocktailData = null;
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'Error: $e';
        cocktailData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Cocktails'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search for a cocktail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final query = searchController.text.trim();
                if (query.isNotEmpty) {
                  fetchCocktail(query);
                } else {
                  setState(() {
                    resultMessage = 'Please enter a cocktail name';
                    cocktailData = null;
                  });
                }
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            if (resultMessage.isNotEmpty) Text(resultMessage),
            if (cocktailData != null)
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      'Name: ${cocktailData!['strDrink']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Category: ${cocktailData!['strCategory']}'),
                    SizedBox(height: 8),
                    Text('Instructions: ${cocktailData!['strInstructions']}'),
                    SizedBox(height: 8),
                    if (cocktailData!['strDrinkThumb'] != null)
                      Image.network(cocktailData!['strDrinkThumb']),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
