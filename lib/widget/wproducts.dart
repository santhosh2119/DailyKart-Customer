import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/services/response/home_screen_response.dart';
import 'package:fooddelivery/data/services/response/product_info_model.dart';
import 'package:fooddelivery/model/categories.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/widget/ICard21FileCachingNew.dart';
import 'package:fooddelivery/widget/wsearch.dart';
import '../main.dart';
import 'ICard12FileCaching.dart';
import 'ICard21FileCaching.dart';
import 'ICard30FileCaching.dart';
import 'ICard32FileCaching.dart';

dishList2(List<Widget> list, List<DishesData> _mostPopular, BuildContext context,
    Function(String id, String heroId)  _onMostPopularClick, double windowWidth,
    String searchByCategory, Function(String) onAddToCartClick){
  // debug
  // _mostPopular =  [
  //   DishesData(image: "1603721362095s1.jpeg", name: "1", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "2", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "3", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "4", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "5", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "6", restaurantName: "1", price: 1, id: "1"),
  //   // DishesData(image: "1603721362095s1.jpeg", name: "7", restaurantName: "1", price: 1, id: "1"),
  //   // DishesData(image: "1603721362095s1.jpeg", name: "8", restaurantName: "1", price: 1, id: "1"),
  // ];

  if (_mostPopular == null)
    return;
  var size = _mostPopular.length;

  List<Widget> _childs = [];
  bool first = true;

  var constHeight = windowWidth*0.7;
  var _height = constHeight;
  var y1Start = 10.0;
  var y2Start = 10.0;

  var index = 0;
  for (var item in _mostPopular) {
    if (restaurantSearchValue != "0" && item.restaurant != restaurantSearchValue)
      continue;
    if (categoriesSearchValue != "0" && item.category != categoriesSearchValue)
      continue;
    if (searchByCategory.isNotEmpty && item.category != searchByCategory) {
      var search = false;
      var start = false;
      for (var temp in treeViewCategory){
        for (var temp2 in temp){
          if (temp2.id == searchByCategory){
            start = true;
            break;
          }
          if (start && temp2.id == item.category)
            search = true;
        }
      }
      if (!search)
        continue;
    }
    if (first) {
      _height = constHeight;

      if (index == 0 && size > 2)
        _height = constHeight/2-5;

      if (index == size-1 && size > 2)
        _height = constHeight/2-5;

      first = false;
      _childs.add(Container(
        width: windowWidth/2-15,
        height: _height,
        margin: EdgeInsets.only(top: y1Start, left: 10, right: 5),
        child: _card32item(item, windowWidth, _height, _onMostPopularClick, onAddToCartClick),
      ));
      y1Start += _height+10;
    }else{
      _height = constHeight;

      if (index == size-1 && size > 2)
        _height = constHeight/2-5;

      first = true;
      var margin = EdgeInsets.only(left: windowWidth/2+5, top: y2Start, right: 10);
      if (strings.direction == TextDirection.rtl)
        margin = EdgeInsets.only(right: windowWidth/2+5, top: y2Start, left: 10);

      _childs.add(Container(
        width: windowWidth/2-15,
        height: _height,
        margin: margin,
        child: _card32item(item, windowWidth, _height, _onMostPopularClick, onAddToCartClick),
      ));

      y2Start += (_height+10);
    }
    index++;
  }
  if (y2Start == 10)
    y2Start = _height;
  if (size == 1 || size == 2)
    y2Start = constHeight;
  if (_childs.length != 0)
    list.add(Container(
      width: windowWidth,
      height: y2Start+20,
      child: Stack(
        children: _childs,
      ),
    ));
  return;
}

