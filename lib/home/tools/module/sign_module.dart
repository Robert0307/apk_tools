import 'package:DogApkTools/home/tools/module/sign.dart';

class SignModule {
  final List<Sign> sign;

  SignModule.fromJsonMap(Map<String, dynamic> map)
      : sign = List<Sign>.from(map["sign"].map((it) => Sign.fromJsonMap(it)));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sign'] = sign != null ? this.sign.map((v) => v.toJson()).toList() : null;
    return data;
  }
}
