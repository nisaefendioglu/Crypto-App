import 'package:crypto_app/models/users.dart';
import 'package:crypto_app/services/authorization_service.dart';
import 'package:crypto_app/services/firestoreservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Şifremi Sıfırla"),
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
                      height: 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: _resetPassword,
                        child: Text(
                          "Şifremi Sıfırla",
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

  void _resetPassword() async {
    var _formState = _formKey.currentState;
    final _authorizationService =
        Provider.of<AuthorizationService>(context, listen: false);
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        loading = true;
      });
      try {
        await _authorizationService.resetPassword(email);
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
    } else if (errorCode == "ERROR_USER_NOT_FOUND") {
      errorMessage = "Girdiğiniz mail sistemde kayıtlı değildir.";
    }

    var snackBar = SnackBar(content: Text(errorMessage));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
