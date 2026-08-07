import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../misc.dart';
import 'choose_custom_bank.dart';
import 'modals.dart';

class ChooseBankScreen extends StatefulWidget {
  final bool newAccount;

  const ChooseBankScreen({super.key, required this.newAccount});

  @override
  State<StatefulWidget> createState() => _ChooseBankScreenState();

}

class _ChooseBankScreenState extends State<ChooseBankScreen> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.dns_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Choose Bank", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(text: "Bank is where your Vaults are stored. "),
                    TextSpan(text: "More info",
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => WhatIsBeshenceModal()
                          );
                        }
                    ),
                    if (!widget.newAccount) TextSpan(text: "\n\nIf your account is located on several Vaults, choose whichever Bank you prefer."),
                    // TODO: if(widget.newAccount) TextSpan(text: "\n\nWant to set up your own Bank? "),
                    // TODO: if(widget.newAccount) TextSpan(text: "Click here", style: TextStyle(color: Colors.blue))
                  ]
              )
          ),
          SizedBox(height: 24,),
          ListTile(
            enabled: _enabled,
            leading: Icon(Icons.verified_outlined),
            title: Text("Official Beshence Bank"),
            subtitle: Text("Bank provided by Beshence developers"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () async {
              setState(() {
                _enabled = false;
              });
              try {
                await processBeshenceBank(context, "f3mao7t3xpbtctkvosxysfund4ndpuk7qbhluhyrnxikcz3ghqpa", widget.newAccount);
              } catch(e) {}
              setState(() {
                _enabled = true;
              });
            },
          ),
          ListTile(
            enabled: _enabled,
            leading: Icon(Icons.edit_outlined),
            title: Text("Custom Bank"),
            subtitle: Text("Choose your own bank"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => context.push("${widget.newAccount? "/register" : "/login"}/choose_custom_bank"),
          ),
          Divider(),
          ListTile(
            enabled: Beshence.banks.isNotEmpty && _enabled,
            leading: Icon(Icons.select_all_outlined),
            title: Text("Choose existing Bank"),
            subtitle: Text(Beshence.banks.isEmpty ? "No Banks added on this device" : "Select Bank already added on this device"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => context.push("${widget.newAccount? "/register" : "/login"}/choose_existing_bank"),
          ),
        ],
      ),
    );
  }
}