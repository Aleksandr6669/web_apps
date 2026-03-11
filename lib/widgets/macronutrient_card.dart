import 'package:flutter/material.dart';

class MacronutrientCard extends StatelessWidget {
  final String name;
  final String value;
  final String total;
  final double percentage;
  final Color color;

  const MacronutrientCard({
    super.key,
    required this.name,
    required this.value,
    required this.total,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: Theme.of(context).textTheme.bodySmall),
                Text('${(percentage * 100).toInt()}%', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: color.withOpacity(0.2),
              color: color,
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' / $total', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
