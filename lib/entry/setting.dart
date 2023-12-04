class ServerSettingItem {
  ServerSettingItem({this.username, this.password, this.rePassword, this.useNatSelected, this.beNatSelected});

  bool? useNatSelected;
  bool? beNatSelected;
  String? username;
  String? password;
  String? rePassword;
  List<String> remoteAddresses = [];
}
