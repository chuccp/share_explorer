import 'package:flutter/material.dart';
import 'package:memory_cache/memory_cache.dart';

import '../entry/info.dart';

class ExCache {

  static void saveInfoItem(InfoItem infoItem){
    MemoryCache.instance.create('infoItem', infoItem);
  }
  static InfoItem? getInfoItem(){
    return  MemoryCache.instance.read('infoItem');
  }




}