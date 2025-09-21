import 'package:flutter/material.dart';

class EmptyStateMessage extends StatelessWidget {
  final String message;

  const EmptyStateMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[600], fontSize: 18),
      ),
    );
  }
}
