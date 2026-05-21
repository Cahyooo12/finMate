import 'package:flutter/material.dart';

class CategoryDropdown extends StatefulWidget {
  final String label;
  final String? initialValue;
  final List<String> categories;
  final void Function(String) onCategoryChanged;
  final Map<String, IconData>? categoryIcons;

  const CategoryDropdown({
    Key? key,
    required this.label,
    this.initialValue,
    required this.categories,
    required this.onCategoryChanged,
    this.categoryIcons,
  }) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialValue ?? widget.categories.first;
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
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.categoryIcons?[_selectedCategory] ?? Icons.category),
          ),
          items: widget.categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Icon(widget.categoryIcons?[category] ?? Icons.category),
                  const SizedBox(width: 8),
                  Text(category),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCategory = value;
              });
              widget.onCategoryChanged(value);
            }
          },
        ),
      ],
    );
  }
}
