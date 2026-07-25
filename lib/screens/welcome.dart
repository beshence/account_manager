import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dialogWidth = screenWidth > 600 ? 560.0 : screenWidth * 0.85;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Beshence Account Manager"),
          ),
          body: SizedBox.expand()
        ),
        Container(
          color: Colors.black54,
          width: double.infinity,
          height: double.infinity,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: AlertDialog(
            constraints: BoxConstraints(maxWidth: dialogWidth),
            title: Text('Welcome to Beshence Account Manager!',),
            content: Text(
              'To get started, register new Beshence Account or log in to existing one.', style: Theme.of(context).textTheme.bodyLarge,),
            actionsOverflowButtonSpacing: 8.0,
            actionsAlignment: .spaceBetween,
            icon: Icon(Icons.account_circle_outlined, size: 36,),
            actionsOverflowDirection: .up,
            actions: [
              TextButton(
                onPressed: () => context.push("/register"),
                child: const Text('Register'),
              ),
              FilledButton(
                onPressed: () => context.push("/login"),
                child: const Text('Log in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}