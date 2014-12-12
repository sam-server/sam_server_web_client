library web_client.form_controls;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';

@CustomTag('form-controls')
class FormControlsElement extends PolymerElement {
  static const _EDIT_CLICK_EVT = 'form-toggle-edit';
  static const _SAVE_CLICK_EVT = 'form-toggle-save';
  static const _CANCEL_CLICK_EVT = 'form-toggle-cancel';
  
  Stream<Event> get onEdit => on[_EDIT_CLICK_EVT];
  Stream<Event> get onSave => on[_SAVE_CLICK_EVT];
  Stream<Event> get onCancel => on[_CANCEL_CLICK_EVT];
  
  @published
  bool get disabled => readValue(#disabled, () => true);
  set disabled(bool value) => writeValue(#disabled, value);
  
  FormControlsElement.created(): super.created();
  
  void handleSave(Event e) {
    e.preventDefault();
    this.disabled = true;
    this.fire(_SAVE_CLICK_EVT);
  }
  
  void handleEdit(Event e) {
    e.preventDefault();
    this.disabled = false;
    this.fire(_EDIT_CLICK_EVT);
  }
  
  void handleCancel(Event e) {
    this.disabled = false;
    this.fire(_CANCEL_CLICK_EVT);
  }
}