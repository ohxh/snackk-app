import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:breve/services/authentication.dart';

class LoginSignupPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage = "";

  bool _isLoginForm = false;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    final form = _formKey.currentState;
    if (!form.validate()) return;
    setState(() {
      _errorMessage = "";
    });
    try {
    _isLoginForm ? Auth.signIn(_email, _password)
    : Auth.signUp(_email, _password);

      } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new 
    Theme(
      
      data: BreveTheme.dark.copyWith(accentColor: Colors.white, brightness: Brightness.dark),
      child:
    Scaffold(
      backgroundColor: Colors.black,
        body: 
            _showForm(),
        ));
  }

  Widget _showForm() {
    return  Container(
      constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.only(left:24, right: 24, top: 0, bottom: 0),
        child: new Form(
          
          key: _formKey,
          child: new Column(
           
            children: <Widget>[
              Expanded(
                flex: 3,
                child:
             Container(
               
              child: Text("brevé", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 2)),
              alignment: Alignment.center,
              )),
         Expanded(flex: 3,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
              showErrorMessage(),
              showEmailInput(),
              showPasswordInput(),
              ])),
            Expanded(
              flex: 3,
              child: Container(
              alignment: Alignment.topCenter,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              showPrimaryButton(),
              showSecondaryButton(),])))
            ],
          ),
          
        ));
    
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0) {
      return new Padding(padding: EdgeInsets.all(16), child: Text(
        _errorMessage,
        softWrap: true,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.red[800],
            height: 1.0,
            fontWeight: FontWeight.w400),
      ));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showEmailInput() {
    return TextFormField(
        
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onChanged: (value) => _email = value.trim(),
      
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onChanged: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new 
    Padding(padding:EdgeInsets.only(top:16), child: CustomButton(
      
       title:
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: ButtonStyles.text,
            isMinimal: true,
            brightness:  Brightness.dark,
        onPressed: toggleFormMode));
  }

  Widget showPrimaryButton() {
    return SizedBox(
          height: 40.0,
          child: new CustomButton(title: _isLoginForm ? 'Login' : 'Create account',
          isMinimal: false,
          icon: Icons.arrow_forward,
          style: ButtonStyles.text,
                brightness: Brightness.dark,
            onPressed: validateAndSubmit,
          ),
        );
  }
}
