
import 'package:connectivity/connectivity.dart';

/// Common util to check internet connectivity status
class NetworkUtils {

  /// Check isNetwork available or not
  static Future<bool> isNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
