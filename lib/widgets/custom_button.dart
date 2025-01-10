import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final Color textColor; // Optional parameter for text color

  const CustomButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.textColor =
        const Color.fromARGB(255, 0, 0, 0), // Default text color is black
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor, // Use the provided textColor
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