_card32item(DishesData item, double windowWidth, double _height, Function(String id, String heroId)  _onMostPopularClick,
    Function(String) onAddToCartClick){
  return ICard32FileCaching(
    radius: appSettings.radius,
    shadow: appSettings.shadow,
    colorProgressBar: theme.colorPrimary,
    getFavoriteState: account.getFavoritesState,
    revertFavoriteState: account.revertFavoriteState,
    color: theme.colorBackground,
    text: item.name,
    text3: (theme.multiple) ? item.restaurantName : getCategoryName(item.category),
    enableFavorites: account.isAuth(),
    width: windowWidth * 0.5 - 20,
    height: _height,
    image: "$serverImages${item.image}",
    dicount: item.discount,
    id: item.id,
    //
    price: basket.makePriceString(item.price),
    discountprice: (item.discountprice != 0) ? basket.makePriceString(item.discountprice) : "",
    //
    onAddToCartClick: onAddToCartClick,
    textStyle2: theme.text18boldPrimaryUIWhite,
    textStyle: theme.text18boldPrimaryUIWhite,
    textStyle3: theme.text16UIWhite,
    callback: _onMostPopularClick,
  );
}

//This method display products
productList(List<Widget> list, List<ProductInfoModel> _mostPopular, BuildContext context,
    Function(ProductInfoModel product, String heroId)  _onMostPopularClick, double windowWidth,
    Function(String) onAddToCartClick,Function(bool,String) onRefreshData,String searchByCategory){
  if (_mostPopular == null)
    return;
  var height = windowWidth*appSettings.dishesCardHeight/100;
  bool first = true;
  Widget t1;
  for (var item in _mostPopular) {
    if (restaurantSearchValue != "0" && item.productName != restaurantSearchValue)
      continue;
    if (categoriesSearchValue != "0" && item.categoryName != categoriesSearchValue)
      continue;
    if (searchByCategory.isNotEmpty && item.categoryName != searchByCategory) {
      var search = false;
      var start = false;
      for (var temp in treeViewCategory){
        for (var temp2 in temp){
          if (temp2.id == searchByCategory){
            start = true;
            break;
          }
          if (start && temp2.id == item.categoryName)
            search = true;
        }
      }
      if (!search)
        continue;
    }
    if (first) {
      t1 = ICard21FileCachingNew(
        radius: appSettings.radius,
        shadow: appSettings.shadow,
        colorProgressBar: theme.colorPrimary,
        getFavoriteState: account.getFavoritesState,
        revertFavoriteState: account.revertFavoriteState,
        manageFavouriteState: account.manageFavouriteItem,
        color: theme.colorBackground,
        text: item.productName,
        /*text3: (theme.multiple) ? item.productCategory : getCategoryName(item.categoryName),*/
        text3: item.categoryName,
        enableFavorites: account.isAuth(),
        width: windowWidth * 0.5 - 10,
        height: height,
        image: "$serverImages${item.productImage}",
        /*id: item.id,*/
        product: item,
        price: basket.makePriceString(double.parse(item.productPrice[0].originalprice) ),
        discountprice:  basket.makePriceString(double.parse( item.productPrice[0].sp)),
        discount: "-"+item.productPrice[0].discountPercentage.toString()+"%",
        textStyle2: theme.text18boldPrimaryUI,
        textStyle: theme.text18boldPrimaryUI,
        textStyle3: theme.text16UI,
        callback: _onMostPopularClick,
        onAddToCartClick: onAddToCartClick,
      );
      first = false;
    }else{
      var t2 = ICard21FileCachingNew(
        radius: appSettings.radius,
        shadow: appSettings.shadow,
        colorProgressBar: theme.colorPrimary,
        color: theme.colorBackground,
        getFavoriteState: account.getFavoritesState,
        revertFavoriteState: account.revertFavoriteState,
        text: item.productName,
        enableFavorites: account.isAuth(),
        width: windowWidth * 0.5 - 10,
        height: height,
        image: "$serverImages${item.productImage}",
        /*id: item.id,*/
        product: item,
        /*text3: (theme.multiple) ? item.productCategory : getCategoryName(item.categoryName),*/
        text3: item.categoryName,
        discountprice:  basket.makePriceString(double.parse( item.productPrice[0].sp)),
        discount: "-"+item.productPrice[0].discountPercentage.toString()+"%",
        price: basket.makePriceString(double.parse(item.productPrice[0].originalprice) ),
        textStyle2: theme.text18boldPrimaryUI,
        textStyle: theme.text18boldPrimaryUI,
        textStyle3: theme.text16UI,
        callback: _onMostPopularClick,
        onAddToCartClick: onAddToCartClick,
      );
      list.add(Container(
        color: appSettings.dishesBackgroundColor,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            t1,
            t2
          ],
        ),
      ));
      first = true;
    }
  }
  if (!first){
    list.add(Container(
      color: appSettings.dishesBackgroundColor,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          t1,
          Container(width: windowWidth * 0.5 - 15,)
        ],
      ),
    ));
  }
}


