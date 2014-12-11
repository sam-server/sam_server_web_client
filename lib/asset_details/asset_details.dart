import 'dart:async';
import 'dart:convert' show JSON;
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:http/browser_client.dart';

import 'package:cs_elements/context_panel/context_panel.dart';

@CustomTag('asset-details')
class AssetDetails extends PolymerElement implements LoadableElement {
  static final _PRICE_PATTERN = new RegExp(r'[a-zA-Z]{3} \d+(\.\d+)?');
  
  Map<String,dynamic> _unsavedState;
  
  @observable
  String qrcode;
  
  @observable
  bool formDisabled = true;
  void formDisabledChanged(oldValue, newValue) {
    shadowRoot.querySelectorAll('input').forEach((elem) {
      if (newValue) {
        elem.classes.remove('editable');
      } else {
        elem.classes.add('editable');
      }
    });
  }
  
  @observable
  String name;
  void nameChanged(oldValue, newValue) {
    if (oldValue == null)
      return;
    _showSaveButton();
    _unsavedState['name'] = newValue;
  }
  
  @observable
  String description;
  descriptionChanged(oldValue, newValue) {
    if (oldValue == null)
      return;
    _showSaveButton();
    _unsavedState['description'] = newValue;
  }
  
  @observable
  String price;
  priceChanged(o, n) {
    if (o == null)
      return;
    _showSaveButton();
    if (_PRICE_PATTERN.matchAsPrefix(n) == null) {
      $['price'].classes.add('invalid');
      return;
    }
    $['price'].classes.remove('invalid');
    _unsavedState['price'] = n;
  }
  
  AssetDetails.created(): super.created() {
    _unsavedState = <String,dynamic>{};
  }
  
  void attached() {
    super.attached();
    $['mainform'].action = qrcode;
  }
  
  /// The context pane which contains this element.
  /// Set after loading.
  ContextPanel contextPanel;
  
  void toggleForm(Event evt) {
    formDisabled = !formDisabled;
  }
  
  @override
  Future loadFromUri(String uri, {Map<String,dynamic> restoreData: const {}}) {
    print('loading from uri');
    print('Restore data: $restoreData');
    
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
      $['mainform'].action = qrcode;
      content.addAll(restoreData);
      name = content['name'];
      description = content['description'];
      price = content['price'];
      if (restoreData.isNotEmpty)
        _showSaveButton();
    });
  }

  @override
  Map<String, dynamic> saveData() {
    _unsavedState['hello'] = 'world';
    return _unsavedState;
  }
  
  void _showSaveButton() {
    shadowRoot.querySelectorAll('.hidden').forEach((Element elem) {
      elem.classes.remove('hidden');
    });
  }
}