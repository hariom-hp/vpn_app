import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vpn_provider.dart';
import '../models/server.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final vpnState = ref.watch(vpnProvider);
    final vpnNotifier = ref.read(vpnProvider.notifier);

    final isConnected = vpnState.isConnected;
    final selectedServer = vpnState.selectedServer?.name ?? 'Automatic';
    final connectionStatus = _getConnectionStatusText(vpnState.status);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RUKUS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      foregroundColor: Colors.blue,
                    ),
                    child: Row(
                      children: [
                        const Text('Go Pro'),
                        const SizedBox(width: 4),
                        Icon(Icons.card_giftcard, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Connection status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    connectionStatus,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(vpnState.status, context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Server: $selectedServer',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  if (isConnected && vpnState.connectedSince != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Connected for: ${vpnState.formattedDuration}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Server Selection Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.grey[900],
                child: ListTile(
                  leading: Text(vpnState.selectedServer?.flag ?? '🌐'),
                  title: Text(
                    vpnState.selectedServer?.name ?? 'Automatic',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    vpnState.selectedServer?.country ?? 'Best Location',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white),
                  onTap: () async {
                    final result =
                        await Navigator.pushNamed(context, '/server_list');
                    if (result != null && result is String) {
                      // Find the server by name and select it
                      final server = _getServerByName(result);
                      if (server != null) {
                        vpnNotifier.selectServer(server);
                      }
                    }
                  },
                ),
              ),
            ),

            // Speed Indicators
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSpeedIndicator(Icons.arrow_downward, '28.5', 'KB/S'),
                  _buildSpeedIndicator(Icons.arrow_upward, '28.5', 'KB/S'),
                ],
              ),
            ),

            // World Map (Placeholder)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '🗺️ World Map',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),

            // Connect Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GestureDetector(
                onTap: () {
                  if (isConnected) {
                    vpnNotifier.disconnect();
                  } else {
                    // If no server is selected, use a default one
                    if (vpnState.selectedServer == null) {
                      vpnNotifier.selectServer(
                        Server(
                          name: 'United States',
                          country: 'New York',
                          flag: '🇺🇸',
                          ping: 120,
                        ),
                      );
                    }
                    vpnNotifier.connect();
                  }
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isConnected ? Colors.green : Colors.purple,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        size: 40,
                        color: isConnected ? Colors.green : Colors.purple,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isConnected && vpnState.connectedSince != null
                            ? vpnState.formattedDuration
                            : '00:00:00',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Profile action
                    },
                    child: _buildNavItem(Icons.person, false),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Home is current screen
                    },
                    child: _buildNavItem(Icons.home, true),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    child: _buildNavItem(Icons.settings, false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getConnectionStatusText(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return 'Connected';
      case ConnectionStatus.connecting:
        return 'Connecting...';
      case ConnectionStatus.disconnecting:
        return 'Disconnecting...';
      case ConnectionStatus.error:
        return 'Connection Error';
      case ConnectionStatus.disconnected:
      return 'Not Connected';
    }
  }

  Color _getStatusColor(ConnectionStatus status, BuildContext context) {
    switch (status) {
      case ConnectionStatus.connected:
        return Colors.green;
      case ConnectionStatus.connecting:
      case ConnectionStatus.disconnecting:
        return Colors.orange;
      case ConnectionStatus.error:
        return Theme.of(context).colorScheme.error;
      case ConnectionStatus.disconnected:
      // ignore: unreachable_switch_default
      default:
        return Theme.of(context).colorScheme.error;
    }
  }

  Server? _getServerByName(String name) {
    // This is a simplified version. In a real app, you would get this from a repository or service
    final servers = [
      Server(name: 'Automatic', country: 'Best Location', flag: '🌐', ping: 0),
      Server(
          name: 'United States', country: 'New York', flag: '🇺🇸', ping: 120),
      Server(name: 'United Kingdom', country: 'London', flag: '🇬🇧', ping: 85),
    ];

    return servers.firstWhere(
      (server) => server.name == name,
      orElse: () => servers.first,
    );
  }

  Widget _buildSpeedIndicator(IconData icon, String speed, String unit) {
    return Column(
      children: [
        Icon(icon, color: Colors.purple),
        const SizedBox(height: 4),
        Text(
          speed,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Icon(
      icon,
      color: isActive ? Colors.purple : Colors.grey[600],
      size: 28,
    );
  }
}
