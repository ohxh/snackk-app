import 'package:breve/theme/theme.dart';
import 'package:flutter/material.dart';

class LoginScaffold extends StatelessWidget {
  Widget top;
  Widget middle;
  Widget bottom;

  LoginScaffold({this.top, this.middle, this.bottom});

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: BreveTheme.dark
            .copyWith(accentColor: Colors.white, brightness: Brightness.dark),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.black,
            body: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(gradient: BreveColors.brandGradient),
                child: Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    padding:
                        EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
                    child: new Column(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.bottomCenter, child: top),
                        ),
                        Flexible(flex: 3, child: Container(child: middle)),
                        Flexible(flex: 1, child: Container(child: bottom)),
                      ],
                    )))));
  }
}
