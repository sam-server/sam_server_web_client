library web_client.login_form;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:cs_elements/json_form/json_form.dart';

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
  
  LoginForm.created(): super.created();
  
  void attached() {
    _form.onSubmit.listen((evt) {
      var statusCode = evt.detail.statusCode;
      var json = evt.detail.responseJson;
      if (statusCode != 200) {
        errorMessage = json['error'];
      }
      
      print(json);
      this.fire('login-form-login', detail: json);
    });
  }
  
  JsonFormElement get _form => $['form'];
  
  void checkConfirmPassword() {
    if (password != confirmPassword) {
      errorMessage = 'Passwords do not match';
    } else {
      errorMessage = '';
    }
  }
  
  void submitForm(Event e) {
    if (username == null || username.isEmpty)
      errorMessage = 'No username provided';
    if (password == null || password.isEmpty)
      errorMessage = 'No username provided';
    if (errorMessage == null || errorMessage.isEmpty)
      return;
    _form.submit();
  }
}