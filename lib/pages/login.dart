import 'package:crypto_app/models/users.dart';
import 'package:crypto_app/pages/createAccount.dart';
import 'package:crypto_app/services/authorization_service.dart';
import 'package:crypto_app/services/firestoreservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  String mail, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            _pageElements(),
            _loadingAnimation(),
          ],
        ));
  }

  Widget _loadingAnimation() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox(
        height: 0.0,
      ); //yükleniyor false ise ekrana bir şey vermeyecek.
    }
  }

  Widget _pageElements() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
        children: <Widget>[
          FlutterLogo(
            size: 90.0,
          ),
          SizedBox(
            height: 80.0,
          ),
          TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "E-mail",
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
            onSaved: (inputValue) => mail = inputValue,
          ),
          SizedBox(
            height: 40.0,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Şifre",
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
            height: 40.0,
          ),
          Row(children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreateAccount()));
                },
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
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: FlatButton(
                onPressed: _login,
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                color: Theme.of(context).primaryColorDark,
              ),
            )
          ]),
          SizedBox(height: 20.0),
          Center(child: Text("veya")),
          SizedBox(height: 20.0),
          Center(
              child: InkWell(
            onTap: _googleLogin,
            child: Text(
              "Google ile Giriş Yap",
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          )),
          SizedBox(height: 20.0),
          Center(child: Text("Şifremi Unuttum")),
        ],
      ),
    );
  }

//girilenlerin kontrolü
  void _login() async {
    final _authorizationService =
        Provider.of<AuthorizationService>(context, listen: false);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        loading = true;
      });
      try {
        await _authorizationService.mailLogin(mail, password);
      } catch (error) {
        setState(() {
          loading = false;
        });
        warningInfo(errorCode: error.code);
      }
    }
  }
  //google giriş

  void _googleLogin() async {
    var _authorizationService =
        Provider.of<AuthorizationService>(context, listen: false);
    setState(() {
      loading = true;
    });
    try {
      Users users = await _authorizationService.googleLogin();
      if (users != null) {
        Users firestoreUsers = await FireStoreService().bringUser(users.id);
        if (firestoreUsers == null) {
          FireStoreService().createUser(
              id: users.id,
              mail: users.mail,
              userName: users.userName,
              photoUrl: users.photoUrl);
        }
      }
    } catch (error) {
      if (this.mounted) {
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
    if (errorCode == "ERROR_USER_NOT_FOUND") {
      errorMessage = "Sistemde böyle bir kullanıcı bulunmamaktadır.";
    } else if (errorCode == "ERROR_INVALID_EMAIL") {
      errorMessage = "Girdiğiniz E-mail adresi geçersizdir.";
    } else if (errorCode == "ERROR_WRONG_PASSWORD") {
      errorMessage = "Girilen şifre hatalı.";
    } else if (errorCode == "ERROR_USER_DISABLED") {
      errorMessage = "Kullanıcı sistemden engellenmiştir.";
    } else {
      errorMessage = "Tanımlanamayan bir hata oluştu. $errorCode";
    }

    var snackBar = SnackBar(content: Text(errorMessage));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
