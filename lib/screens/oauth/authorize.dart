import 'dart:convert';

import 'package:account_manager/misc.dart';
import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OauthAuthorizeScreen extends StatefulWidget {
  final Map<String, String> queryParameters;

  const OauthAuthorizeScreen({super.key, required this.queryParameters});

  @override
  State<StatefulWidget> createState() => _OauthAuthorizeScreenState();

}

class _OauthAuthorizeScreenState extends State<OauthAuthorizeScreen> {
  bool _showCode = false;
  String _code = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BeshenceDaemon.of(Beshence.selectedAccount!).startDaemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_circle_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Connect new app", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          if(_showCode) ...[
            Text("Copy text below to your app:"),
            SelectableText(_code)
          ] else ...[
            OverflowBar(
              alignment: .end,
              overflowAlignment: .end,
              spacing: 16,
              overflowSpacing: 0,
              overflowDirection: .up,
              children: [
                FilledButton(
                  onPressed: () {
                    String tokenId = Uuid().v4();
                    Beshence.selectedAccount!.issueToken(
                        tokenId: tokenId,
                        scope: widget.queryParameters["scope"]!);

                    Set<String> banks = {};
                    List<String> vaults = [];

                    for (BeshenceVault vault in Beshence.selectedAccount!.vaults) {
                      banks.add(vault.id);
                      vaults.add("${vault.bank.id}_${vault.id}");
                    }

                    var response = {
                      "token_id": tokenId,
                      "account_id": Beshence.selectedAccount!.id,
                      "banks": banks,
                      "vaults": vaults
                    };

                    setState(() {
                      _showCode = true;
                      _code = base64.encode(utf8.encode(jsonEncode(response)));
                    });
                  },
                  child: const Text('Continue'),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}