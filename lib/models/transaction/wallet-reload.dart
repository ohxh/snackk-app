import 'package:breve/models/deserializable.dart';

class WalletReload extends Pushable {

  String _source;
  String get source => _source;

  get isValid => source != null && amount != null && amount != 0;

  set source(x) {
    _source = x;
    notifyListeners();
  }

  int _amount;
  int get amount => _amount;
  set amount(x) {
    _amount = x;
    notifyListeners();
  }

  WalletReload();

  Map<String,dynamic> get json => {
    "source": _source,
    "amount": _amount,
    "destination": "wallet",
    "type": "reload"
  };
}