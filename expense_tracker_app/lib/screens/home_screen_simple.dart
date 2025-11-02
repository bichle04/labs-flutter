import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../widgets/expense_chart.dart';
import 'add_edit_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Consumer<ExpenseProvider>(
                builder: (context, expenseProvider, _) {
                  return Text(
                    'Total: \$${expenseProvider.totalExpenses.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'Expenses'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
        ),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildExpensesList(context, expenseProvider),
              _buildAnalytics(context, expenseProvider),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddExpense(context),
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildExpensesList(
    BuildContext context,
    ExpenseProvider expenseProvider,
  ) {
    if (expenseProvider.expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No expenses yet',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first expense',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToAddExpense(context),
              child: const Text('Add First Expense'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: expenseProvider.expenses.length,
      itemBuilder: (context, index) {
        final expense = expenseProvider.expenses[index];
        return _buildExpenseCard(context, expense, expenseProvider);
      },
    );
  }

  Widget _buildExpenseCard(
    BuildContext context,
    Expense expense,
    ExpenseProvider expenseProvider,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');
    final categoryColor = _getCategoryColor(expense.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(expense.category),
            color: categoryColor,
            size: 24,
          ),
        ),
        title: Text(
          expense.title,
          style: Theme.of(context).textTheme.headlineSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              expense.category,
              style: TextStyle(
                color: categoryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${dateFormat.format(expense.date)} • ${timeFormat.format(expense.date)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${expense.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _navigateToEditExpense(context, expense);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, expense, expenseProvider);
                }
              },
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () => _navigateToEditExpense(context, expense),
      ),
    );
  }

  Widget _buildAnalytics(
    BuildContext context,
    ExpenseProvider expenseProvider,
  ) {
    return Column(
      children: [
        // Stats Cards đơn giản
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Spent',
                  '\$${expenseProvider.totalExpenses.toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Transactions',
                  '${expenseProvider.expenses.length}',
                  Icons.receipt_long,
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ExpenseChart(
            expenses: expenseProvider.expenses,
            categoryTotals: expenseProvider.getTotalByCategory(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddExpense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditExpenseScreen()),
    );
  }

  void _navigateToEditExpense(BuildContext context, Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditExpenseScreen(expense: expense),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Expense expense,
    ExpenseProvider expenseProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Are you sure you want to delete "${expense.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              expenseProvider.deleteExpense(expense.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Expense deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    const colors = {
      'Food & Dining': Color(0xFFE57373),
      'Transportation': Color(0xFF64B5F6),
      'Shopping': Color(0xFFBA68C8),
      'Entertainment': Color(0xFFFFB74D),
      'Bills & Utilities': Color(0xFF90A4AE),
      'Healthcare': Color(0xFFF06292),
      'Education': Color(0xFF7986CB),
      'Travel': Color(0xFF81C784),
    };
    return colors[category] ?? Colors.grey;
  }

  IconData _getCategoryIcon(String category) {
    const icons = {
      'Food & Dining': Icons.restaurant,
      'Transportation': Icons.directions_car,
      'Shopping': Icons.shopping_bag,
      'Entertainment': Icons.movie,
      'Bills & Utilities': Icons.receipt,
      'Healthcare': Icons.local_hospital,
      'Education': Icons.school,
      'Travel': Icons.flight,
    };
    return icons[category] ?? Icons.category;
  }
}
