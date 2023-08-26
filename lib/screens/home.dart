import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _newAmount = TextEditingController();
  final _newNote = TextEditingController();

  void addData() {}
  void addExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _newAmount,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: _newNote,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: addData,
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black87,
        backgroundColor: Colors.black87,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.attach_money_sharp,
            ),
            label: 'Expense',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(80.0),
        child: FloatingActionButton(
          backgroundColor: Colors.black87,
          onPressed: addExpense,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
