library web_client.login_form;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:polymer_ajax_form/ajax_form.dart';
import 'package:cs_elements/session/session.dart';

@CustomTag('login-form')
class LoginForm extends PolymerElement {

  Stream<Event> get onLogin => on['login-form-login'];

  @observable
  String errorMessage;

  @observable
  String username;

  @observable
  String password;

  @observable
  String confirmPassword;

  @observable
  SessionElement session;

  StreamSubscription _formSubmit;
  StreamSubscription _formError;


  LoginForm.created(): super.created();

  void attached() {
    _formSubmit = _form.onResponse.listen((evt) {
      window.location.href = '/';
    });
    _formError = _form.onResponseError.listen((evt) {
      HttpRequest xhr = evt.detail['xhr'];
      errorMessage = xhr.response;
    });
    Polymer.onReady.then((_) {
      this.session = document.querySelector('cs-session');
    });
  }

  void detached() {
    if (_formSubmit != null)
      _formSubmit.cancel();
    if (_formError != null)
      _formError.cancel();
  }

  AjaxFormElement get _form => shadowRoot.querySelector('form[is=ajax-form]');

  void checkConfirmPassword() {
    if (password != confirmPassword) {
      errorMessage = 'Passwords do not match';
    } else {
      errorMessage = '';
    }
  }

  void submitForm(Event e) {
    e.preventDefault();
    if (username == null || username.isEmpty)
      errorMessage = 'No username provided';
    if (password == null || password.isEmpty)
      errorMessage = 'No username provided';
    if (errorMessage != null && errorMessage.isNotEmpty)
      return;
    _form.submit();
  }
}