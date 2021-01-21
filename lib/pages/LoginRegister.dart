import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/Authentication.dart';
import 'package:flutter_blog_app/models/DialogBox.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({this.auth, this.onSignedIn});

  final AuthImplementaion auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }
}

enum FormType { login, register }

class _LoginRegisterState extends State<LoginRegisterPage> {
  DialogBox dialogBox = DialogBox();

  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  //Metodos
  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.SignIn(_email, _password);
          //dialogBox.information(context, "🎉 Parabéns 🎉", "Você está logado com sucesso.");
          print("Login userId = " + userId);
        } else {
          String userId = await widget.auth.SignUp(_email, _password);
          //dialogBox.information(context, "🎉 Parabéns 🎉", "Sua conta foi criada com sucesso.");
          print("Register userId = " + userId);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "⚠️ Erro ⚠️", e.toString());
        print("Error = " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  // Design App
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flutter Blog App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Hero(
                  tag: 'hero',
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 200.0,
                    child: Image.asset('images/app_logo4.gif'),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'E-mail'),
                  validator: (value) {
                    return value.isEmpty ? 'E-mail é requerido!' : null;
                  },
                  onSaved: (value) {
                    return _email = value;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    return value.isEmpty ? 'Senha é requerida!' : null;
                  },
                  onSaved: (value) {
                    return _password = value;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  child: Text(
                      _formType == FormType.login ? "Login" : "Cadastrar",
                      style: TextStyle(fontSize: 20.0)),
                  textColor: Colors.white,
                  color: Colors.blueGrey,
                  onPressed: validateAndSubmit,
                ),
                FlatButton(
                  child: Text(
                      _formType == FormType.login
                          ? "Não tem uma conta? Criar conta."
                          : "Já possui uma conta? Login.",
                      style: TextStyle(fontSize: 14.0)),
                  textColor: Colors.red,
                  onPressed: _formType == FormType.login
                      ? moveToRegister
                      : moveToLogin,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
