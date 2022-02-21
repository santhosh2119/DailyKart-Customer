import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppColors.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/response/product_info_model.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/foods.dart';
import 'package:fooddelivery/model/review.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/model/server/search.dart';
import 'package:fooddelivery/model/topRestourants.dart';
import 'package:fooddelivery/ui/main/home/widgets.dart';
import 'package:fooddelivery/ui/main/productsDetails/dishesDetails.dart';
import 'package:fooddelivery/utils/CommonMethods.dart';
import 'package:fooddelivery/utils/dialogue_utils.dart';
import 'package:fooddelivery/utils/network_utils.dart';
import 'package:fooddelivery/widget/ICard20FileCaching.dart';
import 'package:fooddelivery/widget/buttonadd.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/ICard1FileCaching.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/ibanner.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/ipromotion.dart';
import 'package:fooddelivery/widget/isearch.dart';
import 'package:fooddelivery/widget/ilist1.dart';
import 'package:fooddelivery/widget/widgets.dart';
import 'package:fooddelivery/widget/wproducts.dart';
import 'package:fooddelivery/widget/wsearch.dart';
import 'package:url_launcher/url_launcher.dart';
import '../mainscreen.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) callback;
  final Function(String) onErrorDialogOpen;
  final Function() redraw;
  final scaffoldKey;
  HomeScreen(
      {this.redraw, this.onErrorDialogOpen, this.callback, this.scaffoldKey});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool _filterWindow = false;

String idDishes;
String idRestaurant;
String idRestaurantOnMap;
String imageRestaurant;
String currentCategoryId;
String imageCategory;
String idHeroes;
String idOrder;

String firstCategory;
String firstCategoryImage;

HomeScreenModel homeScreenViewModel = HomeScreenModel();

class _HomeScreenState extends State<HomeScreen> {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _onBannerClick(String id, String heroId, String image) {
    dprint("Banner click: $id");
    /* for (var item in homeScreen.secondStepData.banner1){
      if (item.id == id){
        if (item.type == "1") { // open food
          idHeroes = heroId;
          idDishes = item.details;
          route.setDuration(1);
          route.push(context, "/dishesdetails");
        }
        if (item.type == "2") { // open link
          _openUrl(item.details);
        }
        break;
      }
    }
    for (var item in homeScreen.secondStepData.banner2){
      if (item.id == id){
        if (item.type == "1") { // open food
          idHeroes = heroId;
          idDishes = item.details;
          route.setDuration(1);
          route.push(context, "/dishesdetails");
        }
        if (item.type == "2") { // open link
          _openUrl(item.details);
        }
        break;
      }
    }*/
  }

  _openUrl(uri) async {
    if (await canLaunch(uri)) await launch(uri);
  }

  _onPressSearch(String value) {
    dprint("Search word: $value");
    _search = value;
    getSearch(value, _successSearch, (String _) {});
    setState(() {});
  }

  _onRestaurantClick(String id, String heroId, String image) {
    dprint("User pressed Restaurant Near Your with id: $id");
    idHeroes = heroId;
    imageRestaurant = image;
    idRestaurant = id;
    route.setDuration(1);
    route.push(context, "/restaurantdetails");
  }

  _onTopRestaurantNavigateIconClick(String id) {
    dprint("User pressed Top Restaurant Route icon with id: $id");
    idRestaurantOnMap = id;
    //route.mainScreen.route("map");
    mainScreenState.routes("map");
  }

  _onCategoriesClick(String id, String heroId, String image) {
    print("adjlajdlajdla");
    dprint("User pressed Category item with id: $id");
    idHeroes = heroId;
    currentCategoryId = id;
    imageCategory = image;
    route.setDuration(1);
    route.push(context, "/categorydetails");
  }

  _mangeFavouriteClick(ProductInfoModel productInfoModel) {
    print(
        "productId : ${productInfoModel.id} isAddedToFavourite : ${productInfoModel.isWishlist}");
    if (productInfoModel.isWishlist) {
      //removeFromFavouriteItem(productInfoModel.id);
    } else {}
  }

  _onProductClickNew(ProductInfoModel product, String heroId) {
    dprint("User pressed Most Popular item with id: ${product.id}");
    idHeroes = product.id;
    idDishes = product.id;
    route.setDuration(1);
    //route.push(context, "/dishesdetails");

    route.pushMaterialRoute(
        context,
        DishesDetailsScreen.routeName,
        MaterialPageRoute(
          builder: (context) => DishesDetailsScreen(productInfo: product),
        ));
  }

