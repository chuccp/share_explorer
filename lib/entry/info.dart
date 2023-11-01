

import '../util/json.dart';
import 'address.dart';

class InfoItem {
  InfoItem({this.hasInit, this.remoteAddress, this.hasSignIn});

  bool? hasInit = false;

  bool? hasSignIn = false;

  List<String>? remoteAddress;

  List<AddressItem>? get addresses => remoteAddress?.map((e) {
        List<String> adr = e.split(":");
        return AddressItem(host:adr.first, port:int.parse(adr.last));
      }).toList();

  factory InfoItem.fromJson(Map<String, dynamic> json) {
    return InfoItem(
        hasInit: Json.getBool(json, "hasInit"),
        remoteAddress: Json.getListString(json, 'remoteAddress'),
        hasSignIn: Json.getBool(json, 'hasSignIn'));
  }
}
