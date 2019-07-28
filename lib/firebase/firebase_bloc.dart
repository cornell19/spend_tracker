import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:spend_tracker/firebase/apis.dart';

class FirebaseBloc {
  FirebaseBloc({@required this.apis});

  final _securityPubSub = PublishSubject<bool>();
  final Apis apis;

  Observable<bool> get loginStatus => _securityPubSub.stream;

  void login(String email, String password) async {
    try {
      await apis.login(email, password);
      _securityPubSub.sink.add(true);
    } catch (err) {
      _securityPubSub.sink.addError(err.toString());
    }
  }

  void dispose() {
    _securityPubSub.close();
  }
}
