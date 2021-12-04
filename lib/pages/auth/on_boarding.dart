import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ball_on_a_budget_planner/widgets/onboardin_pages.dart';
//me

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  

  @override
  Widget build(BuildContext context) {

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      
      body: Column(
        children: [
          Container(
            height: _height * .8,
            child: Carousel(
              dotVerticalPadding: _height * 0.00,
              dotColor: Colors.grey,
              dotIncreasedColor: Theme.of(context).accentColor,
              autoplay: false,
              dotBgColor: Colors.transparent,
              dotSize: 6,
              dotSpacing: 15,
              images: [
                OnBordingPages(context: context, msg: 'onboard_message_1'.tr(), title: 'onboard_title_1'.tr(), urlImg: 'assets/images/intro2.png', ), 
                OnBordingPages(context: context, msg: 'onboard_message_2'.tr(), title: 'onboard_title_2'.tr(), urlImg: 'assets/images/intro2.2.png', ), 
                OnBordingPages(context: context, msg: 'onboard_message_3'.tr(), title: 'onboard_title_3'.tr(), urlImg: 'assets/images/onb3.png', ),
              ],
            ),
          ),
          SizedBox( height: _height * 0.03),
          Container(
            height: 55,
            width: _width * 0.80,
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
                ),
            child: TextButton(
              style:  ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  )
                )
              ),
              child: Text(
                  'skip'.tr(),
                style: customStyle(Colors.white, 16, FontWeight.w600) 
              ),
              onPressed: () => Navigator.pushReplacementNamed(context, 'home'),
            ),
          ),
        ],
      ),
    );
  }

}

