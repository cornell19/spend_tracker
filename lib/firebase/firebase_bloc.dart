import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:spend_tracker/firebase/apis.dart';
import 'package:spend_tracker/models/models.dart';

class FirebaseBloc {
  FirebaseBloc({@required this.apis});

  final _securityPubSub = PublishSubject<bool>();
  final _accountsBehavSub = BehaviorSubject<List<Account>>();
  final Apis apis;

  Observable<bool> get loginStatus => _securityPubSub.stream;
  Observable<List<Account>> get accounts => _accountsBehavSub.stream;

  Future getAccounts() async {
    try {
      var accounts = await apis.getAccounts();
      _accountsBehavSub.sink.add(accounts);
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

  Future createAccount(Account account) async {
    try {
      await apis.createAccount(account);
      _accountsBehavSub.sink.add(null);
      await getAccounts();
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

  Future updateAccount(Account account) async {
    try {
      await apis.updateAccount(account);
      _accountsBehavSub.sink.add(null);
      await getAccounts();
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

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
    _accountsBehavSub.close();
  }
}
