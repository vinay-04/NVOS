import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  static String supabaseURL = "https://otgdfpqcnllfyjhxtmgh.supabase.co";
  static String supabaseKEY =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im90Z2RmcHFjbmxsZnlqaHh0bWdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTMwNjA5NjAsImV4cCI6MjAwODYzNjk2MH0.8NkW7ktlO0RqL6RbATbZlnW930gHZHSdwiHQNyFVvxs";

  final client = SupabaseClient(supabaseURL, supabaseKEY);

  readData() async {
    var response =
        await client.from("Expense").select().order('amount').execute();
    final expenseList = response.data as List;
    print(response.data);
    return expenseList;
  }

  addData(double amount, String note, bool isDebited) async {
    var response = client.from("Expense").insert(
        {'amount': amount, 'note': note, 'isDebited': isDebited}).execute();
    print(response);
  }
}
