import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersListWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'route',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista Pedidos Web'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('Go Back'),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}
