import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/response/product_info_model.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
//import 'package:fooddelivery/model/foods.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/ui/login/needAuth.dart';
import 'package:fooddelivery/ui/main/home/home.dart';
import 'package:fooddelivery/ui/main/productsDetails/dishesDetails.dart';
import 'package:fooddelivery/utils/CommonMethods.dart';
import 'package:fooddelivery/utils/dialogue_utils.dart';
import 'package:fooddelivery/utils/network_utils.dart';
import 'package:fooddelivery/widget/buttonadd.dart';
import 'package:fooddelivery/widget/iinkwell.dart';
import 'package:fooddelivery/widget/ilist2.dart';
import 'package:fooddelivery/widget/wproducts.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(String) callback;
  final scaffoldKey;
  FavoritesScreen({this.callback, this.scaffoldKey});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  List<ProductInfoModel> userFavoritesList = [];
  _onItemClick(String id, String heroId){
    print("User pressed item with id: $id");
    idHeroes = heroId;
    idDishes = id;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  bool _selectList = false;
  bool _wait = false;

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  @override
  void initState() {
    //account.addCallback(this.hashCode.toString(), callback);
    super.initState();
    _waits(false);
    _loadFavouriteData();
    /*if(mounted)
      setState(() {
      });*/
  }
  _loadFavouriteData(){
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");

        var body =
        {
          'user_id': '${PreferenceHelper.getString(AppConstants.PREF_USER_ID)}'
        };

        CommonMethods.getApiRepository().getFavouriteItemData(body).then((response) {
          Fimber.d("Home screen data fetched Success");
          _waits(false);
          //_popDialog();
          //DialoguesUtils.hideProgressbar(context);
          if (response != null) {
            print("Response : $response");
            //userFavoritesList = response.favouriteData;
            setState(() {
              userFavoritesList = response.favouriteData;
            });
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

  callback(bool reg){
      setState(() {
      });
  }

  @override
  void dispose() {
    //account.removeCallback(this.hashCode.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    if (account.isAuth())
      return Directionality(
          textDirection: strings.direction,
          child: Stack(
        children: [

          if (userFavoritesList.isNotEmpty)
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50),
              child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  children: _children()
              )
          ),

          if (userFavoritesList.isEmpty)
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    UnconstrainedBox(
                        child: Container(
                            height: windowHeight/3,
                            width: windowWidth/2,
                            child: Container(
                              child: Image.asset("assets/noorders.png",
                                fit: BoxFit.contain,
                              ),
                            )
                        )),
                    SizedBox(height: 20,),
                    Text(strings.get(179),    // "Not Have Favorites Food",
                        overflow: TextOverflow.clip,
                        style: theme.text16bold
                    ),
                    SizedBox(height: 50,),
                  ],
                )
            ),

          if (_addToBasketItem != null)
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child: buttonAddToCart(_addToBasketItem, (){setState(() {});}, ( ){_addToBasketItem = null; setState(() {});},
                  widget.scaffoldKey),
            ),
        ],
      ));
    else
      return mustAuth(windowWidth, context);
  }

  _children(){
    List<Widget> list = [];

    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: IList2(imageAsset: "assets/favorites.png",
        text: strings.get(38),                      // "Favorites",
        textStyle: theme.text16bold,
        imageColor: theme.colorDefaultText,
        /*child1: IInkWell(child: _listIcon(), onPress: _onListIconClick,),
        child2: IInkWell(child: _tileIcon(), onPress: _onTileIconClick,),*/
      )
    ));

    list.add(SizedBox(height: 10,));

   /* if (!_selectList) {
      if (appSettings.typeFoods == "type2")
        dishList2(list, userFavorites, context, _onItemClick, windowWidth, "", _onAddToCartClick);
      else
        dishList(list, userFavorites, context, _onItemClick, windowWidth, _onAddToCartClick, "");
    }else
      dishListOneInLine(list, userFavorites, _onItemClick, windowWidth, _onAddToCartClick, "");*/

    productList(list, userFavoritesList, context, _onProductClickNew,windowWidth, _onAddToCartClick,refreshData,"");


    list.add(SizedBox(height: 200,));

    return list;
  }
  addToFavoritesState(String id){
    var body =
    {
      'user_id': '${PreferenceHelper.getString(AppConstants.PREF_USER_ID)}',
      'product_id':'${id}'
    };

    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");


        CommonMethods.getApiRepository().getFavouriteItemData(body).then((response) {
          Fimber.d("addToFavoritesState updated Success");
          // _waits(false);
          //_popDialog();
          //DialoguesUtils.hideProgressbar(context);
          if (response != null) {
            print("Response : $response");
            //userFavoritesList = response.favouriteData;
           _loadFavouriteData();
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
  refreshData(bool status,String message){

    /*if(status){*/
      _loadFavouriteData();
    /*}*/
  }
  removeFromFavouriteItem(String id){
    var body =
    {
      'user_id': '${PreferenceHelper.getString(AppConstants.PREF_USER_ID)}',
      'product_id':'${id}'
    };

    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");


        CommonMethods.getApiRepository().removeFromFavouriteItems(body).then((response) {
          Fimber.d("addToFavoritesState updated Success");
          // _waits(false);
          //_popDialog();
          //DialoguesUtils.hideProgressbar(context);
          if (response != null) {
            print("Response : $response");
            //userFavoritesList = response.favouriteData;
            _loadFavouriteData();
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


  _onProductClickNew(ProductInfoModel product, String heroId){
    dprint("User pressed Most Popular item with id: ${product.id}");
    idHeroes = product.id;
    idDishes = product.id;
    route.setDuration(1);
    //route.push(context, "/dishesdetails");


    route.pushMaterialRoute(context, DishesDetailsScreen.routeName  ,MaterialPageRoute(
      builder: (context) => DishesDetailsScreen(productInfo: product),
    ));

  }
  _mangeFavouriteClick(ProductInfoModel productInfoModel){
    print("productId : ${productInfoModel.id} isAddedToFavourite : ${productInfoModel.isWishlist}");
    removeFromFavouriteItem(productInfoModel.id);

  }
  _onAddToCartClick(String id){
    dprint("add to cart click id=$id");
    /*_addToBasketItem = loadFood(id);
    _addToBasketItem.count = 1;
    setState(() {
    });*/
  }

  DishesData _addToBasketItem;

  _listIcon(){
    if (_selectList)
      return UnconstrainedBox(
          child: Container(
              height: 30,
              width: 30,
              child: Image.asset("assets/list.png",
                fit: BoxFit.contain, color: theme.colorPrimary,
              )
          ));
    else
      return UnconstrainedBox(
          child: Container(
              height: 20,
              width: 20,
              child: Image.asset("assets/list.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          ));
  }

  _tileIcon(){
    if (!_selectList)
      return UnconstrainedBox(
          child: Container(
              height: 30,
              width: 30,
              child: Image.asset("assets/tile.png",
                fit: BoxFit.contain, color: theme.colorPrimary,
              )
          ));
    else
      return UnconstrainedBox(
          child: Container(
              height: 20,
              width: 20,
              child: Image.asset("assets/tile.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          ));
  }

  _onListIconClick(){
    if (!_selectList){
      setState(() {
        _selectList = true;
      });
    }
  }
  _onTileIconClick(){
    if (_selectList){
      setState(() {
        _selectList = false;
      });
    }
  }

}