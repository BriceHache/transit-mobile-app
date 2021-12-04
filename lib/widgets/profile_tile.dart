import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final title;
  final subtitle;
  final textColor;
  ProfileTile({this.title, this.subtitle, this.textColor = Colors.black});
  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: customStyle(textColor, 16, FontWeight.w800)
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          subtitle,
          style: customStyle(textColor, 13, FontWeight.w600)
        ),
      ],
    );
  }
}
