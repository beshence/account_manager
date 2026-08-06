import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BeshenceDaemon.of(Beshence.selectedAccount!).startDaemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Beshence Account Manager"),
          actionsPadding: .only(right: 8),
          actions: [
            Beshence.selectedAccount!.avatarButton(
                onPressed: () => BeshenceWidgets.showAccountChooserModal(context: context)
            ),
          ],
        ),
        body: SizedBox.expand()
    );
  }
}