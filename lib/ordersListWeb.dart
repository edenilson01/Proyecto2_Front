import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_view/employeeList.dart';

class OrdersListWeb extends StatelessWidget {
  final String _authToken;
  const OrdersListWeb(this._authToken, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'route',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista Pedidos Web'),
        ),
        body: Center(
          child: Row(children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeList(this._authToken)));
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(230, 40),
                  textStyle: const TextStyle(fontSize: 15)),
              label: const Text('Agregar Empleado'),
              icon: const Icon(Icons.group_add_outlined),
            ),
            RaisedButton(
              child: Text('Go Back'),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.deepOrange,
            )
          ]),
        ),
      ),
    );
  }
}
