import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yuedu/util/my_navigator.dart';
import 'package:flutter_yuedu/widget/my_app_bar.dart';
import 'package:flutter_yuedu/widget/update_version.dart';
import 'package:permission_handler/permission_handler.dart';

import 'about_page.dart';

typedef itemTapCallback = void Function();

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var notificationIsOpen = false; // 通知是否打开

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).padding.top);

    return Scaffold(
      backgroundColor: Color(0xfffefefe),
      appBar: MyAppBar(),
      body: ListView(
        children: _listItems(),
      ),
    );
  }

  List<Widget> _listItems() {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 24, top: 12),
        child: Text(
          "设置",
          style: TextStyle(fontSize: 23, color: Color(0xff444444)),
        ),
      ),
      _getListItem("缓存管理", "images/setting/icon_setting_cache.png"),
      _getListItem(
          "推送管理",
          "images/setting/icon_setting_push.png",
          CupertinoSwitch(
            activeColor: Colors.amber,
            value: notificationIsOpen,
            onChanged: _pushButtonTap,
          )),
      _getListItem("用户反馈", "images/setting/usercenter_feedback.png"),
      _getListItem("系统更新", "images/setting/setting_version.png", null, () {
        _updateVersionHandle();
      }),
      _getListItem("关于我们", "images/setting/setting_about.png", null, () {
        MyNavigator.push(context, AboutPage());
      }),
    ];
  }

  _pushButtonTap(bool value) {
    setState(() {
      notificationIsOpen = value;
    });
    Future.delayed(const Duration(seconds: 1), () {
      // 打开系统设置
      PermissionHandler().openAppSettings();
    });
  }

  // 更新 app 弹窗
  Future<void> _updateVersionHandle() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final data = UpdateVersion(
            appStoreUrl: 'https://itunes.apple.com/cn/app/id1380512641',
            versionName: 'v1.1.1',
            apkUrl:
                "https://wbd-app.oss-cn-shenzhen.aliyuncs.com/xls/xls-1.5.5_23_20190709_20.20.apk",
            content:
                '1.优化订单显示\n2.解决数据加载异常问题\n3.优化无网络显示效果\n4.解决iPhoneX 兼容性问题\n5.修复定位错误问题');
        return UpdateVersionDialog(data: data);
      },
    );
  }

  Widget _getListItem(String title, String icon,
      [Widget trailing, GestureTapCallback tapCallBack]) {
    return SizedBox(
      height: 80,
      child: ListTile(
        onTap: tapCallBack,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Image.asset(
                icon,
                height: 42,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(title),
              )
            ],
          ),
        ),
        trailing: SizedBox(
          width: 50,
          height: 50,
          child: Align(
            alignment: Alignment.centerRight,
            child: trailing != null
                ? trailing
                : Image.asset("images/usercenter/usercenter_arrow.png"),
          ),
        ),
      ),
    );
  }
}
