import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/general/custom_button.dart';
import 'package:breve/widgets/login/login_scaffold.dart';
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

  var maskFormatter = MaskTextInputFormatter(
      mask: '+1 (###) ### ####', filter: {"#": RegExp(r'[0-9]')});

  // Perform login or signup
  void validateAndSubmit() async {
    final form = _formKey.currentState;
    if (!form.validate()) return;

    Auth.updateProfile(_displayName, _phone);
  }

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
        top: Text("A few more things...",
            style: TextStyles.largeLabel.copyWith(color: Colors.white)),
        middle: 
        Form(key:  _formKey,child:
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Full name',
                ),
                validator: (value) =>
                    value.length < 3 ? 'Enter your full name' : null,
                onChanged: (value) => _displayName = value.trim(),
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
                    maskFormatter.getUnmaskedText().length < 10
                        ? 'Enter a valid phone number'
                        : null,
                onChanged: (value) => _phone = maskFormatter.getMaskedText(),
              ),
            ])),
        bottom: CustomButton(
            style: ButtonStyles.text,
            brightness: Brightness.dark,
            onPressed: validateAndSubmit,
            title: "Continue",
            icon: Icons.arrow_forward));
  }
}
