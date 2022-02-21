import 'package:fooddelivery/data/services/response/home_screen_response.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';

List<CategoryDataNew> categories = [];

getCategoryName(String id){
  for (var item in categories)
    if (item.id == id)
      return item.categoryName;
    return "";
}

