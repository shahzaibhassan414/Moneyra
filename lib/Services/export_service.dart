import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  static Future<void> exportToCsv(List<Map<String, dynamic>> transactions, {Rect? sharePositionOrigin}) async {
    if (transactions.isEmpty) {
      throw Exception('No transactions to export');
    }

    // 1. Define Headers
    List<List<dynamic>> rows = [];
    rows.add(["Date", "Category", "Amount", "Type", "Note"]);

    // 2. Add Data Rows (Includes both Expenses and Income/Salary)
    for (var tx in transactions) {
      final DateTime date = (tx['date'] as dynamic)?.toDate() ?? DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
      final String type = tx['type'] ?? 'expense';
      final double amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
      
      // We can prefix the amount with + or - for better readability in Excel
      final String sign = (type == 'income') ? "+" : "-";

      rows.add([
        formattedDate,
        tx['category'] ?? 'Other',
        "$sign$amount",
        type.toUpperCase(),
        tx['note'] ?? '',
      ]);
    }

    // 3. Convert to CSV String
    String csvData = const ListToCsvConverter().convert(rows);

    // 4. Save to temporary file
    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/moneyra_export_${DateTime.now().millisecondsSinceEpoch}.csv";
    final file = File(path);
    await file.writeAsString(csvData);

    // 5. Share the file
    await Share.shareXFiles(
      [XFile(path)], 
      text: 'Moneyra Financial Export (Expenses & Income)',
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
