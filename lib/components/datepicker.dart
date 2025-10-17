import 'package:flutter/material.dart';

class Datepicker extends StatelessWidget {
  final TextEditingController dateController;
  final String? label;
  final Function(String stringDate, DateTime date) onSelectDate;
  final Function() onClearDate;

  const Datepicker({
    required this.dateController,
    required this.onSelectDate,
    required this.onClearDate,
    this.label,
    super.key,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // data inicial
      firstDate: DateTime(2000), // data mínima
      lastDate: DateTime(DateTime.now().year + 10), // até 10 anos no futuro
    );

    if (pickedDate != null) {
      final stringDate =
          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      onSelectDate(stringDate, pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: dateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label ?? "Data",
          border: const OutlineInputBorder(),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dateController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClearDate,
                ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }
}
