import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
//import 'package:requests/requests.dart';
import 'package:http/http.dart' as http;

class CreateUser extends StatelessWidget {
  final String authToken;
  const CreateUser(this.authToken, {Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JEM - Software',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: CreateUserPage(this.authToken, context, title: 'Agregar Usuario'),
    );
  }
}

class CreateUserPage extends StatefulWidget {
  final BuildContext context;
  final String authToken;
  const CreateUserPage(this.authToken, this.context,
      {Key? key, required this.title})
      : super(key: key);
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
  String _passwordVerified = '';
  String _selectedRole = '';
  final TextEditingController _password = TextEditingController();
  final String _fontFamily = 'Open sans';
  final double _fontLittleSize = 16;
  final double _fontBigSize = 25;
  final double _fontMidiumSize = 20;

  Widget _emailField() {
    return SizedBox(
        width: 500,
        child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                labelStyle: TextStyle(
                    fontFamily: _fontFamily, fontSize: _fontLittleSize)),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'El email es requerido';
              }
              return null;
            },
            onSaved: (value) {
              _email = value ?? "";
            }));
  }

  Widget _nameField() {
    return SizedBox(
        width: 500,
        child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(
                    fontFamily: _fontFamily, fontSize: _fontLittleSize)),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'El Nombre es requerido';
              }
              return null;
            },
            onSaved: (value) {
              _name = value ?? "";
            }));
  }

  Widget _phoneNumberField() {
    return SizedBox(
        width: 500,
        child: TextFormField(
          decoration: InputDecoration(
              labelText: 'Número de teléfono',
              labelStyle: TextStyle(
                  fontFamily: _fontFamily, fontSize: _fontLittleSize)),
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'El número de teléfono es requerido';
            }
            return null;
          },
          onSaved: (value) {
            _phoneNumber = value ?? "";
          },
        ));
  }

  Widget _passwordField() {
    return SizedBox(
        width: 500,
        child: TextFormField(
          controller: _password,
          decoration: InputDecoration(
              labelText: 'Contraseña',
              labelStyle: TextStyle(
                  fontFamily: _fontFamily, fontSize: _fontLittleSize)),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Contraseña requerida';
            }
            return null;
          },
          // onSaved: (value) {
          //   _password = value ?? "";
          // }
        ));
  }

  Widget _passwordVerifiedField() {
    return SizedBox(
        width: 500,
        child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Verificar Contraseña',
                labelStyle: TextStyle(
                    fontFamily: _fontFamily, fontSize: _fontLittleSize)),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Contraseña requerida';
              } else if (value != _password.text) {
                return 'Las Contraseñas no Coinciden';
              }
              return null;
            },
            onSaved: (value) {
              _passwordVerified = value ?? "";
            }));
  }

  void _getData() async {
    print(_selectedRole);
    // print('Metodo POST');
    // try {
    //   String _url =
    //       kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';

    //   Map<String, String> _header = {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //     'Authorization': 'Bearer ' + widget.authToken
    //   };

    //   Map<String, String> _user = {
    //     'name': _name,
    //     'email': _email,
    //     'password': _password.text,
    //     'phone': _phoneNumber
    //   };
    //   final response = await http.post('$_url/users',
    //       headers: _header, body: jsonEncode(_user));
    //   print(response.body);
    //   if (response.statusCode == 201) {
    //     _messageBox(
    //         'Usuario creado correctamente, verifique su correo electronico',
    //         title: '');
    //   }
    // } catch (err) {
    //   print(err);
    // }
  }

  Widget _rolesDropdownField() {
    return FutureBuilder<List>(
        future: _getRoles(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: Text('Cargando...'));
          } else {
            var data = snapshot.data;
            _selectedRole = data?.first;

            return SizedBox(
                width: 500,
                child: DropdownButtonFormField(
                  icon: Icon(Icons.arrow_drop_down),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  onChanged: (changedValue) {
                    _selectedRole = changedValue.toString();
                    print(_selectedRole);
                    // setState(() {
                    //   _selectedRole;
                    //   print(_selectedRole);
                    // });
                    FocusScope.of(widget.context).requestFocus(FocusNode());
                  },
                  value: _selectedRole,
                  items: data?.map<DropdownMenuItem<String>>((roles) {
                    return DropdownMenuItem(
                      value: roles,
                      child: Text(roles),
                    );
                  }).toList(),
                ));
          }
        });
  }

  Future<List> _getRoles() async {
    print('Metodo GET ROLES');
    var aviableRoles = [];
    try {
      String _url =
          kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';

      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + widget.authToken
      };

      final response = await http.get('$_url/roles', headers: _header);
      var roles = json.decode(response.body)['data'];
      if (response.statusCode == 200) {
        for (var role in roles) {
          aviableRoles.add(role['display_name']);
        }
        print(aviableRoles);
      }
    } catch (err) {
      print(err);
    }
    return aviableRoles;
  }

  Widget _createUserForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _nameField(),
            const SizedBox(height: 15.0),
            _emailField(),
            const SizedBox(height: 15.0),
            _phoneNumberField(),
            const SizedBox(height: 15.0),
            _passwordField(),
            const SizedBox(height: 15.0),
            _passwordVerifiedField(),
            const SizedBox(height: 15.0),
            _rolesDropdownField(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(widget.context);
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(180, 40),
                      textStyle: const TextStyle(fontSize: 15)),
                  label: const Text('Cancelar'),
                  icon: const Icon(Icons.cancel_sharp),
                ),
                const SizedBox(width: 40.0),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(_email);
                      print(_password.text);
                      print(_phoneNumber);
                      print(_name);
                      print(_passwordVerified);
                      print(_selectedRole);
                      _getData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(180, 40),
                      textStyle: const TextStyle(fontSize: 15)),
                  label: const Text('Crear'),
                  icon: const Icon(Icons.group_add_outlined),
                )
              ]),
            ),
          ],
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
                ElevatedButton(onPressed: () {}, child: const Text('OK'))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: const Color(0xFFededed),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[_createUserForm()]))
              ],
            ),
          ),
        ));
  }
}
