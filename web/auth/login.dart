
import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:cs_elements/session/session.dart';

import 'package:sam_server_web_client/auth/login_form/login_form.dart';
import 'package:sam_server_web_client/polymer_utils.dart';

void main() {
  initPolymer().run(() {
    polymerReady.then((_) {
      LoginForm loginForm = querySelector('login-form');
      loginForm.onLogin.listen((evt) {
        var userDetails = evt.detail;
        var queryString = window.location.search;
        for (var query in queryString.split('&')) {
          query = query.trim();
          if (query.startsWith('cb=')) {
            var redirect = query.substring('cb='.length);
            print('Redirecting to $redirect');
            window.location.href = redirect;
          }
        }
        window.location.href = '';
      });
    });
  });
}