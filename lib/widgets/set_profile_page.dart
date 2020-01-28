import 'package:breve/services/database.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:breve/services/authentication.dart';
import 'package:flutter/services.dart';

class SetProfilePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  final _formKey = new GlobalKey<FormState>();

  String _displayName;
  String _phone;
  String _errorMessage = "";

  bool _isLoginForm = true;

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
      await Auth.updateProfile(_displayName, _phone);
    } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = e.toString();
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
      data: ThemeData.dark().copyWith(accentColor: Colors.white),
      child:
    Scaffold(
      appBar: AppBar(brightness: Brightness.dark, backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            _showForm(),
          ],
        )));
  }

  Widget _showForm() {
    return Container(alignment: Alignment.topCenter, child: Container(
      constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              SizedBox(height: 50),
              showErrorMessage(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
            ],
          ),
        )));
    
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

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: Center(child: Text("set profile", style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 2)),)
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Name',
            ),
        validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
        onChanged: (value) => _displayName = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Phone',
            ),
        validator: (value) => value.isEmpty ? 'Phone can\'t be empty' : null,
        onChanged: (value) => _phone = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new CustomButton(

       title:
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: ButtonStyles.text,
            brightness:  Brightness.dark,
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new CustomButton(title: _isLoginForm ? 'Login' : 'Create account',
                style: ButtonStyles.filled,
                brightness: Brightness.dark,
            onPressed: validateAndSubmit,
          ),
        ));
  }
}
