import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _changeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BeshenceDaemon.of(Beshence.selectedAccount!).startDaemon();
    });
  }

  @override
  void dispose() {
    _changeNameController.dispose();
    super.dispose();
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
        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Change account name"),
              onTap: () => showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Set new name'),
                  content: TextField(controller: _changeNameController, autofocus: true),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    TextButton(onPressed: () async {
                      await Beshence.selectedAccount!.setName(_changeNameController.text);
                      _changeNameController.text = "";
                      Navigator.pop(context);
                    }, child: const Text("OK"),),
                  ],
                );
              }),
            )
          ],
        )
    );
  }
}