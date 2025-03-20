import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool autoConnect = false;
  bool killSwitch = false;
  bool splitTunneling = false;
  String protocol = 'OpenVPN UDP';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // General settings section
          _buildSectionHeader('General Settings'),
          SwitchListTile(
            title: const Text('Auto-connect on startup'),
            subtitle:
                const Text('Automatically connect to VPN when app starts'),
            value: autoConnect,
            onChanged: (value) {
              setState(() {
                autoConnect = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Kill Switch'),
            subtitle: const Text('Block internet when VPN disconnects'),
            value: killSwitch,
            onChanged: (value) {
              setState(() {
                killSwitch = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Split Tunneling'),
            subtitle: const Text('Choose which apps use the VPN'),
            value: splitTunneling,
            onChanged: (value) {
              setState(() {
                splitTunneling = value;
              });
            },
          ),

          // Connection settings section
          _buildSectionHeader('Connection Settings'),
          ListTile(
            title: const Text('Protocol'),
            subtitle: Text(protocol),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showProtocolDialog();
            },
          ),

          // About section
          _buildSectionHeader('About'),
          ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.privacy_tip),
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            leading: const Icon(Icons.description),
            onTap: () {
              // Navigate to terms of service
            },
          ),
          ListTile(
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
            leading: const Icon(Icons.info),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showProtocolDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Protocol'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProtocolOption('OpenVPN UDP'),
              _buildProtocolOption('OpenVPN TCP'),
              _buildProtocolOption('IKEv2'),
              _buildProtocolOption('WireGuard'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProtocolOption(String protocolName) {
    return ListTile(
      title: Text(protocolName),
      trailing: protocol == protocolName
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        setState(() {
          protocol = protocolName;
        });
        Navigator.pop(context);
      },
    );
  }
}
