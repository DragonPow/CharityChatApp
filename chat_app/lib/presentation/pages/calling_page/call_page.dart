import 'dart:core';

import 'package:flutter/material.dart';

import 'call_sample.dart';

class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

enum DialogDemoAction {
  cancel,
  connect,
}

class _CallPageState extends State<CallPage> {
  final String _server = 'demo.cloudwebrtc.com';

  @override
  initState() {
    super.initState();
  }

  _buildRow(context, item) {
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(item.title),
        onTap: () => item.push(context),
        trailing: Icon(Icons.arrow_right),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Flutter-WebRTC example'),
      ),
      // body: _buildRow(
      //     context,
      //     RouteItem(
      //         title: 'P2P Call Sample',
      //         subtitle: 'P2P Call Sample.',
      //         push: (BuildContext context) => _showAddressDialog(context))),
      body: Text('hehe'),
    ));
  }

  void showDemoDialog<T>(
      {required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        if (value == DialogDemoAction.connect) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CallSample(host: _server)));
        }
      }
    });
  }

  _showAddressDialog(context) {
    showDemoDialog<DialogDemoAction>(
        context: context,
        child: AlertDialog(
            title: const Text('Enter server address:'),
            content: TextField(
              onChanged: (String text) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: _server,
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context, DialogDemoAction.cancel);
                  }),
              TextButton(
                  child: const Text('CONNECT'),
                  onPressed: () {
                    Navigator.pop(context, DialogDemoAction.connect);
                  })
            ]));
  }
}
