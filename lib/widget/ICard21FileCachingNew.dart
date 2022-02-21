import 'package:flutter/material.dart';
import 'package:fooddelivery/data/services/response/product_info_model.dart';
import 'package:fooddelivery/widget/widgets.dart';
import '../main.dart';
import 'cacheImageWidget.dart';

class ICard21FileCachingNew extends StatefulWidget {
  final Color color;
  final double width;
  final Color colorProgressBar;
  final double height;
  final String text;
  final String price;
  final String discountprice;
  final String text3;
  final String image;
  //final String id;
  final ProductInfoModel product;
  final TextStyle textStyle;
  final TextStyle textStyle2;
  final TextStyle textStyle3;
  final bool enableFavorites;
  final Function(String) getFavoriteState;
  final Function(String) revertFavoriteState;
  final Function(ProductInfoModel,Function ) manageFavouriteState;
  final Function(bool,String) refreshData;
  final Function(ProductInfoModel product, String heroId) callback;
  final double radius;
  final int shadow;
  final String discount;
  final Function(String) onAddToCartClick;
  /*final Function(ProductInfoModel) manageFavouriteClick;*/
  final bool needAddToCart;
  final bool showFavourite;

  ICard21FileCachingNew({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.textStyle2, this.price = "", this.getFavoriteState, this.revertFavoriteState,this.manageFavouriteState,this.refreshData,
    this.product = null, this.textStyle, this.callback, this.colorProgressBar = Colors.black, this.enableFavorites = true,
    this.text3 = "", this.textStyle3, this.onAddToCartClick,/*this.manageFavouriteClick,*/
    this.radius, this.shadow, this.discountprice, this.discount, this.needAddToCart = true,this.showFavourite=false
  });

  @override
  _ICard21FileCachingNewState createState() => _ICard21FileCachingNewState();
}

class _ICard21FileCachingNewState extends State<ICard21FileCachingNew>{

  var _textStyle = TextStyle(fontSize: 16);
  var _textStyle2 = TextStyle(fontSize: 16);
  var _textStyle3 = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    if (widget.textStyle2 != null)
      _textStyle2 = widget.textStyle2;
    if (widget.textStyle3 != null)
      _textStyle3 = widget.textStyle3;

    Widget _favorites = Container();
    if (widget.enableFavorites)
      _favorites = Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5, right: 5),
        child: Stack(
          children: <Widget>[

           Visibility(
             visible: widget.showFavourite,
               child:  Container(
               width: 20,
               height: 20,
               alignment: Alignment.center,
               child: Stack(
                 children: [
                   Icon((widget.product.isWishlist) ? Icons.favorite : Icons.favorite_border, color: widget.colorProgressBar, size: 20,),
                 ],
               )
           ))
           ,
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: (){
                      widget.manageFavouriteState(widget.product,widget.refreshData);
                      //widget.revertFavoriteState(widget.product.id);
                    }, // needed
                  )),
            )
          ],
        ),
      );

    Widget _sale = Container();
    if (widget.discountprice != null && widget.discountprice.isNotEmpty) {
      var t = widget.width;
      if (t == MediaQuery.of(context).size.width)
        t /= 2;
      _sale = saleSticker(t, widget.discount, widget.discountprice, widget.price);
    }

    return InkWell(
        onTap: () {
      if (widget.callback != null)
        widget.callback(widget.product, _id);
    }, // needed
    child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          width: widget.width,
          height: widget.height-20,
          decoration: BoxDecoration(
              color: widget.color,
              border: Border.all(color: Colors.black.withAlpha(100)),
              borderRadius: new BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(widget.shadow),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          child: Stack(
            children: [

              Column(
                children: <Widget>[
                  Expanded(child:
                      Stack(
                          children: [
                            Hero(
                                tag: _id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.radius), topRight: Radius.circular(widget.radius)),
                                  child: Container(
                                      width: widget.width,
                                      height: widget.height-20,
                                      child: cacheImageWidgetCover(widget.image, theme.colorPrimary)
                                  ),
                                )
                            ),

                        if (widget.needAddToCart)
                            Container(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                onTap: () {
                                  widget.onAddToCartClick(widget.product.id);
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: theme.colorPrimary.withAlpha(220),
                                    border: Border.all(color: theme.colorPrimary),
                                    borderRadius: new BorderRadius.only(topLeft: Radius.circular(30)),
                                  ),
                                  child: UnconstrainedBox(
                                      child: Container(
                                          margin: EdgeInsets.only(top: 10, left: 10),
                                          height: 30,
                                          width: 30,
                                          child: Image.asset("assets/addtocart.png",
                                            fit: BoxFit.contain, color: Colors.white,
                                          )
                                      )),
                                ))),



                        ],
                      )
                      ),

                  InkWell(
                      onTap: () {
                        if (widget.callback != null)
                          widget.callback(widget.product, _id);
                      },
                      child: Container(
                        width: widget.width,
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,),
                            Row(
                              children: [
                                Expanded(child: Text(widget.text3, style: _textStyle3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),
                                Text(widget.price, style: _textStyle2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
                              ],
                            ),
                            SizedBox(height: 5,)
                          ],
                        ),
                      )),

                ],
              ),

              _favorites,
              _sale,



            ],
          ),
    ));
  }
}