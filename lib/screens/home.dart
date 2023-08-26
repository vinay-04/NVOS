import 'package:flutter/material.dart';
import 'package:nvos/model/supabaseHandler.dart';
import 'package:nvos/screens/graph.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final amount = TextEditingController();
  final note = TextEditingController();
  SupabaseHandler supabaseHandler = SupabaseHandler();
  void addExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amount,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: note,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
          ],
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  supabaseHandler.addData(double.parse(amount.text), note.text,
                      false, DateTime.now().toString());
                  Navigator.of(context).pop();
                },
                child: const Text('Credited'),
              ),
              MaterialButton(
                onPressed: () {
                  supabaseHandler.addData(double.parse(amount.text), note.text,
                      true, DateTime.now().toString());
                  Navigator.of(context).pop();
                },
                child: const Text('Debited'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future refresh() async {
    setState(() {
      supabaseHandler.readData();
    });
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
      body: Column(
        children: [
          Graph(),
          FutureBuilder(
            future: supabaseHandler.readData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black87,
                  ),
                );
              }
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RefreshIndicator(
                    color: Colors.black87,
                    onRefresh: refresh,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: snapshot.data[index]['isDebited']
                                    ? Colors.red
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data[index]['amount'].toString(),
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                  const Spacer(),
                                  Text(
                                    snapshot.data[index]['note'],
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                  const Spacer(),
                                  Text(
                                    snapshot.data[index]['dateTime'],
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
                  ),
                );
              } else {
                throw Exception("Something went wrong");
              }
            },
          ),
        ],
      ),
    );
  }
}
