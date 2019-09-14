import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart';

class UserRepository {
  final storage = new FlutterSecureStorage();

  UserRepository._internal();

  static final UserRepository instance = UserRepository._internal();

  Future<void> deleteCredentials() async {
    /// delete from keystore/keychain
    await storage.deleteAll();
    return;
  }

  Future<void> persistCredentials(Credentials credentials) async {
    /// write to keystore/keychain
    await storage.write(key: 'accessToken', value: credentials.accessToken);
    await storage.write(key: 'refreshToken', value: credentials.refreshToken);
    await storage.write(key: 'tokenEndpoint', value: credentials.tokenEndpoint.toString());
    await storage.write(key: 'nscopes', value: credentials.scopes.length.toString());
    for (int i = 0; i < credentials.scopes.length; i++) {
      await storage.write(key: 'scope'+ i.toString(), value: credentials.scopes[i]);
    }
    await storage.write(key: 'expiration', value: credentials.expiration.toIso8601String());
    return;
  }

  Future<bool> hasCredentials() async {
    /// read from keystore/keychain
    bool hasCreds = true;
    String at = await storage.read(key: 'accessToken');
    if(at == null) return false;
    /*
    String rt = await storage.read(key: 'refreshToken');
    if(rt == null) return false;
    String te = await storage.read(key: 'tokenEndpoint');
    if(te == null) return false;
    int nscopes = int.parse(await storage.read(key: 'nscopes'));
    for (int i = 0; i < nscopes; i++) {
      String s = await storage.read(key: 'scope'+i.toString());
      if (s == null) return false;
    }
    String exp = await storage.read(key: 'expiration');
    if (exp == null) {
      return false;
    }
    */

    return hasCreds;
  }

  Future<void> setLoggedAsVisitor() async{
    await storage.write(key: 'visitor', value: 'true');
  }

  Future<bool> isLoggedAsVisitor() async{
    String isVisitor = await storage.read(key: 'visitor');
    if (isVisitor == 'true') {
      return true;
    }
    return false;
  }

}