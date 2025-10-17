import 'package:flutter/material.dart';

class Item<Type> {
  final Type value;
  final String text;

  const Item({required this.value, required this.text});
}

class Select<Type> extends StatelessWidget {
  Type? initialValue;
  final List<Item<Type>> items;
  final String label;
  final bool disable;
  final bool isRequired;
  final Function(Type value) onChanged;

  Select({
    super.key,
    required this.initialValue,
    required this.items,
    required this.label,
    required this.onChanged,
    this.disable = false,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField<Type>(
        initialValue: initialValue,
        items: items
            .map(
              (item) => DropdownMenuItem<Type>(
                value: item.value,
                child: Text(item.text),
              ),
            )
            .toList(),
        onChanged: disable
            ? null
            : (value) {
                if (value == null) return;
                onChanged(value);
              },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null && isRequired ? "Selecione um Item" : null,
      ),
    );
  }
}
