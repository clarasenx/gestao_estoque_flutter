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
  final double padding;

  Select({
    super.key,
    required this.initialValue,
    required this.items,
    required this.label,
    required this.onChanged,
    this.disable = false,
    this.isRequired = true,
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: DropdownButtonFormField<Type>(
        initialValue: initialValue,
        isExpanded: true,
        items: items
            .map(
              (item) => DropdownMenuItem<Type>(
                value: item.value,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  child: Text(
                    item.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
        validator: (value) =>
            value == null && isRequired ? "Selecione um Item" : null,
      ),
    );
  }
}
