import 'package:crypto_app/models/users.dart';
import 'package:crypto_app/services/authorization_service.dart';
import 'package:crypto_app/services/firestoreservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName, email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Hesap Oluştur"),
      ),
      body: ListView(
        children: <Widget>[
          //yükleniyor animasyonunun yukarda gösterilmesini sağlar.
          loading
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: "Kullanıcı adınızı giriniz",
                        labelText: "Kullanıcı Adı:",
                        prefixIcon: Icon(Icons.person),
                      ),
                      //validator doğrulayıcı
                      validator: (inputValue) {
                        if (inputValue.isEmpty) {
                          return "Kullanıcı adı alanı boş bırakılamaz!";
                        } else if (inputValue.trim().length < 4) {
                          return "Girilen değer en az 4 karakter olmalı!";
                        }
                        return null;
                      },
                      onSaved: (inputValue) => userName = inputValue,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "E-mail adresinizi giriniz",
                        labelText: "E-mail:",
                        prefixIcon: Icon(Icons.mail),
                      ),
                      //validator doğrulayıcı
                      validator: (inputValue) {
                        if (inputValue.isEmpty) {
                          return "E-mail alanı boş bırakılamaz!";
                        } else if (!inputValue.contains("@")) {
                          return "Girilen değer mail formatında olmalı!";
                        }
                        return null;
                      },
                      onSaved: (inputValue) => email = inputValue,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Şifrenizi giriniz",
                        labelText: "Şifre:",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (inputValue) {
                        if (inputValue.isEmpty) {
                          return "Şifre alanı boş bırakılamaz!";
                        } else if (inputValue.trim().length < 6) {
                          return "Şifre 6 karakterden az olamaz!";
                        }
                        return null;
                      },
                      onSaved: (inputValue) => password = inputValue,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: _createUser,
                        child: Text(
                          "Hesap Oluştur",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  void _createUser() async {
    var _formState = _formKey.currentState;
    final _authorizationService =
        Provider.of<AuthorizationService>(context, listen: false);
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        loading = true;
      });
      try {
        Users users = await _authorizationService.mailSignUp(email, password);
        if (users != null) {
          FireStoreService().createUser(
              id: users.id, mail: users.mail, userName: users.userName);
        }
        Navigator.pop(context);
      } catch (error) {
        setState(() {
          loading = false;
        });
        warningInfo(errorCode: error.code);
      }
    }
  }

  //hata uyarılarını kullanıcıya gösterme
  warningInfo({errorCode}) {
    String errorMessage;
    if (errorCode == "ERROR_INVALID_EMAIL") {
      errorMessage = "Girdiğiniz E-mail adresi geçersizdir.";
    } else if (errorCode == "ERROR_EMAIL_ALREADY_IN_USE") {
      errorMessage = "Girdiğiniz mail sistemde kayıtlıdır.";
    } else if (errorCode == "ERROR_WEAK_PASSWORD") {
      errorMessage = "Daha güçlü bir şifre tercih edin.";
    }

    var snackBar = SnackBar(content: Text(errorMessage));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
