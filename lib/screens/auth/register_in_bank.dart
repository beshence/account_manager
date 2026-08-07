import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../misc.dart';

class RegisterInBankScreen extends StatefulWidget {
  final String bankId;

  const RegisterInBankScreen({super.key, required this.bankId});

  @override
  State<StatefulWidget> createState() => _RegisterInBankScreenState();
}

class _RegisterInBankScreenState extends State<RegisterInBankScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CenteredScaffold(
      body: Column(
        crossAxisAlignment: .start,
        children: [
          Icon(Icons.dns_outlined, size: 48, color: TextTheme.of(context).headlineLarge?.color,),
          SizedBox(height: 24,),
          Text("Register in Bank", style: TextTheme.of(context).headlineLarge,),
          SizedBox(height: 24,),
          FutureBuilder(future: Beshence.pingBank(bankId: widget.bankId), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              List<String> registerMethods = snapshot.requireData.registerMethods;
              return Column(
                  children: [
                    if(registerMethods.contains("usernameAndPassword")) ...[
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                        controller: _usernameController,
                        enabled: _enabled,
                      ),
                      SizedBox(height: 16,),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        enabled: _enabled,
                      ),
                      SizedBox(height: 24,),
                      OverflowBar(
                        alignment: .spaceBetween,
                        overflowAlignment: .end,
                        spacing: 16,
                        overflowSpacing: 0,
                        overflowDirection: .up,
                        children: [
                          TextButton(
                            onPressed: !_enabled ? null : () => context.push("/register/login_to_bank?bank_id=${widget.bankId}"),
                            child: const Text('Login instead'),
                          ),
                          FilledButton(
                            onPressed: !_enabled ? null : () async {
                              setState(() {
                                _enabled = false;
                              });

                              await Beshence.registerInBank(
                                  bankId: widget.bankId,
                                  username: _usernameController.text,
                                  password: _passwordController.text);

                              context.go("/register/choose_vault?bank_id=${widget.bankId}");

                              setState(() {
                                _enabled = true;
                              });
                            },
                            child: const Text('Register'),
                          ),
                        ],
                      )
                    ]
                  ]
              );
            }
          }),
        ],
      ),
    );
  }
}