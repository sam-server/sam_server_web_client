import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:sam_server_web_client/asset_list/asset_list.dart';
import 'package:sam_server_web_client/polymer_utils.dart';
import 'package:cs_elements/session/session.dart';

void main() {
  initPolymer().run(() {
    polymerReady.then((_) {
      if (session.loggedIn) {
        AssetList assetList = querySelector('asset-list');
        assetList.loadFromUri();
      } else {
        window.location.href = '/auth/login';
      }
    });
  });
}