import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:sam_server_web_client/asset_list/asset_list.dart';
import 'package:cs_elements/session/session.dart';

void main() {
  initPolymer().run(() {
    Polymer.onReady.then((_) {
      var session = document.querySelector('cs-session');
      if (session.loggedIn) {
        AssetList assetList = querySelector('asset-list');
        assetList.loadFromUri();
      } else {
        window.location.href = '/auth/login';
      }
    });
  });
}