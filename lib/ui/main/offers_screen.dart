import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/response/notifications_data_response.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/notify.dart';
import 'package:fooddelivery/model/server/notifyDelete.dart';
import 'package:fooddelivery/ui/login/needAuth.dart';
import 'package:fooddelivery/utils/CommonMethods.dart';
import 'package:fooddelivery/utils/dialogue_utils.dart';
import 'package:fooddelivery/utils/network_utils.dart';
import 'package:fooddelivery/widget/ICard29FileCaching.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/widgets.dart';
import 'package:intl/intl.dart';

class OffersScreen extends StatefulWidget {
  final Function(String) onBack;
  final String doc;

  OffersScreen({Key key, this.doc, this.onBack}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  _dismissItem(String id) {
    print("Dismiss item: $id");

    notifyDelete(account.token, id, () {
      /* Notifications _delete;
      for (var item in _this)
        if (item.id == id)
          _delete = item;

      if (_delete != null) {
        _this.remove(_delete);
        setState(() {
        });
      }*/
    }, _error);
  }

  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  bool _wait = true;
  List<NotificationsNew> offersList = [];

  @override
  void initState() {
    account.notifyCount = 0;
    /*account.redraw();
    if (account.isAuth())
      getNotify(account.token, _success, _error);
    else
      _waits(false);
    account.addCallback(this.hashCode.toString(), callback);
    account.addNotifyCallback(callbackReload);*/
    super.initState();
    _waits(false);
    //_loadNotificationsData();
    super.initState();
  }

  /* callbackReload(){
    if (account.isAuth())
      getNotify(account.token, _success, _error);
  }*/

  _loadNotificationsData() {
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");

        var body = {
          /*'uid': '${PreferenceHelper.getString(AppConstants.PREF_USER_ID)}'*/
          'uid': '305'
        };

        CommonMethods.getApiRepository().getNotificationsData(body).then(
          (response) {
            Fimber.d("Notification list data fetched Success");
            _waits(false);
            //_popDialog();
            //DialoguesUtils.hideProgressbar(context);
            if (response != null) {
              print("Response : $response");
              //userFavoritesList = response.favouriteData;
              setState(() {
                offersList = response.data;
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

  _error(String error) {
    _waits(false);
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _waits(bool value) {
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  /* _success(List<Notifications> _data) {
    _waits(false);
    _this = _data;
    setState(() {
    });
  }*/

  /* callback(bool reg){
    setState(() {
    });
  }*/

  @override
  void dispose() {
    //account.addNotifyCallback(null);
    route.disposeLast();
    //account.removeCallback(this.hashCode.toString());
    //account.redraw();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.colorBackground,
        body: Directionality(
            textDirection: strings.direction,
            child: Stack(
              children: <Widget>[
                headerWidget(
                    context, widget.onBack, theme.colorDefaultText, widget.doc),


                Container(

                  child: Center(
                    child: Text("Offers not found",),
                  ),
                )

              ],
            )));
  }

  _body() {
    var size = 0;
    if (offersList == null || offersList.isEmpty) return Container();
    for (var _ in offersList) size++;
    if (size == 0)
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          UnconstrainedBox(
              child: Container(
                  height: windowHeight / 3,
                  width: windowWidth / 2,
                  child: Container(
                    child: Image.asset(
                      "assets/nonotify.png",
                      fit: BoxFit.contain,
                    ),
                  ))),
          SizedBox(
            height: 20,
          ),
          Text(strings.get(44), // "Not Have Notifications",
              overflow: TextOverflow.clip,
              style: theme.text16bold),
          SizedBox(
            height: 50,
          ),
        ],
      ));
    return ListView(
      children: _body2(),
    );
  }

  _body2() {
    List<Widget> list = [];

    list.add(Container(
      color: theme.colorBackgroundDialog,
      child: ListTile(
        leading: UnconstrainedBox(
            child: Container(
                height: 35,
                width: 35,
                child: Image.asset(
                  "assets/notifyicon.png",
                  fit: BoxFit.contain,
                ))),
        title: Text(
          strings.get(45),
          style: theme.text20bold,
        ),
        // "Notifications",
        subtitle: Text(
          strings.get(46),
          style: theme.text14,
        ), // "Swipe left the notification to delete it",
      ),
    ));

    list.add(SizedBox(
      height: 20,
    ));

    for (var _data in offersList) {
      list.add(ICard29FileCaching(
        key: UniqueKey(),
        id: _data.id,
        color: theme.colorGrey.withOpacity(0.1),
        title: _data.title,
        titleStyle: theme.text14bold,
        userAvatar: _data.image.isNotEmpty ? "$serverImages${_data.image}" : "",
        colorProgressBar: theme.colorPrimary,
        text: _data.message,
        textStyle: theme.text14,
        balloonColor: theme.colorPrimary,
        date: DateFormat('dd-MMM-yyyy kk:mm').format(_data.createdDate),
        dateStyle: theme.text12grey,
        callback: _dismissItem,
        imageHeight: windowHeight * 0.25,
      ));
    }
    return list;
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(
          _text,
          style: theme.text14,
        ),
        SizedBox(
          height: 40,
        ),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }),
      ],
    );

    setState(() {
      _show = 1;
    });
  }
}
