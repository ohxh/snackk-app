import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:breve/services/authentication.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  var maskFormatter = MaskTextInputFormatter(
      mask: '+1 (###) ### ####', filter: {"#": RegExp(r'[0-9]')});

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: BreveTheme.dark.copyWith(accentColor: Colors.white, brightness: Brightness.dark),
        child: Scaffold(
            
            backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    padding:
                        EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
                    child: new Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Align(
                                child: Text("A few more things...",
                                    style: TextStyles.largeLabel
                                        .copyWith(color: Colors.white)),
                                alignment: Alignment.center,
                              )),
                          Expanded(
                            flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                  TextFormField(
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Full name',
                                    ),
                                    validator: (value) => value.length < 3
                                        ? 'Enter your full name'
                                        : null,
                                    onChanged: (value) =>
                                        _displayName = value.trim(),
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    maxLines: 1,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [maskFormatter],
                                    decoration: InputDecoration(
                                      hintText: 'Phone number',
                                    ),
                                    validator: (value) =>
                                        maskFormatter.getUnmaskedText().length <
                                                10
                                            ? 'Enter a valid phone number'
                                            : null,
                                    onChanged: (value) =>
                                        _phone = maskFormatter.getMaskedText(),
                                  ),
                                ]),
                          ),
                              
                          Expanded(

                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                CustomButton(
                                    style: ButtonStyles.text,
                                    brightness: Brightness.dark,
                                    onPressed: validateAndSubmit,
                                    title: "Continue",
                                    icon: Icons.arrow_forward)
                              ]))
                        ],
                      ),
                    ))
              ],
            )));
  }
}
