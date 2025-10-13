import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const Header({required this.title, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Adicionar"),
              onPressed: onPressed,
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
