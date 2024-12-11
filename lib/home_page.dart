import 'package:flutter/material.dart';
import 'package:flutter_cocktails/cocktail_details_page.dart';
import 'update_home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CocktailHomePage extends StatefulWidget {
  @override
  _CocktailHomePageState createState() => _CocktailHomePageState();
}

class _CocktailHomePageState extends State<CocktailHomePage> {
  List<dynamic> cocktails = [];

  @override
  void initState() {
    super.initState();
    fetchCocktails();
  }

  Future<void> fetchCocktails() async {
    final url = Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          cocktails = data['drinks'] ?? [];
        });
      } else {
        throw Exception('Failed to load cocktails');
      }
    } catch (e) {
      print('Error fetching cocktails: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktail List'),
        backgroundColor: const Color.fromARGB(255, 218, 141, 239),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: cocktails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: cocktails.length,
              itemBuilder: (context, index) {
                final cocktail = cocktails[index];
                return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(
                        cocktail['strDrinkThumb'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(cocktail['strDrink'] ?? 'Unknown'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateHomePage(
                                    cocktail: cocktail,
                                    onSave: (updatedCocktail) {
                                      setState(() {
                                        cocktails[index] = updatedCocktail;
                                      });
                                    },
                                    onDelete: () {
                                      setState(() {
                                        cocktails.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                cocktails.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        if (!cocktail.containsKey('idDrink')) {
                          print('Error: idDrink key missing in cocktail data');
                          return;
                        }
                        final drinkId = cocktail['idDrink'];
                        print('Selected Drink ID: $drinkId');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CocktailDetailsPage(
                              drinkId: drinkId,
                              localCocktail: drinkId == null ? cocktail : null,
                            ),
                          ),
                        );
                      },
                    ));
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateHomePage(
                onSave: (newCocktail) {
                  setState(() {
                    cocktails.add(newCocktail);
                  });
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 186, 137, 195),
      ),
    );
  }
}
