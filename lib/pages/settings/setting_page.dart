
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:easy_localization/easy_localization.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String appVersion = '0.0';
  String packageName = '';
  final TextStyle style = TextStyle(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 0.338,
              
              fontWeight: FontWeight.w500,
              );

  void initPackageInfo () async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      packageName = packageInfo.packageName;
    });
  }

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: Padding(padding: EdgeInsets.only(left: 20, right: 15, ),
      child: ListView(children: [
        SizedBox(height: 10,),
            ListTile(
              onTap: (){},
              leading: Icon(FontAwesomeIcons.solidThumbsUp, color:  Theme.of(context).accentColor,),
              title: Text('rate_us'.tr(), style: style),
              
            ),
          
          
           
           SizedBox(height: 10,),
           
             Divider(
             color: Colors.grey,
             height: 5.0,
             thickness: 1.5,
           ),
           ListTile(
              onTap: () => {},
              leading: Icon(FontAwesomeIcons.codeBranch, color:   Theme.of(context).accentColor,),
              title: Text('app_version'.tr(), style: style),
              subtitle: Text(appVersion, style: customStyle(Colors.white, 18, FontWeight.w500)),
              
            ),
             

      ],),
      ),
    );
  }
}