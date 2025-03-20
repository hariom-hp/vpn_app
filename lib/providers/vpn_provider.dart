import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/server.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error,
}

class VpnState {
  final ConnectionStatus status;
  final Server? selectedServer;
  final String errorMessage;
  final int downloadSpeed; // in Kbps
  final int uploadSpeed; // in Kbps
  final int ping; // in ms
  final DateTime? connectedSince;

  VpnState({
    this.status = ConnectionStatus.disconnected,
    this.selectedServer,
    this.errorMessage = '',
    this.downloadSpeed = 0,
    this.uploadSpeed = 0,
    this.ping = 0,
    this.connectedSince,
  });

  VpnState copyWith({
    ConnectionStatus? status,
    Server? selectedServer,
    String? errorMessage,
    int? downloadSpeed,
    int? uploadSpeed,
    int? ping,
    DateTime? connectedSince,
  }) {
    return VpnState(
      status: status ?? this.status,
      selectedServer: selectedServer ?? this.selectedServer,
      errorMessage: errorMessage ?? this.errorMessage,
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      ping: ping ?? this.ping,
      connectedSince: connectedSince ?? this.connectedSince,
    );
  }

  bool get isConnected => status == ConnectionStatus.connected;
  bool get isConnecting => status == ConnectionStatus.connecting;
  bool get isDisconnected => status == ConnectionStatus.disconnected;
  bool get isDisconnecting => status == ConnectionStatus.disconnecting;
  bool get hasError => status == ConnectionStatus.error;

  Duration get connectionDuration {
    if (connectedSince == null || !isConnected) {
      return Duration.zero;
    }
    return DateTime.now().difference(connectedSince!);
  }

  String get formattedDuration {
    final duration = connectionDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class VpnNotifier extends StateNotifier<VpnState> {
  VpnNotifier() : super(VpnState());

  void selectServer(Server server) {
    state = state.copyWith(selectedServer: server);
  }

  Future<void> connect() async {
    if (state.selectedServer == null) {
      state = state.copyWith(
        status: ConnectionStatus.error,
        errorMessage: 'No server selected',
      );
      return;
    }

    if (state.isConnected || state.isConnecting) {
      await disconnect();
    }

    state = state.copyWith(
      status: ConnectionStatus.connecting,
      errorMessage: '',
    );

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, you would connect to the VPN here
    // using a VPN service like OpenVPN

    // Simulate successful connection
    state = state.copyWith(
      status: ConnectionStatus.connected,
      downloadSpeed: 8500,
      uploadSpeed: 3200,
      ping: 45,
      connectedSince: DateTime.now(),
    );
  }

  Future<void> disconnect() async {
    if (state.isDisconnected || state.isDisconnecting) {
      return;
    }

    state = state.copyWith(
      status: ConnectionStatus.disconnecting,
    );

    // Simulate disconnection delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would disconnect from the VPN here

    // Simulate successful disconnection
    state = state.copyWith(
      status: ConnectionStatus.disconnected,
      downloadSpeed: 0,
      uploadSpeed: 0,
      ping: 0,
      connectedSince: null,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: ConnectionStatus.error,
      errorMessage: message,
    );
  }
}

final vpnProvider = StateNotifierProvider<VpnNotifier, VpnState>((ref) {
  return VpnNotifier();
});
