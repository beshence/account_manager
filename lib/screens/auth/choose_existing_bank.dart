import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../misc.dart';
import 'choose_custom_bank.dart';
import 'modals.dart';

class ChooseExistingBankScreen extends StatefulWidget {
  final bool newAccount;

  const ChooseExistingBankScreen({super.key, required this.newAccount});

  @override
  State<StatefulWidget> createState() => _ChooseExistingBankScreenState();

}

class _ChooseExistingBankScreenState extends State<ChooseExistingBankScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void pingBankAndContinue() {
    processBeshenceBank(context, _controller.text, widget.newAccount);
  }

  @override
  Widget build(BuildContext context) {
    List<BeshenceBank> banks = Beshence.banks;
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.dns_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Choose existing Bank", style: TextTheme.of(context).headlineLarge,),
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
          Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: banks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.dns_outlined),
                        title: Text(banks[index].id),
                        onTap: () => context.push(
                            "${widget.newAccount?"/register":"/login"}/choose_vault?bank_id=${banks[index].id}"),
                      );
                    }
                ),
              ]
          )
        ],
      ),
    );
  }
}