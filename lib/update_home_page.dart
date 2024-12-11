import 'package:flutter/material.dart';

class UpdateHomePage extends StatefulWidget {
  final Map<String, dynamic>? cocktail; // Null if adding a new cocktail
  final Function(Map<String, dynamic>) onSave; // Callback to save cocktail
  final Function()? onDelete; // Callback to delete cocktail (optional)

  UpdateHomePage({this.cocktail, required this.onSave, this.onDelete});

  @override
  _UpdateHomePageState createState() => _UpdateHomePageState();
}

class _UpdateHomePageState extends State<UpdateHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cocktail != null) {
      _nameController.text = widget.cocktail?['strDrink'] ?? '';
      _categoryController.text = widget.cocktail?['strCategory'] ?? '';
      _instructionsController.text = widget.cocktail?['strInstructions'] ?? '';
      _imageUrlController.text = widget.cocktail?['strDrinkThumb'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _instructionsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveCocktail() {
    if (_formKey.currentState!.validate()) {
      final updatedCocktail = {
        'idDrink': widget.cocktail?['idDrink'] ??
            DateTime.now().toString(), // Default ID for local cocktails
        'strDrink': _nameController.text.isNotEmpty
            ? _nameController.text
            : 'Unnamed Cocktail',
        'strCategory': _categoryController.text.isNotEmpty
            ? _categoryController.text
            : 'Unknown Category',
        'strInstructions': _instructionsController.text.isNotEmpty
            ? _instructionsController.text
            : 'No Instructions',
        'strDrinkThumb': _imageUrlController.text.isNotEmpty
            ? _imageUrlController.text
            : 'https://via.placeholder.com/150',
      };
      widget.onSave(updatedCocktail);
      Navigator.pop(context); // Return to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktail == null ? 'Add Cocktail' : 'Edit Cocktail'),
        actions: [
          if (widget.cocktail != null && widget.onDelete != null)
            Builder(
              builder: (BuildContext scaffoldContext) {
                return IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    widget.onDelete!();
                    Navigator.pop(context);
                  },
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Cocktail Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(labelText: 'Instructions'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCocktail,
                child: Text(widget.cocktail == null ? 'Add' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
