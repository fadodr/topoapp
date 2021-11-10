import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/todosmodel.dart';
import 'package:todoapp/provider/todosprovider.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Todos> _todosList = [];

  TextEditingController _newtodocontroller = new TextEditingController();
  bool _isloading = false;

  void addtodo() {
    if(_newtodocontroller.text.isEmpty){
      return;
    }
    try{
      Provider.of<Todosprovider>(context, listen: false).addNEewTodo(_newtodocontroller.text);
    }
    catch(error){
      throw error;
    }
  }
  @override
  void initState() {
    _initstate();
    super.initState();
  }

  Future<void> _initstate() async{
    setState(() {
      _isloading = true;
    });
    await Provider.of<Todosprovider>(context, listen: false).fetchAllTodos();
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
     _todosList = Provider.of<Todosprovider>(context).getTodos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO DO App', style: TextStyle(
          color: Colors.black,
          fontSize: 36
        ),),
        toolbarHeight: 100,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(
                  controller: _newtodocontroller,
                  decoration: InputDecoration(
                    contentPadding:  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.black
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.blue
                      ),
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                )),
                const SizedBox(width: 20,),
                FloatingActionButton(onPressed: (){
                    addtodo();
                    _newtodocontroller.clear();
                }, child: const Icon(Icons.add),)
              ],
            ),
            _isloading ? const Expanded(
              child: Center(child: CircularProgressIndicator()),
              
            ) : Expanded(
              child: _todosList.isEmpty ? Center(child: Text('No Todo list available'),) : ListView.builder(
                itemCount: _todosList.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Checkbox(
                          value: _todosList[index].isChecked,
                          onChanged: (value) {
                            setState((){
                              Provider.of<Todosprovider>(context, listen: false).updateTodo(_todosList[index].id!, _todosList[index].title!, value!);
                              }
                            );
                          },
                        ),
                        title: _todosList[index].isEditing ? TextFormField(
                          focusNode: _todosList[index].focusnode,
                          keyboardType: TextInputType.text,
                          controller: _todosList[index].controller,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value){
                            _todosList[index].focusnode!.unfocus();
                            Provider.of<Todosprovider>(context, listen: false).updateTodo(_todosList[index].id!, _todosList[index].controller!.text ,_todosList[index].isChecked!);
                            setState(() {
                              _todosList[index].isEditing = false;
                            });
                          },
                          
                        ) : Text(_todosList[index].title.toString()),
                        trailing: Wrap(
                          children: [
                            IconButton(onPressed: (){
                              _todosList[index].focusnode!.requestFocus();
                              setState(() {
                                _todosList[index].isEditing = true;
                              });
                            }, icon: Icon(Icons.edit_sharp)),
                            IconButton(onPressed: (){
                             setState(() {
                                Provider.of<Todosprovider>(context, listen: false).deleteTodo(_todosList[index].id!);
                             });
                            }, icon: Icon(Icons.delete))
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            )
          ],
        ),
      ),
    );
  }
}