import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../misc.dart';
import 'modals.dart';

class ChooseVaultScreen extends StatefulWidget {
  final bool newAccount;
  final String bankId;

  const ChooseVaultScreen({super.key, required this.newAccount, required this.bankId});

  @override
  State<StatefulWidget> createState() => _ChooseVaultScreenState();

}

class _ChooseVaultScreenState extends State<ChooseVaultScreen> {
  late TextEditingController _controller;
  bool _vaultsLoaded = false;
  bool _showCreateVaultTextField = false;
  List<BeshenceRemoteVault> _vaults = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _vaults = await Beshence.getBank(widget.bankId)!.getVaults();
      setState(() {
        _vaultsLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.dataset_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Choose Vault", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(text: "Vault is where your Account data is stored. "),
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
                    // TODO: if(widget.newAccount) TextSpan(text: "\n\nWant to set up your own Bank? "),
                    // TODO: if(widget.newAccount) TextSpan(text: "Click here", style: TextStyle(color: Colors.blue))
                  ]
              )
          ),
          SizedBox(height: 24,),
          if(!_vaultsLoaded)
            Center(child: CircularProgressIndicator())
          else
            ListView.builder(
                shrinkWrap: true,
                itemCount: _vaults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.dataset_outlined),
                    title: Text(_vaults[index].name),
                    onTap: () async {
                      var accountIdAttachedToVault = await Beshence.getBank(widget.bankId)!.getAccountIdAttachedToVault(_vaults[index].id);

                      if(widget.newAccount) { // register
                        if(accountIdAttachedToVault != null) {
                          showDialog(context: context, builder: (context) => AlertDialog(
                            title: Text("Cannot use this Vault"),
                            content: Text("This Vault is used by another Beshence Account."),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(), child: Text("Ok"),
                              )
                            ],
                          ));
                          return;
                        }
                        BeshenceAccount account = await Beshence.createAccount();
                        account.addVault(bankId: widget.bankId, vaultId: _vaults[index].id, priority: 1024);
                        BeshenceDaemon.of(account).startDaemon();
                        context.go(redirectToAfterLoggingIn ?? "/");
                      } else { // login
                        if(accountIdAttachedToVault == null) {
                          showDialog(context: context, builder: (context) => AlertDialog(
                            title: Text("Cannot use this Vault"),
                            content: Text("We could not find Beshence Account which use this Vault."),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(), child: Text("Ok"),
                              )
                            ],
                          ));
                          return;
                        }
                        BeshenceAccount account = await Beshence.createAccount(id: accountIdAttachedToVault, initAccountEvent: false);
                        account.addVault(bankId: widget.bankId, vaultId: _vaults[index].id, priority: 0, addVaultEvent: false);
                        account.createChain("main");
                        BeshenceDaemon.of(account).startDaemon();
                        context.go(redirectToAfterLoggingIn ?? "/");
                      }
                    },
                  );
                }
            ),
          SizedBox(height: 12,),
          if(!_showCreateVaultTextField)
            Row(
              children: [
                SizedBox(height: 48,),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _showCreateVaultTextField = true;
                  }),
                  icon: Icon(Icons.add),
                  label: Text("Create Vault"),
                )
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'New Vault\'s name',
                    ),
                    controller: _controller,
                  ),
                ),
                SizedBox(width: 16,),
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () => setState(() {
                    _controller.text = "";
                    _showCreateVaultTextField = false;
                  }),
                ),
                SizedBox(width: 16,),
                FilledButton.icon(
                  iconAlignment: .end,
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () async {
                    await Beshence.getBank(widget.bankId)!.createVault(_controller.text);
                    var vaults = await Beshence.getBank(widget.bankId)!.getVaults();
                    setState(() {
                      _vaults = vaults;
                      _controller.text = "";
                      _showCreateVaultTextField = false;
                    });
                  }, label: Text("Create"),
                ),
              ],
            )
        ],
      ),
    );
  }
}