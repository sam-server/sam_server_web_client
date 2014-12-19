library web_client.auth.signup_form;

import 'dart:html';
import 'dart:convert' show JSON;

import 'package:polymer/polymer.dart';
import 'package:cs_elements/json_form/json_form.dart';
import 'package:cs_elements/session/session.dart';

@CustomTag('signup-form')
class SignupForm extends PolymerElement {

  @observable
  String username;

  @observable
  String email;

  @observable
  String password;

  @observable
  String errorMessage;

  PathObserver _scoreObserver;

  SignupForm.created(): super.created() {
    this.errorMessage = 'Password too weak';
  }

  void attached() {
    InputElement confirmPassword = $['confirmPassword'];
    confirmPassword.onInput.listen(checkPasswordsMatch);

    this._scoreObserver = new PathObserver($['passwordStrength'], 'score');
    var currentScore = _scoreObserver.open((newValue, oldValue) {
      errorMessage = (newValue <= 1) ? 'Password too weak': '';
    });

    $['controls'].onSave.listen(submitForm);
  }

  void detached() {
    _scoreObserver.close();
  }

  void checkPasswordsMatch(Event e) {
    var password = $['password'].value;
    var confirmPassword = $['confirmPassword'].value;
    if (password != confirmPassword) {
      errorMessage = 'passwords do not match';
    } else {
      errorMessage = '';
    }
  }

  void submitForm([Event e]) {
    var emailInput = $['email'] as InputElement;
    if (!emailInput.validity.valid)
      errorMessage = emailInput.validationMessage;
    if (username == null || username.isEmpty)
      errorMessage = 'Username must be provided';

    if (errorMessage != null && errorMessage.isNotEmpty) {
      return;
    }
    JsonFormElement form = $['mainform'];
    SessionElement session = document.querySelector('cs-session');
    form.submit(client: session.httpClient).then((response) {
      var body = JSON.decode(response.body);
      if (response.statusCode != 200) {
        errorMessage = body['error'];
        return;
      }
      window.location.href = '/auth/login';
    });
  }
}