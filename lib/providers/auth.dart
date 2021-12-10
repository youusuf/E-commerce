// ignore_for_file: avoid_init_to_null, duplicate_ignore

import 'dart:convert';
import 'package:e_commerce/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: duplicate_ignore, duplicate_ignore
class Auth with ChangeNotifier{
String? _token;
DateTime? _expiryDate;
String? _userId;
Timer? _authTimer;


  bool get isAuth{
    return token != null;
  }
      String? get token{
      if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null && _token !=''){
        return _token;
      }
      return null;
    }
      String? get userId=>_userId;
      Future<void> authetication(String email,String password,String uriSagment)async{

    try{
      var url = 'https://identitytoolkit.googleapis.com/v1/accounts:$uriSagment?key=AIzaSyAgG9IHLicl4KdMu13PecHy55a60p8UlKY';
      var response = await http.post(Uri.parse(url),body:json.encode({
      'email':email,
      'password':password,
      'returnSecureToken':true
    }));
      final responseData = json.decode(response.body);
    if(responseData['error'] !=null){
      throw HTTPException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate =DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));   
    _autoLogOut();
    notifyListeners();
    final preference =await SharedPreferences.getInstance();
    final userData = json.encode({
      'token':_token,
      'userId':_userId,
      'expiryDate':_expiryDate!.toIso8601String()
    });

    preference.setString('UserData', userData);
    }
    catch(error){
        throw error;
    }
}
Future<void> signUp(String email,String password)async{
  return authetication(email, password, 'signUp');
}



    Future<bool> tryAutoLogIn()async{
      final prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('UserData')){
        return false;
      }
      final extractedData = json.decode(prefs.getString("UserData")!) as Map<String,dynamic>;
      final expiryDate = DateTime.parse(extractedData['expiryDate']);
      if(expiryDate.isBefore(DateTime.now())){
      return false;
      }
        _token = extractedData['token'];
        _userId = extractedData['userId'];
        _expiryDate = extractedData['expiryDate'];
        notifyListeners();
        _autoLogOut();
      return true;



    }
Future<void>logIn(String email,String password)async{
  return authetication(email, password, 'signInWithPassword');
}
  Future<void> logOut()async{
     _token = null;
     _expiryDate = null;
     _userId = null;
      if(_authTimer!=null){
          _authTimer!.cancel();
          _authTimer =null;
        }
     notifyListeners();   
     final prefs = await SharedPreferences.getInstance();
     prefs.clear();
  }
      void _autoLogOut(){
        if(_authTimer!=null){
          _authTimer!.cancel();
        }

        var timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
        _authTimer = Timer(const Duration(seconds: 10),logOut);
      }

}