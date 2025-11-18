import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String buttonDescription;
  final void Function()? onPressed;

  const Header({
    required this.title, 
    this.buttonDescription = "Adicionar",
    this.onPressed, 
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            FilledButton.icon(
              icon: Icon(Icons.add),
              label: Text(buttonDescription),
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blueAccent, // cor de fundo
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