dishList(List<Widget> list, List<DishesData> _mostPopular, BuildContext context,
    Function(String id, String heroId)  _onMostPopularClick, double windowWidth,
    Function(String) onAddToCartClick, String searchByCategory){
  if (_mostPopular == null)
    return;
  var height = windowWidth*appSettings.dishesCardHeight/100;
  bool first = true;
  Widget t1;
  for (var item in _mostPopular) {
    if (restaurantSearchValue != "0" && item.restaurant != restaurantSearchValue)
      continue;
    if (categoriesSearchValue != "0" && item.category != categoriesSearchValue)
      continue;
    if (searchByCategory.isNotEmpty && item.category != searchByCategory) {
      var search = false;
      var start = false;
      for (var temp in treeViewCategory){
        for (var temp2 in temp){
          if (temp2.id == searchByCategory){
            start = true;
            break;
          }
          if (start && temp2.id == item.category)
            search = true;
        }
      }
      if (!search)
        continue;
    }
    if (first) {
      t1 = ICard21FileCaching(
        radius: appSettings.radius,
        shadow: appSettings.shadow,
        colorProgressBar: theme.colorPrimary,
        getFavoriteState: account.getFavoritesState,
        revertFavoriteState: account.revertFavoriteState,
        color: theme.colorBackground,
        text: item.name,
        text3: (theme.multiple) ? item.restaurantName : getCategoryName(item.category),
        enableFavorites: account.isAuth(),
        width: windowWidth * 0.5 - 10,
        height: height,
        image: "$serverImages${item.image}",
        id: item.id,
        price: basket.makePriceString(item.price),
        discountprice: (item.discountprice != 0) ? basket.makePriceString(item.discountprice) : "",
        discount: item.discount,
        textStyle2: theme.text18boldPrimaryUI,
        textStyle: theme.text18boldPrimaryUI,
        textStyle3: theme.text16UI,
        callback: _onMostPopularClick,
        onAddToCartClick: onAddToCartClick,
      );
      first = false;
    }else{
      var t2 = ICard21FileCaching(
        radius: appSettings.radius,
        shadow: appSettings.shadow,
        colorProgressBar: theme.colorPrimary,
        color: theme.colorBackground,
        getFavoriteState: account.getFavoritesState,
        revertFavoriteState: account.revertFavoriteState,
        text: item.name,
        enableFavorites: account.isAuth(),
        width: windowWidth * 0.5 - 10,
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
        callback: _onMostPopularClick,
        onAddToCartClick: onAddToCartClick,
      );
      list.add(Container(
        color: appSettings.dishesBackgroundColor,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            t1,
            t2
          ],
        ),
      ));
      first = true;
    }
  }
  if (!first){
    list.add(Container(
      color: appSettings.dishesBackgroundColor,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          t1,
          Container(width: windowWidth * 0.5 - 15,)
        ],
      ),
    ));
  }
}

