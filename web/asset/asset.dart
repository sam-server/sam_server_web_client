
import 'dart:convert' show JSON;
import 'dart:html';

import 'package:http/src/response.dart';
import 'package:polymer/polymer.dart' as polymer;

import 'package:cs_elements/json_form/json_form.dart';
import 'package:cs_elements/session/session.dart';
import 'package:sam_server_web_client/form_controls/form_controls.dart';
import 'package:sam_server_web_client/polymer_utils.dart';

Map<String,dynamic> _resetData;

JsonFormElement form;
FormControlsElement formControls;
SessionElement sessionElement;

void main() {
  polymer.initPolymer().run(() {
    polymerReady.then((_) {
      sessionElement = querySelector('cs-session');
      form = document.body.querySelector('form[is=cs-json-form]');
      formControls = form.querySelector('form-controls');
      formControls
          ..onEdit.listen(editForm)
          ..onCancel.listen(cancelForm)
          ..onSave.listen(saveForm);
    });
  });
}

void editForm(Event e) {
  _resetData = <String,dynamic>{};
  querySelectorAll('input').forEach((elem) {
    _resetData[elem.name] = elem.value;
    elem.classes.add('editable');
  });
}

void cancelForm(Event e) {
  querySelectorAll('input').forEach((elem) {
    elem.value = _resetData[elem.name];
    elem.classes.remove('editable');
  });
}

void saveForm(Event e) {
  JsonFormElement form = querySelector('#assetForm');
  formControls.disabled = true;
  form.submit(client: sessionElement.httpClient).then((Response response) {
    
    var body = JSON.decode(response.body);
    if (body['kind'] != 'assets#asset') {
      throw new StateError('Invalid \'kind\' in response body');
    }
    (form.querySelector('#name') as InputElement).value = body['name'];
    (form.querySelector('#description') as InputElement).value = body['description'];
    (form.querySelector('#price') as InputElement).value = body['price'];
  });
}