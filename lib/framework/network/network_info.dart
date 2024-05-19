// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';
import 'package:global_configs/global_configs.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../config/global_vars.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  String get dnsResolveAddresses;
  Stream<InternetConnectionStatus> get onInternetStatusChange;
  void addGlobalDns(List<AddressCheckOptions> addresses);
}

class NetworkInfoImpl implements NetworkInfo {
  late Duration checkInterval;
  NetworkInfoImpl(this.connectionChecker) {
    final List<AddressCheckOptions> globalAddresses =
        _getDefaultHostAddresses();

    if (globalAddresses != null && globalAddresses.isNotEmpty) {
      connectionChecker.addresses = globalAddresses;
    }
    checkInterval = _getDefaultCheckInterval();
  }

  final InternetConnectionChecker connectionChecker;

  @override
  String get dnsResolveAddresses => connectionChecker.addresses.toString();

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  void addGlobalDns(List<AddressCheckOptions> addresses) {
    if (addresses != null && addresses.isNotEmpty) {
      for (var element in addresses) {
        if (!connectionChecker.addresses.contains(element)) {
          connectionChecker.addresses.insert(0, element);
        }
      }
    }
  }

  @override
  Stream<InternetConnectionStatus> get onInternetStatusChange =>
      connectionChecker.onStatusChange;

  List<AddressCheckOptions> _getDefaultHostAddresses() {
    // LOAD CONNECTION CHECKER PRIMARY DNS
    final appConfig = GlobalConfigs();
    List<AddressCheckOptions> addresses = [];

    if (appConfig.get(GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED)) {
      final String jsonHosts =
          appConfig.get(GlobalVars.CONFIG_CONNECTION_CHECKER_IP_ADDRESSES);

      if (jsonHosts.isNotEmpty) {
        List hosts = jsonDecode(jsonHosts);

        if (hosts.isNotEmpty) {
          addresses = hosts
              .map(
                (json) => AddressCheckOptions(
                  address: InternetAddress(json["host"]),
                  port: json["port"],
                  timeout: Duration(seconds: json["timeout_secs"]),
                ),
              )
              .toList();
        }
      }
    } else {
      addresses.add(
        AddressCheckOptions(
          address: InternetAddress(
              '103.77.78.212'), // Default Nitoza Application Server
          port: 80,
          timeout: const Duration(seconds: 10),
        ),
      );
    }

    return addresses;
  }

  Duration _getDefaultCheckInterval() {
    // LOAD CONNECTION CHECKER PRIMARY DNS
    final appConfig = GlobalConfigs();

    if (appConfig.get(GlobalVars.CONFIG_CONNECTION_CHECKER_ENABLED)) {
      final interval = GlobalConfigs()
          .get(GlobalVars.CONFIG_CONNECTION_CHECKER_INTERVAL_IN_SEC);
      return Duration(seconds: interval);
    } else {
      return connectionChecker.checkInterval;
    }
  }
}
