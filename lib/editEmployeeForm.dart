import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/usuario.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditEmployee extends StatelessWidget {
  final String idEmployee;
  const EditEmployee({Key? key, required this.idEmployee}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JEM - Software',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: EditEmployeePage(
          title: 'Editar Empleado', idEmployee: this.idEmployee),
    );
  }
}

class EditEmployeePage extends StatefulWidget {
  const EditEmployeePage(
      {Key? key, required this.title, required this.idEmployee})
      : super(key: key);
  final String title;
  final String idEmployee;

  @override
  State<EditEmployeePage> createState() => _EditEmployeePage();
}

class _EditEmployeePage extends State<EditEmployeePage> {
  final String _fontFamily = 'Open sans';
  final double _fontLittleSize = 16;
  final double _fontBigSize = 25;
  final double _fontMidiumSize = 20;

  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _userPass = '';

  Widget _userNameField(_name) {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(
          labelText: 'Usuario',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'El nombre es requerido';
        }
        return null;
      },
      onChanged: (value) => setState(() {
        _userName = value;
      }),
    );
  }

  Widget _userEmailField(_email) {
    return TextFormField(
      initialValue: _email,
      decoration: InputDecoration(
          labelText: 'Correo Electronico',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'El correo es requerido';
        }
        return null;
      },
      onChanged: (value) => setState(() {
        _userEmail = value;
      }),
    );
  }

  Widget _userPhoneField(_phone) {
    return TextFormField(
      initialValue: _phone,
      decoration: InputDecoration(
          labelText: 'Numero de Telefono',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      keyboardType: TextInputType.name,
      onChanged: (value) => setState(() {
        _userName = value;
      }),
    );
  }

  Widget _userPassField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) => setState(() {
        _userPass = value;
      }),
    );
  }

  Widget _editForm() {
    Future<Usuario> user = _getUser();

    return FutureBuilder<Usuario>(
        future: _getUser(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: Text('Cargando...'));
          } else {
            var data = snapshot.data;
            var userPhone = data?.phone ?? '';

            return Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _userNameField(data?.name),
                const SizedBox(height: 15.0),
                _userPhoneField(userPhone),
                const SizedBox(height: 15.0),
                _userEmailField(data?.email),
                const SizedBox(height: 15.0),
                _userPassField(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Center(
                      child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Guardar'),
                  )),
                ),
              ],
            ));
          }
        });
  }

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

  Future<Usuario> _getUser() async {
    var auth_token = await _loginUser();
    print('GET USER');
    Usuario _usuario = Usuario();
    try {
      String _url =
          kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + auth_token
      };
      final response =
          await http.get('$_url/users/' + widget.idEmployee, headers: _header);
      var data = json.decode(response.body)['data'];
      _usuario = Usuario.fromJson(data);
      return _usuario;
    } catch (err) {
      print(err);
    }
    return _usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: const Color(0xFFededed),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[_editForm()]))
          ],
        ),
      ),
    );
  }
}
