import 'package:snackk/theme/theme.dart';
import 'package:snackk/widgets/general/custom_button.dart';
import 'package:snackk/widgets/general/inline_error.dart';
import 'package:snackk/widgets/login/login_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:snackk/services/authentication.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  bool _isLoginForm = false;

  // Perform login or signup
  void validateAndSubmit() async {
    final form = _formKey.currentState;
    if (!form.validate()) return;

    _isLoginForm
        ? Auth.signIn(_email, _password)
        : Auth.signUp(_email, _password);
  }

  void toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new LoginScaffold(
        top: Text("snackk",
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 2)),
        middle: new Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: InlineError(
                      (Auth.status.value as NotLoggedIn).error,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Email can\'t be empty' : null,
                    onChanged: (value) => _email = value.trim(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      decoration: new InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Password can\'t be empty' : null,
                      onChanged: (value) => _password = value.trim(),
                    ),
                  ),
                ])),
        bottom: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40.0,
                child: new CustomButton(
                  title: _isLoginForm ? 'Login' : 'Create account',
                  isMinimal: false,
                  icon: Icons.arrow_forward,
                  style: ButtonStyles.text,
                  brightness: Brightness.dark,
                  onPressed: validateAndSubmit,
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom < 100)
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CustomButton(
                        title: _isLoginForm
                            ? 'Create an account'
                            : 'Have an account? Sign in',
                        style: ButtonStyles.text,
                        isMinimal: true,
                        brightness: Brightness.dark,
                        onPressed: toggleFormMode)),
            ]));
  }
}
