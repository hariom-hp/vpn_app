import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

// Local enum for our app's use
enum VpnStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error,
}

class VpnService {
  late OpenVPN _openVPN;
  VpnStatus _status = VpnStatus.disconnected;
  String _currentServer = '';
  String _errorMessage = '';

  // Singleton pattern
  static final VpnService _instance = VpnService._internal();

  factory VpnService() {
    return _instance;
  }

  VpnService._internal() {
    _initializeVpn();
  }

  void _initializeVpn() {
    _openVPN = OpenVPN(
      onVpnStatusChanged: (status) {
        _onVpnStatusChanged(status);
      },
      onVpnStageChanged: (stage, message) {
        _onVpnStageChanged(stage.toString(), message);
      },
    );

    _openVPN.initialize(
      groupIdentifier: 'group.com.securevpn',
      providerBundleIdentifier: 'com.securevpn.openvpn',
      localizedDescription: 'RUKUS',
    );
  }

  void _onVpnStatusChanged(dynamic vpnStatus) {
    debugPrint('VPN Status: $vpnStatus');

    // Map the package's VPNStatus to our local VpnStatus
    if (vpnStatus.toString().contains('CONNECTED')) {
      _status = VpnStatus.connected;
    } else if (vpnStatus.toString().contains('DISCONNECTED')) {
      _status = VpnStatus.disconnected;
    } else if (vpnStatus.toString().contains('CONNECTING')) {
      _status = VpnStatus.connecting;
    } else if (vpnStatus.toString().contains('DISCONNECTING')) {
      _status = VpnStatus.disconnecting;
    } else if (vpnStatus.toString().contains('ERROR')) {
      _status = VpnStatus.error;
    }
  }

  void _onVpnStageChanged(String stage, String message) {
    debugPrint('VPN Stage: $stage, Message: $message');

    if (stage == 'error') {
      _errorMessage = message;
      _status = VpnStatus.error;
    }
  }

  Future<void> connect(String server, String ovpnConfig) async {
    if (_status == VpnStatus.connected || _status == VpnStatus.connecting) {
      await disconnect();
    }

    _currentServer = server;
    _status = VpnStatus.connecting;

    try {
      _openVPN.connect(
        ovpnConfig,
        server,
        username: 'vpn',
        password: 'vpn',
      );
    } catch (e) {
      _status = VpnStatus.error;
      _errorMessage = e.toString();
      debugPrint('VPN Connection Error: $e');
    }
  }

  Future<void> disconnect() async {
    if (_status == VpnStatus.disconnected ||
        _status == VpnStatus.disconnecting) {
      return;
    }

    _status = VpnStatus.disconnecting;

    try {
      _openVPN.disconnect();
      _currentServer = '';
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('VPN Disconnection Error: $e');
    }
  }

  VpnStatus get status => _status;
  String get currentServer => _currentServer;
  String get errorMessage => _errorMessage;

  bool get isConnected => _status == VpnStatus.connected;
  bool get isConnecting => _status == VpnStatus.connecting;
  bool get isDisconnected => _status == VpnStatus.disconnected;
  bool get isDisconnecting => _status == VpnStatus.disconnecting;
  bool get hasError => _status == VpnStatus.error;
}
