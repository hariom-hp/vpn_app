import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class ConnectionStats extends StatefulWidget {
  const ConnectionStats({super.key});

  @override
  State<ConnectionStats> createState() => _ConnectionStatsState();
}

class _ConnectionStatsState extends State<ConnectionStats> {
  final Random _random = Random();

  // Simulated data
  final int _downloadSpeed = 8500; // in Kbps
  final int _uploadSpeed = 3200; // in Kbps
  final int _ping = 45; // in ms

  List<FlSpot> _generateRandomData() {
    final List<FlSpot> spots = [];
    for (int i = 0; i < 10; i++) {
      spots.add(FlSpot(i.toDouble(), _random.nextDouble() * 10));
    }
    return spots;
  }

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
          const Text(
            'Connection Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Speed stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.download,
                value: '${(_downloadSpeed / 1000).toStringAsFixed(1)} Mbps',
                label: 'Download',
                color: Colors.green,
              ),
              _buildStatItem(
                icon: Icons.upload,
                value: '${(_uploadSpeed / 1000).toStringAsFixed(1)} Mbps',
                label: 'Upload',
                color: Colors.blue,
              ),
              _buildStatItem(
                icon: Icons.network_ping,
                value: '$_ping ms',
                label: 'Ping',
                color: Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Traffic chart
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateRandomData(),
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color:
                Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