dishListOneInLine(List<Widget> list, List<DishesData> productItems, Function (String id, String heroId) callback, double windowWidth,
    Function(String) onAddToCartClick, String searchByCategory) {
  if (productItems == null)
    return;
  var height = (windowWidth)*appSettings.dishesCardHeight/100;
  for (var item in productItems) {
    if (restaurantSearchValue != "0" && item.restaurant != restaurantSearchValue)
      continue;
    if (categoriesSearchValue != "0" && item.category != categoriesSearchValue)
      continue;
    if (searchByCategory.isNotEmpty && item.category != searchByCategory) {
      var search = false;
      var start = false;
      for (var temp in treeViewCategory){
        for (var temp2 in temp){
          if (temp2.id == searchByCategory){
            start = true;
            break;
          }
          if (start && temp2.id == item.category)
            search = true;
        }
      }
      if (!search)
        continue;
    }
    var t2 = ICard21FileCaching(
      radius: appSettings.radius,
      shadow: appSettings.shadow,
      colorProgressBar: theme.colorPrimary,
      color: theme.colorBackground,
      getFavoriteState: account.getFavoritesState,
      revertFavoriteState: account.revertFavoriteState,
      text: item.name,
      enableFavorites: account.isAuth(),
      width: windowWidth,
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
      onAddToCartClick: onAddToCartClick,
    );
    list.add(Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: t2
    ));
  }
}

horizontalCategoriesCircleRestaurant(List<CategoriesData> cat, double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  List<Widget> list = [];
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in cat) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;

    // if (item.parent == "0" || item.parent == "-1") {
      list.add(ICard30FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text18boldPrimaryUI,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 10,));
    }
  // }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+30,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

/**
 * Category data display in circle shape
 */
horizontalCategoriesCircle(double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  List<Widget> list = [];
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in categories) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;
    /*if (theme.vendor && item.vendor != '0')
      continue;*/
    /*if (item.parent == "0" || item.parent == "-1") {*/
      list.add(ICard30FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.categoryName,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: AppConstants.IMAGE_STAGE_BASE_URL+item.image,
        id: item.id,
        textStyle: theme.text18boldPrimaryUI,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 10,));
    /*}*/
  }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+30,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

horizontalCategories(double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  List<Widget> list = [];
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in categories) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;
    /*if (theme.vendor && item.vendor != '0')
      continue;
    if (item.parent == "0" || item.parent == "-1") {*/
      list.add(ICard12FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.categoryName,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text18boldPrimaryUI,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 10,));
    /*}*/
  }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+20,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

horizontalCategoriesRestaurant(List<CategoriesData> cat, double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  List<Widget> list = [];
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in cat) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;
    if (item.parent == "0" || item.parent == "-1") {
      list.add(ICard12FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text18boldPrimaryUI,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 10,));
    }
  }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+20,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

_findPoint2(List<CategoryDataNew> cat, String _currentCategoryId, List<List<CategoriesData>> tree){
  for (var item in cat) {
    if (item.id == _currentCategoryId) {
      tree.insert(0, _addLine(true, cat, ""));
      //TODO : here need to add subcategories
      /*if (item.parent != '0')
        tree = _findPoint2(cat, item.parent, tree);*/
      return tree;
    }
  }
  return tree;
}

_findPoint(List<CategoryDataNew> cat, String _currentCategoryId, tree){
  if (_currentCategoryId == "") {
    tree.add(_addLine('0', cat, ""));
    return tree;
  }
  for (var item in cat) {
    if (item.id == _currentCategoryId) {
      tree.add(_addLine(true, cat, item.id));
      /*if (item.parent != '0')
         tree = _findPoint2(cat, item.parent, tree);*/

        var ret = _addLine(item.id, cat, "");
        if (ret != null)
          tree.add(ret);

      return tree;
    }
  }
  return tree;
}

_addLine(needParent, List<CategoryDataNew> cat, String firstId){
  List<CategoryDataNew> treeLine = [];
  for (var item in cat){
   /* if (item.parent == '-1')
      item.parent = '0';
    if (item.parent == needParent) {*/
      // if (item.id == firstId)
      //   treeLine.insert(0, item);
      // else
        treeLine.add(item);
    /*}*/

  }
  if (treeLine.isNotEmpty)
    return treeLine;
  else
    return null;
}

