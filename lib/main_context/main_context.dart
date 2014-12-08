import 'package:polymer/polymer.dart';
import 'package:cs_elements/context_pane/context_pane.dart';

@CustomTag('main-context')
class MainContext extends PolymerElement with DelegatingContextPane {
  ContextPane get delegate => $['ctxt'];
  
  String _tempHref = '';
  
  @published
  String get href => readValue(#href, () => '');
  set href(String value) => writeValue(#href, value);
  hrefChanged(oldValue, newValue) {
    if (delegate != null) {
      delegate.href = newValue;
    }
  }
  
  MainContext.created(): super.created();
  
}