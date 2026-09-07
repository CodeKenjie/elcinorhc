import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/entities/tag.dart';

class TagCard extends StatelessWidget {
  final Tag? tag;
  final Function(BuildContext)? onDelete;

  const TagCard({ 
    super.key, 
    required this.tag,
    this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.lightBlueAccent,
      Colors.purpleAccent,
      Colors.deepPurpleAccent,
      Colors.orangeAccent,
      Colors.deepOrangeAccent,
      Colors.greenAccent,
      Colors.lightGreenAccent,
      Colors.amberAccent,
      Colors.yellowAccent,
    ];

    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: onDelete,
            icon: Icons.delete,
            backgroundColor: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          )
        ]
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary
        ),
        child: Row (
          children: [
            Icon(Icons.label, size: 20, color: colors[tag!.id % colors.length]),
            const SizedBox(width: 16),
            Text(
              tag!.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            )
          ],
        )
      )
    );
  }
}