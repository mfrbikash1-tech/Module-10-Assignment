import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_expense.dart';

class _DemoExpense {
  const _DemoExpense(this.title, this.amount);

  final String title;
  final double amount;
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<_DemoExpense> _expenses = [];

  @override
  Widget build(BuildContext context) {
    double totalExpenses = 0;
    for (final expense in _expenses) {
      totalExpenses += expense.amount;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFFF6F7F9),
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF176B55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL EXPENSES',
                    style: TextStyle(
                      color: Color(0xFFD4EEE5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'TK $totalExpenses',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Recent expenses',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
              itemCount: _expenses.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final expense = _expenses[index];

                return Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE7F3EF),
                      child: Icon(Icons.receipt_long, color: Color(0xFF176B55)),
                    ),
                    title: Text(
                      expense.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Expense'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'TK ${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          tooltip: 'Delete expense',
                          onPressed: () {
                            setState(() {
                              _expenses.removeAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final savedExpense = await Navigator.of(context)
              .push<Map<String, Object?>>(
                MaterialPageRoute(builder: (context) => const AddExpense()),
              );

          if (savedExpense == null || !mounted) {
            return;
          }

          final title = savedExpense['title'] as String;
          final amount = (savedExpense['amount'] as num).toDouble();

          setState(() {
            _expenses.add(_DemoExpense(title, amount));
          });
        },
        backgroundColor: const Color(0xFF176B55),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
