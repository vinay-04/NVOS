import 'package:flutter/material.dart';
import 'package:nvos/model/supabaseHandler.dart';
import 'package:intl/intl.dart';

class showData extends StatefulWidget {
  const showData({super.key});

  @override
  State<showData> createState() => _showDataState();
}

class _showDataState extends State<showData> {
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
                  supabaseHandler.addData(-double.parse(amount.text), note.text,
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

  String checkDay(DateTime dateTime) {
    int weekday = dateTime.weekday.toInt();
    String format = "";
    switch (weekday) {
      case 1:
        format = "Mon, ";
      case 2:
        format = "Tue, ";
      case 3:
        format = "Wed, ";
      case 4:
        format = "Thu, ";
      case 5:
        format = "Fri, ";
      case 6:
        format = "Sat, ";
      case 7:
        format = "Sun, ";
    }

    return format += DateFormat('dd/mm/yy - kk:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
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
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: RefreshIndicator(
                color: Colors.black87,
                onRefresh: refresh,
                child: Column(
                  children: [
                    const Center(
                        child: Text(
                      "Expense Tracker",
                      style: TextStyle(fontSize: 36),
                    )),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: snapshot.data[index]['isDebited']
                                    ? const Color.fromARGB(26, 151, 141, 141)
                                    : const Color.fromARGB(125, 0, 248, 8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data[index]['amount'].toString(),
                                      style: const TextStyle(fontSize: 36),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    snapshot.data[index]['note'],
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      // snapshot.data[index]['dateTime'],
                                      checkDay(DateTime.parse(
                                          snapshot.data[index]['dateTime'])),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text(snapshot.error.toString()));
          }
        },
      ),
    );
  }
}
