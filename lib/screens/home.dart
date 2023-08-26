import 'package:flutter/material.dart';
import 'package:nvos/model/supabaseHandler.dart';

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
                  supabaseHandler.addData(
                      double.parse(amount.text), note.text, false);
                },
                child: const Text('Credited'),
              ),
              MaterialButton(
                onPressed: () {
                  supabaseHandler.addData(
                      double.parse(amount.text), note.text, true);
                },
                child: const Text('Debited'),
              ),
            ],
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
      body: FutureBuilder(
        future: supabaseHandler.readData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black87,
              ),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          try {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.length ?? 0,
                itemBuilder: (context, index) {
                  return Container(
                    color: snapshot.data[index]['status']
                        ? Colors.white
                        : Colors.red,
                    child: Row(
                      children: [
                        Container(
                          width: 200,
                          child: Text(snapshot.data[index]['Expense']),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          } on Exception catch (_) {
            // make it explicit that this function can throw exceptions
            rethrow;
          }
        },
      ),
    );
  }
}

      // FutureBuilder(
      //   future: supabaseHandler.readData(),
      //   builder: (context, AsyncSnapshot snapshot) {
      //     return ListView.builder(
      //         itemCount:
      //             snapshot.data!.length == null ? 0 : snapshot.data.length,
      //         itemBuilder: (context, index) {
      //           return Container(
      //             color: snapshot.data[index]['status']
      //                 ? Colors.white
      //                 : Colors.red,
      //             child: Row(children: [
      //               Container(
      //                 width: 200,
      //                 child: Text(snapshot.data[index]['Expense']),
      //               )
      //             ]),
      //           );
      //         });
      //   },
      // ),