import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

/// This is singleton class , used to manage sharedPrefernces in entire application.
class PreferenceHelper {
  static PreferenceHelper _singleton;
  static SharedPreferences _prefs;
  static Lock _lock = Lock();

  static Future<PreferenceHelper> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          var singleton = PreferenceHelper._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  PreferenceHelper._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // put object
  static Future<bool> putObject(String key, Object value) {
    if (_prefs == null) return null;
    return _prefs.setString(key, value == null ? "" : json.encode(value));
  }

  // get obj
  static T getObj<T>(String key, T f(Map v), {T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  // get object
  static Map getObject(String key) {
    if (_prefs == null) return null;
    String _data = _prefs.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }



  static Future<bool> setPreference1(String key,var value)  {

    if (_prefs == null) return null;

    if(value is int){
      return setInt(key, value);
    }else if(value is String){
    return  setString(key, value);
    }else if(value is double){
      return  putDouble(key, value);
    }else if(value is bool){
      return  putBool(key, value);
    }else if(value is List<String>){
      return  putStringList(key, value);
    }
    return throw Exception("Datatype not available");
  }



  // put object list
  static Future<bool> putObjectList(String key, List<Object> list) {
    if (_prefs == null) return null;
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return _prefs.setStringList(key, _dataList);
  }

  // get obj list
  static List<T> getObjList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key);
    List<T> list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }

  // get object list
  static List<Map> getObjectList(String key) {
    if (_prefs == null) return null;
    List<String> dataLis = _prefs.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_prefs == null) return defValue;
    return _prefs.getString(key) ?? defValue;
  }

  // set string
  static Future<bool> setString(String key, String value) {
    if (_prefs == null) return null;
    return _prefs.setString(key, value);
  }
  static Future<bool> setBool(String key, bool value) {
    if (_prefs == null) return null;
    return _prefs.setBool(key, value);
  }

  // get bool
  static bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) return defValue;
    return _prefs.getBool(key) ?? defValue;
  }

  // put bool
  static Future<bool> putBool(String key, bool value) {
    if (_prefs == null) return null;
    return _prefs.setBool(key, value);
  }

  // get int
  static int getInt(String key, {int defValue = 0}) {
    if (_prefs == null) return defValue;
    return _prefs.getInt(key) ?? defValue;
  }

  // set int.
  static Future<bool> setInt(String key, int value) {
    if (_prefs == null) return null;
    return _prefs.setInt(key, value);
  }
  // set int.
  static Future<bool> setDouble(String key, double value) {
    if (_prefs == null) return null;
    return _prefs.setDouble(key, value);
  }

  // get double
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_prefs == null) return defValue;
    return _prefs.getDouble(key) ?? defValue;
  }

  // put double
  static Future<bool> putDouble(String key, double value) {
    if (_prefs == null) return null;
    return _prefs.setDouble(key, value);
  }

  // get string list
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_prefs == null) return defValue;
    return _prefs.getStringList(key) ?? defValue;
  }

  // put string list
  static Future<bool> putStringList(String key, List<String> value) {
    if (_prefs == null) return null;
    return _prefs.setStringList(key, value);
  }

  // get dynamic
  static dynamic getDynamic(String key, {Object defValue}) {
    if (_prefs == null) return defValue;
    return _prefs.get(key) ?? defValue;
  }

  // have key
  static bool haveKey(String key) {
    if (_prefs == null) return null;
    return _prefs.getKeys().contains(key);
  }

  // get keys
  static Set<String> getKeys() {
    if (_prefs == null) return null;
    return _prefs.getKeys();
  }

  // remove
  static Future<bool> remove(String key) {
    if (_prefs == null) return null;
    return _prefs.remove(key);
  }

  // clear
  static Future<void> clear() async {
    if (_prefs == null) return null;
    return _prefs.clear();
  }

  //PreferenceHelper is initialized
  static bool isInitialized() {
    return _prefs != null;
  }

}
