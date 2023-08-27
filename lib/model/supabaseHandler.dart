// ignore_for_file: unused_local_variable, deprecated_member_use
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  SupabaseHandler() {
    dotenv.load(fileName: ".env");
  }
  static String supabaseURL = dotenv.env['supabaseURL']!;
  static String supabaseKEY = dotenv.env['supabaseKEY']!;

  final client = SupabaseClient(supabaseURL, supabaseKEY);

  readData() async {
    var response = await client.from("Expense").select().execute();
    final expenseList = response.data as List;
    return expenseList;
  }

  addData(double amount, String note, bool isDebited, String dateTime) async {
    var response = client.from("Expense").insert({
      'amount': amount,
      'note': note,
      'isDebited': isDebited,
      'dateTime': dateTime
    }).execute();
  }
}
