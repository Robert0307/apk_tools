class Sign {
  final String keyAlias;
  final String keyPassword;
  final String storePassword;
  final String storeFile;
  final bool v2Enabled;

  Sign.fromJsonMap(Map<String, dynamic> map)
      : keyAlias = map["keyAlias"],
        keyPassword = map["keyPassword"],
        storePassword = map["storePassword"],
        v2Enabled = map["v2Enabled"],
        storeFile = map["storeFile"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyAlias'] = keyAlias;
    data['keyPassword'] = keyPassword;
    data['storePassword'] = storePassword;
    data['storeFile'] = storeFile;
    data['v2Enabled'] = v2Enabled;
    return data;
  }
}
