import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/widgets/buttons/primary_button.dart';
import '../../core/widgets/inputs/currency_textfield.dart';
import '../../core/widgets/inputs/date_picker_field.dart';
import '../../core/widgets/inputs/category_dropdown.dart';
import '../../core/widgets/inputs/app_textfield.dart';
import '../../core/widgets/layout/app_scaffold.dart';
import '../../core/widgets/navigation/custom_appbar.dart';
import '../../core/widgets/snackbars/app_snackbar.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  final TransactionModel? initialTransaction;

  const AddTransactionPage({Key? key, this.initialTransaction}) : super(key: key);

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Food';
  String transactionType = 'expense';

  final categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Health',
    'Education',
    'Utilities',
    'Other',
  ];

  final categoryIcons = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Shopping': Icons.shopping_bag,
    'Entertainment': Icons.movie,
    'Health': Icons.favorite,
    'Education': Icons.school,
    'Utilities': Icons.bolt,
    'Other': Icons.category,
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialTransaction != null) {
      titleController = TextEditingController(text: widget.initialTransaction!.title);
      amountController = TextEditingController(
        text: widget.initialTransaction!.amount.toString(),
      );
      descriptionController = TextEditingController(text: widget.initialTransaction!.description);
      selectedDate = widget.initialTransaction!.dateTime;
      selectedCategory = widget.initialTransaction!.category;
      transactionType = widget.initialTransaction!.type;
    } else {
      titleController = TextEditingController();
      amountController = TextEditingController();
      descriptionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    if (titleController.text.isEmpty || amountController.text.isEmpty) {
      AppSnackbar.showError(context, 'Please fill all required fields');
      return;
    }

    final amount = double.tryParse(
      amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    if (amount == null || amount <= 0) {
      AppSnackbar.showError(context, 'Please enter a valid amount');
      return;
    }

    final transaction = TransactionModel(
      id: widget.initialTransaction?.id ?? const Uuid().v4(),
      title: titleController.text,
      amount: amount,
      category: selectedCategory,
      dateTime: selectedDate,
      description: descriptionController.text,
      type: transactionType,
    );

    try {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.addTransaction(transaction);
      ref.refresh(transactionsProvider);

      AppSnackbar.showSuccess(
        context,
        widget.initialTransaction != null ? 'Transaction updated' : 'Transaction added',
      );

      Navigator.pop(context);
    } catch (e) {
      AppSnackbar.showError(context, 'Failed to save transaction');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: widget.initialTransaction != null ? 'Edit Transaction' : 'Add Transaction',
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Type Toggle
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const <ButtonSegment<String>>[
                        ButtonSegment<String>(
                          value: 'expense',
                          label: Text('Expense'),
                          icon: Icon(Icons.arrow_downward),
                        ),
                        ButtonSegment<String>(
                          value: 'income',
                          label: Text('Income'),
                          icon: Icon(Icons.arrow_upward),
                        ),
                      ],
                      selected: <String>{transactionType},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          transactionType = newSelection.first;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title
              AppTextField(
                label: 'Transaction Title',
                hint: 'e.g., Lunch at cafe',
                controller: titleController,
              ),
              const SizedBox(height: 16),

              // Amount
              CurrencyTextField(
                label: 'Amount',
                controller: amountController,
              ),
              const SizedBox(height: 16),

              // Category
              CategoryDropdown(
                label: 'Category',
                initialValue: selectedCategory,
                categories: categories,
                categoryIcons: categoryIcons,
                onCategoryChanged: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date
              DatePickerField(
                label: 'Date',
                initialDate: selectedDate,
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Description
              AppTextField(
                label: 'Description',
                hint: 'Add notes (optional)',
                controller: descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Save Button
              PrimaryButton(
                label: widget.initialTransaction != null ? 'Update' : 'Save Transaction',
                onPressed: _saveTransaction,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
