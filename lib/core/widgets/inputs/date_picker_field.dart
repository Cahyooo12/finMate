import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final void Function(DateTime) onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerField({
    Key? key,
    required this.label,
    this.initialDate,
    required this.onDateChanged,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate ?? DateTime(2020),
      lastDate: widget.lastDate ?? DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            hintText: DateFormat('dd/MM/yyyy').format(_selectedDate),
            prefixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }
}
