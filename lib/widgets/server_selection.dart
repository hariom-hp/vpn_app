import 'package:flutter/material.dart';

class ServerSelection extends StatelessWidget {
  final String selectedServer;
  final Function(String) onServerSelected;
  final VoidCallback onViewAllPressed;

  const ServerSelection({
    super.key,
    required this.selectedServer,
    required this.onServerSelected,
    required this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Server',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewAllPressed,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick server selection
          _buildServerOption(
            context,
            name: 'Automatic',
            flag: '🌐',
            isSelected: selectedServer == 'Automatic',
            onTap: () => onServerSelected('Automatic'),
          ),
          _buildServerOption(
            context,
            name: 'United States',
            flag: '🇺🇸',
            isSelected: selectedServer == 'United States',
            onTap: () => onServerSelected('United States'),
          ),
          _buildServerOption(
            context,
            name: 'United Kingdom',
            flag: '🇬🇧',
            isSelected: selectedServer == 'United Kingdom',
            onTap: () => onServerSelected('United Kingdom'),
          ),
        ],
      ),
    );
  }

  Widget _buildServerOption(
    BuildContext context, {
    required String name,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
