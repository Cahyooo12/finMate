import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String currencySymbol;
  final int decimalDigits;

  const CurrencyTextField({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
    this.currencySymbol = 'Rp ',
    this.decimalDigits = 0,
  }) : super(key: key);

  @override
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericValue.isEmpty) return '';
    final formatted = numericValue.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    return '${widget.currencySymbol}$formatted';
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
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: widget.validator,
          onChanged: (value) {
            final formatted = _formatCurrency(value);
            _controller.value = _controller.value.copyWith(
              text: formatted,
              selection: TextSelection.fromPosition(
                TextPosition(offset: formatted.length),
              ),
            );
            widget.onChanged?.call(value);
          },
          decoration: InputDecoration(
            hintText: '${widget.currencySymbol}0',
            prefixIcon: const Icon(Icons.attach_money),
          ),
        ),
      ],
    );
  }
}