  _onProductClick(String id, String heroId) {
    dprint("User pressed Most Popular item with id: $id");
    idHeroes = heroId;
    idDishes = id;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  String _search = "";
  bool _wait = false;
  var windowWidth;
  var windowHeight;
  TextEditingController _searchController = TextEditingController();

  _waits(bool value) {
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  _dataLoad() async {
    _homeScreenLoad = false;
    _waits(false);
    _loadHomeScreenData();
    await homeScreenViewModel.distance();
    if (mounted) setState(() {});
    widget.redraw();
  }

  _loadHomeScreenData() {
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");

        var body = {
          'userid': '${PreferenceHelper.getString(AppConstants.PREF_USER_ID)}'
        };

        /*  LoginRequest loginRequest = new LoginRequest(  mobile: mobileNo,
        );*/
        //  var requestBody = jsonEncode(loginRequest);
        // Fimber.d("Request Data : $requestBody");
        // var dataa = FormData.fromMap(loginRequest);
        CommonMethods.getApiRepository().getHomeScreenDetails(body).then(
          (response) {
            Fimber.d("Home screen data fetched Success");
            _waits(false);
            //_popDialog();
            //DialoguesUtils.hideProgressbar(context);
            if (response != null) {
              homeScreenViewModel.bindBannerInfo(response.banners);
              homeScreenViewModel.bindCategoryInfo(response.categories);
              homeScreenViewModel.bindNewArrivalProducts(response.newArrivals);
              homeScreenViewModel
                  .bindRecentlyViewedProducts(response.recentlyViewed);
            }
          },
          onError: (exception) {
            _waits(false);

            //CommonMethods.manageError(context, exception);
          },
        );

        //DialoguesUtils.showProgressbar(context: context);
        _waits(true);
      } else {
        // No-Internet Case
        Fimber.d("isNetwork Not Available");
        DialoguesUtils.noInternet(context);
      }
    });
  }

  _error(String err) {
    _waits(false);
    widget.onErrorDialogOpen(
        "${strings.get(128)} $err"); // "Something went wrong. ",
  }

  @override
  void initState() {
    super.initState();
    account.addCallback(this.hashCode.toString(), callback);
    _wait = true;
    homeScreenViewModel.load(_dataLoad, _error);
  }

  bool _homeScreenLoad = true;

  callback(bool reg) {
    setState(() {});
  }

  @override
  void dispose() {
    account.removeCallback(this.hashCode.toString());
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: [
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 45),
                child: ListView(
                    padding: EdgeInsets.only(top: 0),
                    shrinkWrap: true,
                    children: _children())),
            if (_addToBasketItem != null)
              Container(
                margin: EdgeInsets.only(bottom: 60),
                child: buttonAddToCart(_addToBasketItem, () {
                  setState(() {});
                }, () {
                  _addToBasketItem = null;
                  setState(() {});
                }, widget.scaffoldKey),
              ),
            IEasyDialog2(
              setPosition: (double value) {
                _show = value;
              },
              getPosition: () {
                return _show;
              },
              color: theme.colorGrey,
              body: _dialogBody,
              backgroundColor: theme.colorBackground,
            ),
            if (_wait)
              Container(
                color: Color(0x80000000),
                width: windowWidth,
                height: windowHeight,
                child: Center(
                  child: ColorLoader2(
                    color1: theme.colorPrimary,
                    color2: theme.colorCompanion,
                    color3: theme.colorPrimary,
                  ),
                ),
              ),
          ],
        ));
  }

  _children() {
    List<Widget> list = [];
    if (_homeScreenLoad) return list;

    String lastRow = "";
    for (var row in appSettings.rows) {
      lastRow = row;
      if (row == "search") {
        list.add(Container(
          color: appSettings.searchBackgroundColor,
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Row(
            children: [
              Expanded(
                  child: ISearch(
                radius: appSettings.radius,
                shadow: appSettings.shadow,
                direction: strings.direction,
                hint: strings.get(34), // "Search",
                icon: Icons.search,
                iconRight: Icons.close,
                onPressRightIcon: () {
                  _search = "";
                  _searchController.text = "";
                  setState(() {});
                },
                onChangeText: _onPressSearch,
                colorDefaultText: theme.colorDefaultText,
                colorBackground: theme.colorBackgroundDialog,
                controller: _searchController,
              )),
              SizedBox(
                width: 10,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: UnconstrainedBox(
                        child: Container(
                            height: 30,
                            width: 30,
                            child: Image.asset(
                              "assets/filter.png",
                              fit: BoxFit.contain,
                              color: theme.colorDefaultText,
                            ))),
                  ),
                  Positioned.fill(
                    child: Material(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.grey[400],
                          onTap: () {
                            _filterWindow = !_filterWindow;
                            setState(() {});
                          }, // needed
                        )),
                  )
                ],
              ),
            ],
          ),
        ));
        if (_filterWindow)
          list.add(Container(
              child: Column(
            children: [
              if (theme.multiple)
                restaurantsComboBox(windowWidth, () {
                  widget.redraw();
                }),
              cateroriesComboBox(windowWidth, () {
                widget.redraw();
              }),
              SizedBox(
                height: 5,
              ),
              Text(strings.get(276),
                  style: theme
                      .text14bold), // "This filter will work throughout the application.",
              SizedBox(
                height: 10,
              ),
              Container(height: 0.5, color: Colors.black.withAlpha(120))
            ],
          )));
      }
      if (_search.isNotEmpty) continue;

      //This section display banners UI
      if (row == "banner1") {
        if (homeScreenViewModel.bannerInfo != null &&
            homeScreenViewModel.bannerInfo.isNotEmpty) {
          list.add(Container(
              child: IBanner(
            homeScreenViewModel.bannerInfo,
            width: windowWidth * 0.95,
            height: windowWidth * appSettings.banner1CardHeight / 100,
            colorActivy: theme.colorPrimary,
            colorProgressBar: theme.colorPrimary,
            radius: appSettings.radius,
            shadow: appSettings.shadow,
            style: theme.text16boldWhite,
            callback: _onBannerClick,
            seconds: 4,
          )));
        }
      }

      //To enable second banne will add data here,as per android ui we dont need this ui
      /*if (row == "banner2"){
        if (homeScreen.secondStepData != null && homeScreen.secondStepData.banner2 != null && homeScreen.secondStepData.banner2.isNotEmpty) {
          list.add(Container(
              child: IBanner(homeScreen.secondStepData.banner2,
                width: windowWidth * 0.95,
                height: windowWidth * appSettings.banner1CardHeight / 100,
                colorActivy: theme.colorPrimary,
                colorProgressBar: theme.colorPrimary,
                radius: appSettings.radius,
                shadow: appSettings.shadow,
                style: theme.text16boldWhite,
                callback: _onBannerClick,
                seconds: 4,
              ))
          );
        }
      }*/
      if (row == "nearyou" && theme.multiple) {
        // restaurants near your
        list.add(nearYourTextAndIconFilter(openFilterNearYourDistance));
        list.add(_horizontalTopRestaurants(distanceForNearYourFilter));
      }
      //To add  1 more category on top of banners than disable condition
      if (row == "cat") {
        list.add(Container(
          color: AppColors.categoriesTitleColor,
          padding: EdgeInsets.all(10),
          child: IList1(
              imageAsset: "assets/categories.png",
              text: strings.get(268),
              // "Food categories",
              textStyle: theme.text16bold,
              imageColor: appSettings.getIconColorByMode(theme.darkMode)),
        ));
        /*if (appSettings.categoryCardCircle == "true")*/
        list.add(horizontalCategoriesCircle(windowWidth, _onCategoriesClick));
        /*else
          list.add(horizontalCategories(windowWidth, _onCategoriesClick));*/
      }
      if (row == "pop") {
        list.add(Container(
          color: appSettings.dishesTitleColor,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: IList1(
              imageAsset: "assets/popular.png",
              text: strings.get(42), // "Most Popular",
              textStyle: theme.text16bold,
              imageColor: appSettings.getIconColorByMode(theme.darkMode)),
        ));

        /* if (appSettings.typeFoods == "type2")
          dishList2(list, mostPopular, context, _onProductClick, windowWidth, "", _onAddToCartClick);
        else {
          if (appSettings.oneInLine == "false")*/
        //dishList(list, mostPopular, context, _onProductClick, windowWidth, _onAddToCartClick, "");
        productList(
            list,
            homeScreenViewModel.recentlyViewedList,
            context,
            _onProductClickNew,
            windowWidth,
            _onAddToCartClick,
            refreshData,
            "");

        /*else
            dishListOneInLine(list, mostPopular, _onProductClick, windowWidth, _onAddToCartClick, "");
        }*/
      }

      if (row == "topf") {
        list.add(Container(
          color: appSettings.dishesTitleColor,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: IList1(
              imageAsset: "assets/hot.png",
              text: strings.get(199), // "Top Trends this week",
              textStyle: theme.text16bold,
              imageColor: appSettings.getIconColorByMode(theme.darkMode)),
        ));
        /*if (appSettings.typeFoods == "type2")
          dishList2(list, topFoods, context, _onProductClick, windowWidth, "", _onAddToCartClick);
        else {
          if (appSettings.oneInLine == "false")*/
        //dishList(list, topFoods, context, _onProductClick, windowWidth, _onAddToCartClick, "");
        productList(
            list,
            homeScreenViewModel.newArrivalList,
            context,
            _onProductClickNew,
            windowWidth,
            _onAddToCartClick,
            refreshData,
            "");
        /*else
            dishListOneInLine(list, topFoods, _onProductClick, windowWidth, _onAddToCartClick, "");*/
        /*}*/
      }

      if (row == "topr" && theme.multiple) {
        if (topRestaurants.isNotEmpty) {
          list.add(Container(
            color: appSettings.restaurantTitleColor,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: IList1(
                imageAsset: "assets/hot.png",
                text: strings.get(200), // "Top Restaurants this week",
                textStyle: theme.text16bold,
                imageColor: appSettings.getIconColorByMode(theme.darkMode)),
          ));
          list.add(Container(
              color: appSettings.restaurantTitleColor,
              child: IPromotion(
                topRestaurants,
                height: windowWidth * appSettings.topRestaurantCardHeight / 100,
                width: windowWidth * 0.95,
                colorActivy: theme.colorPrimary,
                colorProgressBar: theme.colorPrimary,
                radius: appSettings.radius,
                shadow: appSettings.shadow,
                style: theme.text16boldWhite,
                callback: _onRestaurantClick,
                seconds: 4,
              )));
        }
      }
      if (row == "copyright") {
        list.add(copyrightBlock(widget.callback));
      }
      if (row == "categoryDetails") {
        //TODO:: Display category and items horizantally bottom of the screen
        //categoryDetails(list, windowWidth, _onProductClick, _onAddToCartClick);
      }
      if (row == "review") {
        if (reviews.isNotEmpty) {
          list.add(Container(
            color: appSettings.reviewTitleColor,
            padding: EdgeInsets.all(10),
            child: IList1(
                imageAsset: "assets/reviews.png",
                text: strings.get(43), // "Recent Reviews",
                textStyle: theme.text16bold,
                imageColor: appSettings.getIconColorByMode(theme.darkMode)),
          ));
          _reviews(list);
        }
      }
    }
    if (_search.isNotEmpty) {
      if (appSettings.typeFoods == "type2")
        dishList2(list, searchData, context, _onProductClick, windowWidth, "",
            _onAddToCartClick);
      else {
        if (appSettings.oneInLine == "false")
          dishList(list, searchData, context, _onProductClick, windowWidth,
              _onAddToCartClick, "");
        else
          dishListOneInLine(list, searchData, _onProductClick, windowWidth,
              _onAddToCartClick, "");
      }
      list.add(Container(
        color: appSettings.dishesBackgroundColor,
        height: 200,
      ));
      return list;
    }

    Color lastColor = theme.colorBackground;
    if (lastRow.isNotEmpty) {
      if (lastRow == "search") lastColor = appSettings.searchBackgroundColor;
      if (lastRow == "nearyou")
        lastColor = appSettings.restaurantBackgroundColor;
      if (lastRow == "cat") lastColor = appSettings.categoriesBackgroundColor;
      if (lastRow == "pop") lastColor = appSettings.dishesBackgroundColor;
      if (lastRow == "review") lastColor = appSettings.reviewBackgroundColor;
    }

    list.add(Container(
      color: lastColor,
      height: 100,
    ));

    return list;
  }

  DishesData _addToBasketItem;

  refreshData(bool status, String message) {
    /*if(status){*/
    //_loadFavouriteData();
    /*}*/
  }
  _onAddToCartClick(String id) {
    dprint("add to cart click id=$id");
    _addToBasketItem = loadFood(id);
    _addToBasketItem.count = 1;
    setState(() {});
  }

  _reviews(List<Widget> list) {
    for (var item in reviews)
      if (item.name != 'null') {
        list.add(Container(
          color: appSettings.reviewBackgroundColor,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ICard1FileCaching(
            radius: appSettings.radius,
            color: theme.colorPrimary,
            title: item.name,
            text: item.text,
            date: item.date,
            titleStyle: theme.text18bold,
            textStyle: theme.text16,
            dateStyle: theme.text14grey,
            userAvatar: item.image,
            rating: item.star,
          ),
        ));
      }
  }

  _horizontalTopRestaurants(int distanceForNearYourFilter) {
    List<Widget> list = [];
    var height = windowWidth * appSettings.restaurantCardHeight / 100;
    for (var item in nearYourRestaurants) {
      var _dist = "";
      if (item.distance != -1) {
        if (appSettings.distanceUnit == "km") {
          if (item.distance <= 1000)
            _dist = "${item.distance.toStringAsFixed(0)} m";
          else
            _dist = "${(item.distance / 1000).toStringAsFixed(0)} km";
          dprint(
              "Distance filter: distanceForNearYourFilter=$distanceForNearYourFilter current=${item.distance}=>${item.distance / 1000} name=${item.name}");
          if (distanceForNearYourFilter != 0 &&
              item.distance / 1000 > distanceForNearYourFilter) continue;
        } else {
          // miles
          if (item.distance < 1609.34)
            _dist = "${(item.distance / 1609.34).toStringAsFixed(3)} miles";
          else
            _dist = "${(item.distance / 1609.34).toStringAsFixed(0)} miles";
          if (distanceForNearYourFilter != 0 &&
              item.distance / 1609.34 > distanceForNearYourFilter) continue;
        }
      }
      list.add(ICard20FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        direction: strings.direction,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        text2: item.address,
        text3: _dist,
        width: windowWidth * appSettings.restaurantCardWidth / 100,
        height: height,
        image: item.image,
        colorRoute: theme.colorPrimary,
        id: item.id,
        title: theme.text18boldPrimaryUI,
        body: theme.text16UI,
        callback: _onRestaurantClick,
        callbackNavigateIcon: _onTopRestaurantNavigateIconClick,
      ));
    }
    return Container(
      color: appSettings.restaurantBackgroundColor,
      height: height + 10,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _successSearch(List<DishesData> _data, String currency) {
    searchData.clear();
    searchData = _data;
    setState(() {});
  }

  double _show = 0;
  Widget _dialogBody = Container();
  int distanceForNearYourFilter = 0;

  openFilterNearYourDistance() {
    int _selectitem = 0;
    _dialogBody = Column(
      children: [
        Text(
          strings.get(309),
          style: theme.text14,
        ), // Select maximum distance:
        // SizedBox(height: 10,),
        Container(
            height: 200,
            child: CupertinoPicker(
              magnification: 1.5,
              backgroundColor: theme.colorBackground,
              children: <Widget>[
                Text(
                  strings.get(133),
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ), // All
                Text(
                  "5 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "10 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "15 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "20 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "25 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ), // 5
                Text(
                  "50 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "100 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "150 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
                Text(
                  "200 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ), // 9
                Text(
                  "300 ${appSettings.distanceUnit}",
                  style: TextStyle(color: theme.colorDefaultText, fontSize: 18),
                ),
              ],
              itemExtent: 40, //height of each item
              looping: false,
              onSelectedItemChanged: (int index) {
                _selectitem = index;
              },
            )),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
                child: IButton3(
                    color: theme.colorPrimary,
                    text: strings.get(155), // Cancel
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                    })),
            Flexible(
                child: IButton3(
                    color: theme.colorPrimary,
                    text: strings.get(127), // OK
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      switch (_selectitem) {
                        case 0:
                          distanceForNearYourFilter = 0;
                          break;
                        case 1:
                          distanceForNearYourFilter = 5;
                          break;
                        case 2:
                          distanceForNearYourFilter = 10;
                          break;
                        case 3:
                          distanceForNearYourFilter = 15;
                          break;
                        case 4:
                          distanceForNearYourFilter = 20;
                          break;
                        case 5:
                          distanceForNearYourFilter = 25;
                          break;
                        case 6:
                          distanceForNearYourFilter = 50;
                          break;
                        case 7:
                          distanceForNearYourFilter = 100;
                          break;
                        case 8:
                          distanceForNearYourFilter = 150;
                          break;
                        case 9:
                          distanceForNearYourFilter = 200;
                          break;
                        case 10:
                          distanceForNearYourFilter = 300;
                          break;
                      }
                      setState(() {
                        _show = 0;
                      });
                    })),
          ],
        ),
        SizedBox(
          height: 60,
        )
      ],
    );
    setState(() {
      _show = 1;
    });
  }
}
