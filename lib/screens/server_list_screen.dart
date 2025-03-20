import 'package:flutter/material.dart';
import '../models/server.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  String selectedServer = 'Automatic';
  List<Server> servers = [
    Server(
      name: 'Automatic',
      country: 'Best Location',
      flag: '🌐',
      ping: 0,
    ),
    Server(
      name: 'United States',
      country: 'New York',
      flag: '🇺🇸',
      ping: 120,
    ),
    Server(
      name: 'United Kingdom',
      country: 'London',
      flag: '🇬🇧',
      ping: 85,
    ),
    Server(
      name: 'Germany',
      country: 'Frankfurt',
      flag: '🇩🇪',
      ping: 65,
    ),
    Server(
      name: 'Japan',
      country: 'Tokyo',
      flag: '🇯🇵',
      ping: 210,
    ),
    Server(
      name: 'Singapore',
      country: 'Singapore',
      flag: '🇸🇬',
      ping: 180,
    ),
    Server(
      name: 'Australia',
      country: 'Sydney',
      flag: '🇦🇺',
      ping: 240,
    ),
    Server(
      name: 'Canada',
      country: 'Toronto',
      flag: '🇨🇦',
      ping: 140,
    ),
    Server(
      name: 'France',
      country: 'Paris',
      flag: '🇫🇷',
      ping: 90,
    ),
    Server(
      name: 'Netherlands',
      country: 'Amsterdam',
      flag: '🇳🇱',
      ping: 75,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Server'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search servers',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                // Filter servers based on search
              },
            ),
          ),

          // Server list
          Expanded(
            child: ListView.builder(
              itemCount: servers.length,
              itemBuilder: (context, index) {
                final server = servers[index];
                return ListTile(
                  leading: Text(
                    server.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(server.name),
                  subtitle: Text(server.country),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (server.ping > 0)
                        Text(
                          '${server.ping} ms',
                          style: TextStyle(
                            color: _getPingColor(server.ping),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (selectedServer == server.name)
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedServer = server.name;
                    });
                    // Return selected server to previous screen
                    Navigator.pop(context, server.name);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getPingColor(int ping) {
    if (ping < 100) {
      return Colors.green;
    } else if (ping < 200) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
