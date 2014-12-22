import 'dart:async';
import 'dart:convert' show JSON;
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:cs_elements/json_form/json_form.dart';
import 'package:cs_elements/session/session.dart';
import 'package:cs_elements/form_controls/form_controls.dart';

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
  String formControlState;

  AssetDetails.created(): super.created() {
    _resetData = <String,dynamic>{};
  }

  void attached() {
    super.attached();
    $['assetForm'].action = qrcode;
    formControlState = formMethod == 'POST' ? 'enabled': 'disabled';
  }

  void editForm([Event e]) {
    formControlState = 'enabled';
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
      formControlState = 'enabled';
    }
    JsonFormElement form = this.$['assetForm'];
    if (formMethod == 'POST') {
      form.action = '/assets/create';
    }
    form.submit(client: session.httpClient).then((result) {
      if (result.statusCode == 200) {
        print('Success');
        print(JSON.decode(result.body));
        window.location.reload();
      }
    });
  }

  void cancelForm(Event e) {
    if (formMethod != 'POST') {
      formControlState = 'disabled';
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