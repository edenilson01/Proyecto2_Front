import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
//import 'package:requests/requests.dart';
import 'package:http/http.dart' as http;

class CreateUser extends StatelessWidget {
  const CreateUser({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JEM - Software',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.deepOrange),
      home: const CreateUserPage(title: 'Agregar Usuarios'),
    );
  }
}

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<CreateUserPage> createState() => _CreateUserPage();
}

class _CreateUserPage extends State<CreateUserPage> {
  //static const TextStyle _globalFontStyle = TextStyle(
  //  fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Open sans');

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _password = '';
  final String _fontFamily = 'Open sans';
  final double _fontLittleSize = 16;
  final double _fontBigSize = 25;
  final double _fontMidiumSize = 20;

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Correo Electrónico',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'El Email es requerido';
        }
        return null;
      },
      onChanged: (value) => setState(() {
        _email = value;
      }),
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Nombre',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'El Nombre es requerido';
        }
        return null;
      },
      onChanged: (value) => setState(() {
        _name = value;
      }),
    );
  }

  Widget _phoneNumberField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Número de teléfono',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'El número de teléfono es requerido';
        }
        return null;
      },
      onChanged: (value) => setState(() {
        _phoneNumber = value;
      }),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Contraseña requerida';
        }
        return null;
      },
      onChanged: (value) => setState(() {
        _password = value;
      }),
    );
  }

  void _getData() async {
    print('Metodo POST');
    try {
      String _url =
          kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
      String _authToken =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3Q6ODA4MFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTY0OTQ1OTM2OCwiZXhwIjoxNjQ5NDYyOTY4LCJuYmYiOjE2NDk0NTkzNjgsImp0aSI6IjZkOFI2dTlLTUQ0VmIwbWIiLCJzdWIiOjIsInBydiI6IjEzZThkMDI4YjM5MWYzYjdiNjNmMjE5MzNkYmFkNDU4ZmYyMTA3MmUifQ._RqfWVGbVpnU8GIoWhrCXx2GaBWVO168fwHQBi1IGkQ';
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _authToken
      };
      Map<String, String> _user = {
        'name': _name,
        'email': _email,
        'password': _password,
        'phone': _phoneNumber
      };
      final response = await http.post('$_url/users',
          headers: _header, body: jsonEncode(_user));
      print(response.body);
    } catch (err) {
      print(err);
    }
  }

  Widget _loginForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _nameField(),
            const SizedBox(height: 15.0),
            _emailField(),
            const SizedBox(height: 15.0),
            _phoneNumberField(),
            const SizedBox(height: 15.0),
            _passwordField(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Center(
                  child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(_email);
                    print(_password);
                    print(_phoneNumber);
                    print(_name);
                    _getData();
                    //var r = await Requests.get('http://localhost:8080/api/');
                    // r.raiseForStatus();
                    // String body = kr.content();
                    // print(body);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 40),
                    textStyle: const TextStyle(fontSize: 19)),
                label: const Text('Crear'),
                icon: const Icon(Icons.group_add_outlined),
              )),
            ),
          ],
        ));
  }

  Widget _loginHeader() {
    return Row(children: <Widget>[
      Column(children: <Widget>[
        Text(
          'ADD USER',
          style: TextStyle(
              fontSize: _fontBigSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Open sans'),
        ),
        Text(
          'JEM - Software',
          style: TextStyle(fontSize: _fontMidiumSize, fontFamily: 'Open sans'),
        )
      ]),
      const SizedBox(width: 40.0),
      const Image(
        image: AssetImage('images/logo1.png'),
        height: 140,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFededed),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(child: _loginHeader()),
                          _loginForm()
                        ]))
              ],
            ),
          ),
        ));
  }
}