List<List<CategoriesData>> treeViewCategory = [];

horizontalCategoriesCircleRestaurantV2(List<Widget> listTopLevel, List<CategoryDataNew> cat, List<DishesData> prod, double windowWidth,
    Function(String id, String hero, String image) _onCategoriesClick, String _currentCategoryId) {

  treeViewCategory = [];
  treeViewCategory = _findPoint(cat, _currentCategoryId, treeViewCategory);

  var currentLevel = 1;
  for (var item in treeViewCategory) {
    _getLineLevel(listTopLevel, item, prod, windowWidth, _onCategoriesClick, (currentLevel != treeViewCategory.length) ? 0.7 : 1.0,
        treeViewCategory.length, _currentCategoryId);
    currentLevel++;
  }
}

_buttonAll(double windowWidth, double squareScale, double height, Function(String id, String hero, String image) _onCategoriesClick){
  return Stack(
    children: <Widget>[
      Container(
          alignment: Alignment.center,
          child: Container(
              width: (windowWidth * appSettings.categoryCardWidth / 100)*squareScale,
              height: height*squareScale,
              margin: EdgeInsets.only(bottom: height*0.15),
              child: Image.asset("assets/all.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          )
      ),
      Positioned.fill(
        child: Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.grey[400],
              onTap: (){
                _onCategoriesClick("", "", "");
              }, // needed
            )),
      )
    ],
  );
}

_getLineLevel(List<Widget> listTopLevel,
   List<CategoriesData> cat, List<DishesData> prod, double windowWidth, Function(String id, String hero, String image) _onCategoriesClick,
     double squareScale, int levels, _currentCategoryId){

  if (cat == null || cat.isEmpty)
    return;

  List<Widget> list = [];
  list.add(SizedBox(width: 10,));
  var height = windowWidth * appSettings.categoryCardHeight / 100;

  if (cat[0].parent == '0') // && levels != 1)
     list.add(_buttonAll(windowWidth, squareScale, height, _onCategoriesClick));

  for (var item in cat) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;

    Widget child = ICard30FileCaching(
      shadow: appSettings.shadow,
      radius: appSettings.radius,
      color: theme.colorBackground,
      colorProgressBar: theme.colorPrimary,
      text: item.name,
      width: (windowWidth * appSettings.categoryCardWidth / 100)*squareScale,
      height: height*squareScale,
      image: item.image,
      id: item.id,
      textStyle: (squareScale == 0) ? theme.text18boldPrimaryUI : TextStyle(color: theme.colorDefaultText,
        fontWeight: FontWeight.w800,
        fontSize: 18*squareScale,
      ),
      callback: _onCategoriesClick,
    );
    if (appSettings.categoryCardCircle != "true")
      child = ICard12FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        width: (windowWidth * appSettings.categoryCardWidth / 100)*squareScale,
        height: height*squareScale,
        image: item.image,
        id: item.id,
        textStyle: (squareScale == 0) ? theme.text18boldPrimaryUI : TextStyle(color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 18*squareScale,
        ),
        callback: _onCategoriesClick,
      );

    var select = child;
    if (item.id == _currentCategoryId)
      select = Container(
        padding: EdgeInsets.all(5),
        color: theme.colorPrimary.withAlpha(150),
        child: child,
      );
      list.add(select);
      list.add(SizedBox(width: 10,));

  }
  if (list.length == 1)
    return;
   listTopLevel.add(AnimatedContainer(
     duration: Duration (milliseconds: 500),
       curve: Curves.easeInCubic,
        color: appSettings.categoriesBackgroundColor,
        padding: EdgeInsets.only(top: 10),
        height: (height+30)*squareScale,
        width: windowWidth,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: list,
        )),
      );
}
