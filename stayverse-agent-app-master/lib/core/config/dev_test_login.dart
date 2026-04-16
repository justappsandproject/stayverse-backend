import 'package:flutter/foundation.dart';
import 'package:stayvers_agent/core/config/appEnviroment/enviroment.dart';

/// Local demo agents — only when `mode=dev` in `.env` and running a debug build.
bool get kDevTestLoginEnabled => kDebugMode && environment.isDev;

class DevTestAgentAccount {
  const DevTestAgentAccount({
    required this.label,
    required this.email,
    required this.password,
  });

  final String label;
  final String email;
  final String password;
}

const List<DevTestAgentAccount> kDevTestAgentAccounts = [
  DevTestAgentAccount(
    label: 'Chef',
    email: 'agent.chef@stayverse.local',
    password: 'Pass1234!',
  ),
  DevTestAgentAccount(
    label: 'Apartment',
    email: 'agent.apartment@stayverse.local',
    password: 'Pass1234!',
  ),
  DevTestAgentAccount(
    label: 'Ride',
    email: 'agent.ride@stayverse.local',
    password: 'Pass1234!',
  ),
];
