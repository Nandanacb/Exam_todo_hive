import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TodoExample extends StatefulWidget{
  @override
  State<TodoExample> createState()=> _TodoExampleState();
}
class _TodoExampleState extends State<TodoExample>{
  late Box box;
  TextEditingController controller=TextEditingController();
  List<String> _todoItems=[];

@override
void initState(){
  super.initState();
  box=Hive.box('mybox');
  loadTodoItem();

}
loadTodoItem(){
  List<String>? tasks= box.get('todoItems')?.cast<String>();
  
  if(tasks!=null){
    setState(() {
      _todoItems=tasks;
    });
  }
  
}

saveTodoItems(){
  
  box.put('todoItems', _todoItems);
}

void _addTodoItems(String tasks){
  setState(() {
    _todoItems.add(tasks);
  });
  saveTodoItems();
  controller.clear();
}

void _removeTodoItems(int index){
  setState(() {
    _todoItems.removeAt(index);
  });
  saveTodoItems();
}
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO EXAMPLE USING HIVE"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(border: OutlineInputBorder()),),
                ),
                SizedBox(width: 10,),
                TextButton(onPressed: (){
                  _addTodoItems(controller.text);
                }, child: Icon(Icons.add)),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context,index){
                 return ListTile(
                  title: Text(_todoItems[index]),
                  trailing: GestureDetector(
                    onTap: () {
                      _removeTodoItems(index);
                    },
                    child: Icon(Icons.delete),
                  ),
                 );
              }),
            )
          ],
        ),
      ),
    );
  }
}