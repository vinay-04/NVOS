import 'package:flutter/material.dart';
import 'package:nvos/model/supabaseHandler.dart';

class Balance extends StatefulWidget {
  const Balance({super.key});

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  SupabaseHandler supabaseHandler = SupabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Text("data");
  }
}
