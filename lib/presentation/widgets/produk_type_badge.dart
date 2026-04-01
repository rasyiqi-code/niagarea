import 'package:flutter/material.dart';

class ProdukTypeBadge extends StatelessWidget {
  final bool isNiagarea;
  const ProdukTypeBadge({super.key, required this.isNiagarea});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isNiagarea ? theme.colorScheme.primary : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(100), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isNiagarea ? Icons.cloud_outlined : Icons.person_outline,
            size: 10,
            color: color.withAlpha(200),
          ),
          const SizedBox(width: 4),
          Text(
            isNiagarea ? 'NIAGAREA' : 'MANUAL',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color.withAlpha(200),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
