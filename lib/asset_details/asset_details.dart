import 'dart:async';
import 'dart:convert' show JSON;

import 'package:polymer/polymer.dart';
import 'package:http/browser_client.dart';

import 'package:cs_elements/context_pane/context_pane.dart';

@CustomTag('asset-details')
class AssetDetails extends PolymerElement implements Loadable {
  
  @observable
  String qrcode;
  
  @observable
  String name;
  
  @observable
  String description;
  
  @observable
  String price;
  
  AssetDetails.created(): super.created();
  
  printQRCode() {
    var qrCodeElem = $['qrcode'];
    print(qrCodeElem);
    print(qrCodeElem.value);
  }
  
  /// The context pane which contains this element.
  /// Set after loading.
  ContextPane contextPane;
  
  @override
  Future loadFromUri(String uri) {
    //TODO: Need to set the client from the session (to handle auth)
    var client = new BrowserClient();
    return client.get(uri).then((response) {
      if (response.statusCode != 200) {
        //Need to handle errors correctly
        print('No such asset');
        return;
      }
      var content = JSON.decode(response.body);
      assert(content['kind'] == 'assets#asset');
      qrcode = content['qr_code'];
      name = content['name'];
      description = content['description'];
      price = content['price'];
    });
  }
}