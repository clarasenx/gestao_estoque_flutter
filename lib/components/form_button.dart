import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const FormButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.blueAccent,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20, // altura do indicador
                width: 20, // largura do indicador
                child: CircularProgressIndicator(
                  strokeWidth: 2, // opcional, deixa mais fino
                ),
              )
            : const SizedBox(
                height: 40,
                width: double.infinity,
                child: Center(child: Text("Salvar")),
              ),
      ),
    );
  }
}
