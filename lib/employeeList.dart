import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'createUser.dart';
import 'editEmployeeForm.dart';
import 'models/usuario.dart';

class EmployeeList extends StatelessWidget {
  final String _authToken;
  const EmployeeList(this._authToken, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JEM - Software',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: EmployeeListPage(this._authToken, title: 'Empleados'),
    );
  }
}

class EmployeeListPage extends StatefulWidget {
  final String authToken;
  const EmployeeListPage(
    this.authToken, {
    Key? key,
    required this.title,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  State<EmployeeListPage> createState() => _EmployeeListPage();
}

class _EmployeeListPage extends State<EmployeeListPage> {
  Future<List<Usuario>> _getUserList() async {
    print('GET USER');
    List<Usuario> _usuarios = [];
    try {
      List<Usuario> _usuarios = [];
      String _url =
          kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + widget.authToken
      };
      final response = await http.get('$_url/users', headers: _header);
      var body = json.decode(response.body)['data'];
      for (var data in body) {
        _usuarios.add(Usuario.fromJson(data));
      }
      return _usuarios;
    } catch (err) {
      print(err);
    }
    return _usuarios;
  }

  void _deleteUser(employeeId) async {
    print('DELETE USER');
    try {
      String _url =
          kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + widget.authToken
      };
      final response =
          await http.delete('$_url/users/' + employeeId, headers: _header);
      print(response.body);
    } catch (err) {
      print(err);
    }
  }

  Widget createTable(datas) {
    List<DataRow> rows = [];
    for (var data in datas) {
      var verifiedDate = '';
      var createdDate = '';
      var updatedDate = '';
      var userPhone = data?.phone ?? '';
      if (data?.emailVerifiedAt != null) {
        verifiedDate = data?.emailVerifiedAt.split('T')[0];
      }

      if (data?.createdAt != null) {
        createdDate = data?.createdAt.split('T')[0];
      }

      if (data?.updatedAt != null) {
        updatedDate = data?.updatedAt.split('T')[0];
      }

      rows.add(DataRow(cells: [
        DataCell(Text('${data?.id}')),
        DataCell(Text('${data?.name}')),
        DataCell(Text('${data?.email}')),
        DataCell(Text('${userPhone}')),
        DataCell(Text('${verifiedDate}')),
        DataCell(Text('${createdDate}')),
        DataCell(Text('${updatedDate}')),
        DataCell(Row(children: [
          ElevatedButton(
              onPressed: () {
                var employeeId = '${data?.id}';
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditEmployee(widget.authToken, employeeId)));
              },
              child: const Icon(Icons.edit_note_outlined)),
          const SizedBox(width: 6.0),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () {
                var employeeId = '${data?.id}';
                var employeeName = '${data?.name}';
                _messageBox(
                    'Estas seguro que desea eliminar el usuario "$employeeName"',
                    employeeId);
              },
              child: const Icon(Icons.delete_forever_outlined))
        ]))
      ]));
    }
    //return Table(children: rows);
    return FittedBox(
        child: DataTable(columns: const [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Nombre')),
      DataColumn(label: Text('Correo')),
      DataColumn(label: Text('Telefono')),
      DataColumn(label: Text('Fecha de Verificacion')),
      DataColumn(label: Text('Fecha de Creacion')),
      DataColumn(label: Text('Fecha Actualizacion')),
      DataColumn(label: Text('Control'))
    ], rows: rows));
  }

  void _messageBox(String _message, employeeId) {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(content: Text(_message), actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.cancel_sharp)),
            const SizedBox(width: 5.0),
            ElevatedButton(
                onPressed: () {
                  //_deleteUser(employeeId);
                },
                child: const Icon(Icons.check_circle_outline_outlined))
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Column(children: [
              const SizedBox(height: 15.0),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(width: 30.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(230, 40),
                      textStyle: const TextStyle(fontSize: 15)),
                  label: const Text('Atras'),
                  icon: const Icon(Icons.keyboard_arrow_left_outlined),
                ),
                const Spacer(flex: 2),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateUser(widget.authToken)));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(230, 40),
                      textStyle: const TextStyle(fontSize: 15)),
                  label: const Text('Agregar Empleado'),
                  icon: const Icon(Icons.group_add_outlined),
                ),
                const SizedBox(width: 30.0)
              ]),
              const SizedBox(height: 15.0),
              Card(
                  child: FutureBuilder<List<Usuario>>(
                      future: _getUserList(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const Center(child: Text('Cargando...'));
                        } else {
                          return createTable(snapshot.data);
                        }
                      })),
            ])));
  }
}
