import 'package:meta/meta.dart';

class LoginResponse {
  LoginResponse({
    @required this.kind,
    @required this.localId,
    @required this.email,
    this.displayName,
    @required this.idToken,
    @required this.registered,
    @required this.refreshToken,
    @required this.expiresIn,
  });

  final String kind;
  final String localId;
  final String email;
  final String displayName;
  final String idToken;
  final bool registered;
  final String refreshToken;
  final int expiresIn;

  factory LoginResponse.fromMap(Map<String, dynamic> map) => LoginResponse(
        kind: map['kind'],
        localId: map['localId'],
        email: map['email'],
        displayName: map['displayName'],
        idToken: map['idToken'],
        registered: map['registered'],
        refreshToken: map['refreshToken'],
        expiresIn: int.parse(map['expiresIn']),
      );
}
