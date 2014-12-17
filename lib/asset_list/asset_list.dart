import 'dart:async';
import 'dart:convert' show JSON;
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:http/browser_client.dart';

import 'package:cs_elements/qrcode/qrcode.dart';
import 'package:cs_elements/context_panel/context_panel.dart';
import 'package:cs_elements/session/session.dart';

@CustomTag('asset-list')
class AssetList extends PolymerElement {
  @observable
  List<Asset> assets = toObservable([]);
  
  @published
  String href;
  
  AssetList.created(): super.created();
  
  void load(String href) {
    var client = session.httpClient;
    client.get(href).then((result) {
      if (result.statusCode != 200) {
        //TODO: Handle failure
        print('Error ${result.statusCode}: ${result.body}');
        return;
      }
      var content = JSON.decode(result.body);
      print(content);
      assert(content['kind'] == 'assets#assets');
      for (var asset in content['assets']) {
        this.assets.add(new Asset(asset['name'], asset['qr_code']));
        print(this.assets.last.qrcode);
      }
    });
  }
  
  void displayAsset(Event e) {
    e.preventDefault();
    QRCode qrcodeElem = e.currentTarget;
    window.location.href = qrcodeElem.value;
  }

  Future loadFromUri({String uri, Map<String,dynamic> restoreData}) {
    if (uri == null)
      uri = this.href;
    var client = session.httpClient;
    print('fetching assets');
    return client.get(uri).then((result) {
      if (result.statusCode != 200) {
        //TODO: Handle error properly
        print('Error ${result.statusCode}: ${result.body}');
        return;
      }
      var content = JSON.decode(result.body);
      assert(content['kind'] == 'assets#assets');
      for (var asset in content['assets']) {
        this.assets.add(new Asset.fromMap(asset));
      }
    });
  }
  
}

class Asset extends Observable {
  @observable
  String qrcode;
  @observable
  String name;
  
  Asset(this.name, this.qrcode);
  
  Asset.fromMap(Map<String,dynamic> map):
    this(map['name'], map['qr_code']);
}