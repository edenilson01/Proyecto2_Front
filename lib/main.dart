import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:requests/requests.dart';
import 'package:http/http.dart' as http;
import 'package:login_view/employeeList.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:login_view/ordersListMobile.dart';
import 'package:login_view/ordersListWeb.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
      home: const MyHomePage(title: 'Login Delivery'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //static const TextStyle _globalFontStyle = TextStyle(
  //  fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Open sans');

  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _userpass = '';
  final String _fontFamily = 'Open sans';
  final double _fontLittleSize = 16;
  final double _fontBigSize = 25;
  final double _fontMidiumSize = 20;

  String _error = '';
  Widget _userNameField() {
    return _formFieldSized(TextFormField(
      decoration: InputDecoration(
          labelText: 'Usuario',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'El usuario es requerido';
        }
        return null;
      },
      onChanged: (value) => setState(() {
        _username = value;
      }),
    ));
  }

  Widget _userPassField() {
    return _formFieldSized(TextFormField(
      decoration: InputDecoration(
          labelText: 'Contrase??a',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Contrase??a requerida';
        }
        return null;
      },
      onChanged: (value) => setState(() {
        _userpass = value;
      }),
    ));
  }

  void _messageBox(String _message, {String title = 'ERROR'}) {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
              title: Text(title),
              content: Text(_message),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ]);
        });
  }

  void _getData() async {
    print('Metodo POST');
    String _url =
        kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
    try {
      // LOGIN
      String _clientToken =
          '\$2y\$10\$LTEhuI5dvpTyZMiAMfagzOOxmLhnRXmTJFKxImSELEEwH.uTegdmK';
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'client': _clientToken
      };
      Map<String, String> _user = {'email': _username, 'password': _userpass};
      var response = await http.post('$_url/auth/login',
          headers: _header, body: jsonEncode(_user));
      var _userData = json.decode(response.body)['data'];

      var _userToken = _userData['access_token'];
      if (response.statusCode != 401) {
        //VERIFICAR ROL USUARIO
        _header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _userToken
        };

        var _userId = _userData['user'];
        response =
            await http.get('$_url/users/$_userId/roles', headers: _header);
        var _userRoles = json.decode(response.body)['data'];
        var _roleToAccess = kIsWeb ? 'administrador' : 'repartidor';
        var _accessVerified = false;
        for (var _role in _userRoles) {
          print(_role['name']);
          if (_role['name'] == _roleToAccess) {
            _accessVerified = true;
            break;
          }
        }
        if (_accessVerified) {
          Widget viewToRedirect =
              kIsWeb ? OrdersListWeb(_userToken) : OrdersListMobile();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => viewToRedirect));
        } else {
          _messageBox('ROL INCORRECTO');
        }
      } else {
        _messageBox('LOGIN INCORRECTO');
      }
    } catch (err) {
      print(err);
      _messageBox('LOGIN INCORRECTO');
    }
  }

  Widget _formFieldSized(Widget field) {
    if (kIsWeb) {
      return SizedBox(width: 500, child: field);
    } else {
      return field;
    }
  }

  Widget _loginForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _userNameField(),
            const SizedBox(height: 15.0),
            _userPassField(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Center(
                  child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(_username);
                    print(_userpass);
                    _getData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    textStyle: const TextStyle(fontSize: 21)),
                label: const Text('LOGIN'),
                icon: const Icon(Icons.arrow_forward),
              )),
            ),
          ],
        ));
  }

  Widget _loginHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Column(children: <Widget>[
        Text(
          'LOGIN',
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

  Widget showAlert() {
    if (_error != '') {
      return Container(
        color: Colors.orangeAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
                child: AutoSizeText(
              _error,
              maxLines: 3,
            )),
            IconButton(
                onPressed: () {
                  setState(() {
                    _error = '';
                  });
                },
                icon: Icon(Icons.close)),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFededed),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showAlert(),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[_loginHeader(), _loginForm()]))
          ],
        ),
      )),
    );
  }
}
