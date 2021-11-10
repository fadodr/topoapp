import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:todoapp/model/todosmodel.dart';
import 'package:http/http.dart' as http;

class Todosprovider extends ChangeNotifier {
  List<Todos> _todos = [];

  List<Todos> get getTodos {
    return [..._todos];
  }

  Future<void> addNEewTodo(String title) async {
    final url = 'https://todosdatabse-5209e-default-rtdb.firebaseio.com/todos.json';

    try {
      final response = await http.post(Uri.parse(url), body: json.encode({
        'title': title,
        'isChecked' : false
      }));
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      _todos.add(Todos(
        id: responseData['name'],
        title: title,
        isChecked: false,
        focusnode: FocusNode(),
        controller: TextEditingController(text: title)
      ));
      notifyListeners();
    }
    catch(error){
      throw error;
    }
  }

  Future<void> fetchAllTodos() async {
    final url = 'https://todosdatabse-5209e-default-rtdb.firebaseio.com/todos.json';

    try{
      final response = await http.get(Uri.parse(url));
      if(json.decode(response.body) == null){
        return;
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      List<Todos> loadedtodos = [];
      responseData.forEach((keys, values) {
        loadedtodos.add(Todos(
          id: keys,
          title: values['title'],
          isChecked: values['isChecked'],
          focusnode: FocusNode(),
          controller: TextEditingController(text: values['title'])
        ));
      });
      _todos = loadedtodos;
      notifyListeners();
    }
    catch(error){
      throw error;
    }
  }

  Future<void> deleteTodo(String id) async{
    final url = 'https://todosdatabse-5209e-default-rtdb.firebaseio.com/todos/$id.json';

    try{
      await http.delete(Uri.parse(url));
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    }
    catch(error){
      throw error;
    }
  }

  Future<void> updateTodo(String id, String title, bool isChecked) async {
    final url = 'https://todosdatabse-5209e-default-rtdb.firebaseio.com/todos/$id.json';

    try {
      final response = await http.patch(Uri.parse(url), body: json.encode({
        'title' : title,
        'isChecked' : isChecked
      }));
      final responseData = json.decode(response.body) as Map<String , dynamic>;
      final index = _todos.indexWhere((todos) => todos.id == id);
      _todos[index] = Todos(
        id: id,
        title: responseData['title'],
        isChecked: responseData['isChecked'],
        isEditing: _todos[index].isEditing,
        focusnode: _todos[index].focusnode,
        controller: _todos[index].controller
      );
      notifyListeners();
    }
     catch(error){
      throw error;
    }
  }
}