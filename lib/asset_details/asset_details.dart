import 'dart:async';
import 'dart:convert' show JSON;
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:cs_elements/json_form/json_form.dart';
import 'package:cs_elements/session/session.dart';
import '../form_controls/form_controls.dart';

@CustomTag('asset-details')
class AssetDetails extends PolymerElement {
  static final _PRICE_PATTERN = new RegExp(r'[a-zA-Z]{3} \d+(\.\d+)?');
  
  Map<String,dynamic> _resetData;
  
  ContentElement get _content => shadowRoot.querySelector('content');
  
  @published
  String qrcode;
  
  @published
  String formMethod;
  
  @observable
  bool formDisabled;
  
  AssetDetails.created(): super.created() {
    _resetData = <String,dynamic>{};
  }
  
  void attached() {
    super.attached();
    $['assetForm'].action = qrcode;
    FormControlsElement controls = shadowRoot.querySelector('form-controls');
    controls.onEdit.listen(editForm);
    controls.onSave.listen(saveForm);
    controls.onCancel.listen(cancelForm);
    
    if (formMethod == 'POST') {
      this.formDisabled = false;
    }
  }
  
  /*
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
    });
  }
  */
  
  void editForm([Event e]) {
    this.formDisabled = false;
    void enableInput(elem) {
      elem.disabled = false;
      _resetData[elem.name] = elem.value;
      elem.classes.add('editable');
    }
        
    this.querySelectorAll('input').forEach(enableInput);
    this.querySelectorAll('cs-money-input').forEach(enableInput);
  }
  
  void saveForm(Event e) {
    if (formMethod != 'POST') {
      this.formDisabled = true;
    }
    JsonFormElement form = this.$['assetForm'];
    if (formMethod == 'POST') {
      form.action = '/assets/create';
    }
    form.submit(client: session.httpClient).then((result) {
      if (result.statusCode == 200) {
        print('Success');
        print(JSON.decode(result.body));
      }
    });
  }
  
  void cancelForm(Event e) {
    if (formMethod != 'POST') {
      this.formDisabled = true;
    }
    void disableInput(elem) {
      if (formMethod == 'POST') {
        elem.value = '';
      } else {
        elem.disabled = true;
        if (_resetData.containsKey(elem.name)) {
          elem.value = _resetData[elem.name];
        }
        elem.classes.remove('editable');
      }
    }
    
    this.querySelectorAll('input').forEach(disableInput);
    this.querySelectorAll('cs-money-input').forEach(disableInput);
  }
}