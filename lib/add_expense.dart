import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDatabase {
  static Future<Database> openDB() async {
    String folder = await getDatabasesPath();
    String path = join(folder, 'expense_1.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
           CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL
          )
        ''');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> readExpense() async {
    Database db = await openDB();
    return await db.query('expenses');
  }

  static Future<int> addExpense(Map<String, dynamic> data) async {
    Database db = await openDB();
    return await db.insert('expenses', data);
  }

  static Future<int> deleteExpense(int id) async {
    Database db = await openDB();
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}

class AddExpense extends StatefulWidget {
  final Map<String, dynamic>? expenses;
  const AddExpense({super.key, this.expenses});

  @override
  State<AddExpense> createState() => _AddExpenseState(expenses);
}

class _AddExpenseState extends State<AddExpense> {
  final Map<String, dynamic>? expenses;
  _AddExpenseState(this.expenses);
  final TextEditingController expenseType = TextEditingController();
  final TextEditingController expenseAmount = TextEditingController();
  int? editingId;
  @override
  void initState() {
    super.initState();
    if (expenses != null) {
      editingId = expenses!['id'];
      expenseType.text = expenses!['name']?.toString() ?? '';
      expenseAmount.text = expenses!['phone']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    expenseType.dispose();
    expenseAmount.dispose();
    super.dispose();
  }

  Future<void> saveButton(BuildContext context) async {
    final title = expenseType.text.trim();
    final amount = double.tryParse(expenseAmount.text.trim());

    if (title.isEmpty || amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter an expense title and a valid amount.'),
        ),
      );
      return;
    }

    final data = {'title': title, 'amount': amount};

    try {
      int? id = editingId;
      id ??= await ExpenseDatabase.addExpense(data);

      if (context.mounted) {
        Navigator.pop(context, {'id': id, 'title': title, 'amount': amount});
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save expense: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: const Color(0xFFF6F7F9),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: expenseType,
            decoration: const InputDecoration(
              labelText: 'Expense title',
              hintText: 'e.g. Groceries',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: expenseAmount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: '0.00',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () {
                saveButton(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF176B55),
              ),
              child: const Text('Save Expense'),
            ),
          ),
        ],
      ),
    );
  }
}
