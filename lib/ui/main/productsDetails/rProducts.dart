import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/categories.dart';
import 'package:fooddelivery/model/foods.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/loadProducts.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/widget/ICard21FileCaching.dart';
import 'package:fooddelivery/widget/ilist1.dart';

rProductsLoad(DishesData _this, Function redraw){
  var need = List<String>();
  for (var item in _this.rproducts) {
    var product = loadFood(item.rp);
    if (product == null)
      need.add(item.rp);
  }
  if (need.isNotEmpty)
    loadProducts(need, (List<DishesData> data) {
      print(data);
      foodsAll.addAll(data);
      redraw();
    }, (String _){});
}

rProducts(DishesData _this, List<Widget> list, double windowWidth,
    Function (String id, String heroId) callback, Function _onAddToCartClick){

  var list2 = List<Widget>();
  list2.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.restaurantCardHeight/40;
  for (var product in _this.rproducts) {
    var item = loadFood(product.rp);
    if (item != null){
      list2.add(ICard21FileCaching(
        needAddToCart: false,
        radius: appSettings.radius,
        shadow: appSettings.shadow,
        colorProgressBar: theme.colorPrimary,
        color: theme.colorBackground,
        getFavoriteState: account.getFavoritesState,
        revertFavoriteState: account.revertFavoriteState,
        text: item.name,
        enableFavorites: account.isAuth(),
        width: windowWidth*0.6,
        height: height,
        image: "$serverImages${item.image}",
        id: item.id,
        text3: (theme.multiple) ? item.restaurantName : getCategoryName(item.category),
        discount: item.discount,
        discountprice: (item.discountprice != 0) ? basket.makePriceString(item.discountprice) : "",
        price: basket.makePriceString(item.price),
        textStyle2: theme.text18boldPrimaryUI,
        textStyle: theme.text18boldPrimaryUI,
        textStyle3: theme.text16UI,
        callback: callback,
        onAddToCartClick: _onAddToCartClick,
      ));
      list2.add(SizedBox(width: 10,));
    }
  }
  if (list2.length == 1)
    return;

  list.add(Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    child: IList1(imageAsset: "assets/ingredients.png", text: strings.get(296),               // See Also
        textStyle: theme.text16bold, imageColor: theme.colorDefaultText),
  ));
  list.add(SizedBox(height: 20,));

  list.add(Container(
    height: height+20,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list2,
    ),
  ));

  list.add(SizedBox(height: 20,));
}
