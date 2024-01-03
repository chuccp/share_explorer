class ServerSettingItem {
  ServerSettingItem({this.username, this.password, this.rePassword, this.isServer, this.isNatServer});

  bool? isServer;
  bool? isNatServer;
  String? username;
  String? password;
  String? rePassword;
  List<String> remoteAddresses = [];
}
