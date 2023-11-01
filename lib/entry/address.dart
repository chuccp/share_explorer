class AddressItem {
  AddressItem({required this.host, required this.port});

  int port;
  String host;


  @override
  String toString() {
    return "$host:$port";
  }
}
