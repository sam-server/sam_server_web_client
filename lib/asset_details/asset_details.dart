import 'dart:async';
import 'dart:convert' show JSON;
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:polymer_ajax_form/ajax_form.dart';
import 'package:cs_elements/session/session.dart';

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

  @observable
  SessionElement session;

  StreamSubscription _sessionHeadersObserver;

  AssetDetails.created(): super.created() {
    _resetData = <String,dynamic>{};
  }

  void attached() {
    super.attached();
    $['assetForm'].action = qrcode;
    formControlState = formMethod == 'POST' ? 'enabled': 'disabled';

    Polymer.onReady.then((_) {
      session = document.querySelector('cs-session');
    });
  }

  void detached() {
    if (_sessionHeadersObserver != null) {
      _sessionHeadersObserver.cancel().then((_) {
        _sessionHeadersObserver = null;
      });
    }
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
    AjaxFormElement form = this.$['assetForm'];
    if (formMethod == 'POST') {
      form.action = '/asset';
    }

    form.onFormComplete.first.then((evt) {
      var xhr = evt.detail['xhr'];
      if (xhr.status == 200) {
        var responseData = JSON.decode(xhr.response);
        responseData.forEach((k,v) {
          _resetData[k] = v;
        });
        this.resetForm();
      } else {
        //TODO: Better error handling.
        print('An error occurred: ${xhr.status}');
        print(xhr.response);
      }
    });

    form.submit();
  }

  void resetForm([Event e]) {
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
    this.querySelectorAll('money-input').forEach(disableInput);
  }
}