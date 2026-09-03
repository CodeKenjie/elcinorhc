import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final String title;
  final bool state;
  final DateTime createdAt;
  final DateTime expiresAt;

  const TodoCard({ 
    super.key,
    required this.title,
    required this.state,
    required this.createdAt,
    required this.expiresAt
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(5),
        border: Border(
          bottom: BorderSide(color: Colors.black)
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: state, 
            onChanged:(value) => {},
          ),
          Text ( title )
        ],
      ),
    );
  }
}