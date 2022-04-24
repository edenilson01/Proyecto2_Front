import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'createUser.dart';
import 'editEmployeeForm.dart';
import 'models/usuario.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JEM - Software',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const EmployeeListPage(title: 'Empleados'),
    );
  }
}

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({Key? key, required this.title}) : super(key: key);

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
  Future<String> _loginUser() async {
    print('Metodo POST LOGIN');
    try {
      String _url =
          kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
      String _clientToken =
          '\$2y\$10\$PI2YcydhsRKdXiiq.K55mu5Bi9jcnucMzxf8xgFfnT2MtPHAXFW5W';
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'client': _clientToken
      };
      Map<String, String> _user = {
        'email': 'edenilsonosnardominguez@gmail.com',
        'password': '123456'
      };
      final response = await http.post('$_url/auth/login',
          headers: _header, body: jsonEncode(_user));
      //print(json.decode(response.body)['data']['access_token']);
      return json.decode(response.body)['data']['access_token'];
    } catch (err) {
      print(err);
      return 'ERROR';
    }
  }

  Future<List<Usuario>> _getUserList() async {
    var auth_token = await _loginUser();
    print('GET USER');
    List<Usuario> _usuarios = [];
    try {
      List<Usuario> _usuarios = [];
      String _url =
          kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + auth_token
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
    var auth_token = await _loginUser();
    print('DELETE USER');
    try {
      String _url =
          kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + auth_token
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
                            EditEmployee(idEmployee: employeeId)));
              },
              child: Text('Editar')),
          const SizedBox(width: 10.0),
          ElevatedButton(
              onPressed: () {
                var employeeId = '${data?.id}';
                _deleteUser(employeeId);
              },
              child: Text('Eliminar'))
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
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateUser()));
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
