import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/usuario.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditEmployee extends StatelessWidget {
  final String idEmployee;
  final String authToken;
  const EditEmployee(this.authToken, this.idEmployee, {Key? key})
      : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JEM - Software',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: EditEmployeePage(this.authToken,
          title: 'Editar Empleado', idEmployee: this.idEmployee),
    );
  }
}

class EditEmployeePage extends StatefulWidget {
  final String authToken;
  const EditEmployeePage(this.authToken,
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
  String _userVerifiedPass = '';
  String _selectedRole = '';

  Widget _userNameField(_name) {
    return _formFieldSized(TextFormField(
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
    ));
  }

  Widget _userEmailField(_email) {
    return _formFieldSized(TextFormField(
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
    ));
  }

  Widget _userPhoneField(_phone) {
    return _formFieldSized(TextFormField(
      initialValue: _phone,
      decoration: InputDecoration(
          labelText: 'Numero de Telefono',
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
        _userName = value;
      }),
    ));
  }

  Widget _userPassField() {
    return _formFieldSized(TextFormField(
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
        _userPass = value;
      }),
    ));
  }

  Widget _userVerifiedPassField() {
    return _formFieldSized(TextFormField(
      decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle:
              TextStyle(fontFamily: _fontFamily, fontSize: _fontLittleSize)),
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Contraseña requerida';
        } else if (value != _userPass) {
          return 'Las Contraseñas no Coinciden';
        }
        return null;
      },
      onChanged: (value) => setState(() {
        _userVerifiedPass = value;
      }),
    ));
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

  Widget _rolesDropdownField() {
    return FutureBuilder<List>(
        future: _getRoles(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: Text('Cargando...'));
          } else {
            var data = snapshot.data;
            _selectedRole = data?.first;

            return _formFieldSized(DropdownButtonFormField(
              icon: Icon(Icons.arrow_drop_down),
              style: TextStyle(color: Colors.black, fontSize: 16),
              onChanged: (changedValue) {
                _selectedRole = changedValue.toString();
                print(_selectedRole);
                // setState(() {
                //   _selectedRole;
                //   print(_selectedRole);
                // });
                FocusScope.of(context).requestFocus(FocusNode());
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

  Widget _formFieldSized(Widget field) {
    return SizedBox(width: 700, child: field);
  }

  Widget _editForm() {
    // Future<Usuario> user = _getUser();

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _userNameField(data?.name),
                const SizedBox(height: 15.0),
                _userPhoneField(userPhone),
                const SizedBox(height: 15.0),
                _userEmailField(data?.email),
                const SizedBox(height: 15.0),
                _userPassField(),
                const SizedBox(height: 15.0),
                _userVerifiedPassField(),
                const SizedBox(height: 15.0),
                _rolesDropdownField(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(180, 40),
                              textStyle: const TextStyle(fontSize: 15)),
                          label: const Text('Cancelar'),
                          icon: const Icon(Icons.cancel_sharp),
                        ),
                        const SizedBox(width: 40.0),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(180, 40),
                              textStyle: const TextStyle(fontSize: 15)),
                          label: const Text('Guardar'),
                          icon: const Icon(Icons.save_as_outlined),
                        )
                      ])),
                ),
              ],
            ));
          }
        });
  }

  Future<Usuario> _getUser() async {
    print('GET USER');
    Usuario _usuario = Usuario();
    try {
      String _url =
          kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + widget.authToken
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
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Container(child: Column(children: [_editForm()]))
            ]))));
  }
}
