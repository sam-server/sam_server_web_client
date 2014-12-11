import 'dart:async';
import 'dart:convert' show JSON;
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:http/browser_client.dart';

import 'package:cs_elements/qrcode/qrcode.dart';
import 'package:cs_elements/context_panel/context_panel.dart';

@CustomTag('asset-list')
class AssetList extends PolymerElement implements LoadableElement {
  @observable
  List<Asset> assets = toObservable([]);
  
  AssetList.created(): super.created() {
    print('created');
  }
  
  void load(String href) {
    var client = new BrowserClient();
    print('fetching assets');
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
    assert(contextPanel != null);
    contextPanel.href = qrcodeElem.value;
  }
  
  /// Set once the element has loaded.
  @override
  ContextPanel contextPanel;

  @override
  Future loadFromUri(String uri, {Map<String,dynamic> restoreData}) {
    var client = new BrowserClient();
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
  
  @override
  Map<String,dynamic> saveData() => <String,dynamic>{};
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