enum EnumExpenseCategory {
  home,
  transport,
  health,
  education,
  fun,
  food,
  clothing,
  technology,
  creditCard,
}

class Transaction {
  final String id;
  final String title;
  final double value;
  final DateTime date;
  final String expenseCategory;

  Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
    required this.expenseCategory,
  });
}
