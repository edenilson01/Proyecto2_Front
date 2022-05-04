import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_view/employeeList.dart';

class OrdersListWeb extends StatelessWidget {
  final String authToken;
  const OrdersListWeb(this.authToken, {Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JEM - Software',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home:
          OrdersListWebPage(this.authToken, context, title: 'Editar Empleado'),
    );
  }
}

class OrdersListWebPage extends StatefulWidget {
  final String authToken;
  final BuildContext context;
  const OrdersListWebPage(this.authToken, this.context,
      {Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<OrdersListWebPage> createState() => _OrdersListWebPage();
}

class _OrdersListWebPage extends State<OrdersListWebPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista Pedidos Web'),
        ),
        body: Column(children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmployeeList(widget.authToken)));
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(230, 40),
                textStyle: const TextStyle(fontSize: 15)),
            label: const Text('Empleados'),
            icon: const Icon(Icons.group_add_outlined),
          ),
          SizedBox(height: 70),
          Text('EN CONSTRUCCION'),
          SizedBox(height: 150),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RaisedButton(
              child: Text('Salir'),
              onPressed: () {
                Navigator.pop(widget.context);
              },
              color: Colors.deepOrange,
            )
          ]),
        ]));
  }
}
