import 'dart:core';
import 'package:oauth2/oauth2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  final _storage = new FlutterSecureStorage();
  static const String _storageKey = "Raco_";

  //Singleton
  UserRepository._internal();
  static final UserRepository _user = UserRepository._internal();
  factory UserRepository() {
    return _user;
  }

  Future<void> writeToStorage(String key, String value) async {
    await _storage.write(key: _storageKey + key, value: value);
  }

  Future<String> readFromStorage(String key) async {
    return await _storage.read(key: _storageKey + key);
  }

  Future<void> _deleteFromStorage(String key) async {
    if (await readFromStorage(key) != null) {
      await _storage.delete(key: _storageKey + key);
    }
  }

  Future<bool> writeToPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_storageKey + key, value);

  }

  Future<bool> isPresentInPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_storageKey + key);
  }

  Future<String> readFromPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_storageKey + key) ?? '';
  }

  Future<bool> removeFromPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_storageKey + key);
  }

  Future<void> deleteCredentials() async {
    /// delete from keystore/keychain
/*    await _deleteFromStorage('accessToken');
    await _deleteFromStorage('refreshToken');
    await _deleteFromStorage('tokenEndpoint');
    int n = int.parse(await readFromStorage('nscopes'));
    for (int i = 0; i < n; i++) {
      await _deleteFromStorage('scope' + i.toString());
    }
    await _deleteFromStorage('nscopes');
    await _deleteFromStorage('expiration');*/
    await _deleteFromStorage('oauthJson');
  }

  Future<void> persistCredentials(Credentials credentials) async {
    /// write to keystore/keychain
/*    await writeToStorage('accessToken', credentials.accessToken);
    await writeToStorage('refreshToken', credentials.refreshToken);
    await writeToStorage('tokenEndpoint', credentials.tokenEndpoint.toString());
    await writeToStorage('nscopes', credentials.scopes.length.toString());
    for (int i = 0; i < credentials.scopes.length; i++) {
      await writeToStorage('scope' + i.toString(), credentials.scopes[i]);
    }
    await writeToStorage('expiration', credentials.expiration.toIso8601String());*/
    await writeToStorage('oauthJson', credentials.toJson());
  }

  Future<String> getAccessToken() async {
    Credentials c = Credentials.fromJson(await readFromStorage('oauthJson'));
    return c.accessToken;
  }

  Future<Credentials> getCredentials() async {
    return Credentials.fromJson(await readFromStorage('oauthJson'));
  }

  Future<bool> hasCredentials() async {
    /// read from keystore/keychain
    bool hasCreds = true;
    String at = await readFromStorage('oauthJson');
    if (at == null) return false;
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

  Future<void> setLoggedAsVisitor() async {
    await writeToStorage('visitor', 'true');
  }

  Future<void> deleteVisitor() async {
    await _deleteFromStorage('visitor');
  }

  Future<bool> isLoggedAsVisitor() async {
    String isVisitor = await readFromStorage('visitor');
    if (isVisitor == 'true') {
      return true;
    }
    return false;
  }

  Future<String> getPreferredLanguage() async {
    return readFromPreferences('language');
  }

  Future<bool> setPreferredLanguage(String lang) async {
    return writeToPreferences('language', lang);
  }
}

UserRepository user = UserRepository();
