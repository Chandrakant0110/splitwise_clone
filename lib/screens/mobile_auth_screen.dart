import 'package:flutter/material.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:uuid/uuid.dart';

class MobileAuthScreen extends StatefulWidget {
  const MobileAuthScreen({super.key});

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> trueCallerService() async {
    TcSdk.initializeSDK(sdkOption: TcSdkOptions.OPTION_VERIFY_ALL_USERS);
  }

  Future<void> initiateTruecallerLogin() async {
    bool isOAuthFlowUsable = await TcSdk.isOAuthFlowUsable;
    if (isOAuthFlowUsable) {
      String oAuthState = Uuid().v4(); // Generate unique state
      TcSdk.setOAuthState(oAuthState);
      TcSdk.setOAuthScopes(['profile', 'phone', 'openid']);

      String? codeVerifier = await TcSdk.generateRandomCodeVerifier;
      if (codeVerifier != null) {
        String? codeChallenge = await TcSdk.generateCodeChallenge(codeVerifier);
        if (codeChallenge != null) {
          TcSdk.setCodeChallenge(codeChallenge);
          TcSdk.getAuthorizationCode; // Start OAuth flow
        }
      }
    } else {
      print("OAuth flow is not usable on this device.");
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(children: [Spacer(), Text('Mobile Auth Screen'), Spacer()]),
    );
  }
}
