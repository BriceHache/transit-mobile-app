

import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';


class ChartCategoriesList extends StatefulWidget {
  final List<Map> categoriesList;

  const ChartCategoriesList({@required this.categoriesList});

  @override
  _ChartCategoriesListState createState() => _ChartCategoriesListState();
}

class _ChartCategoriesListState extends State<ChartCategoriesList> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Category category = widget.categoriesList[index]['category'];
        String transactions = widget.categoriesList[index]['transaction'];
        String place = widget.categoriesList[index]['place'];
        double expend = double.parse(widget.categoriesList[index]['expend']);
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Container(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Color(
                    int.parse(category.color),
                  ),
                ),
                height: 45,
                width: 45,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Image(
                    image: AssetImage(category.icon),
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        '${category.categoryName} - $place ',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: customStyle(Colors.white, 16, FontWeight.w600)
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        transactions,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: customStyle(Theme.of(context).accentColor, 12, FontWeight.bold)
                      ),
                    )
                  ],
                ),
              ),
              Text(
               "  \$${oCcy.format(expend)}",
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color:  Color(
                    int.parse(category.color),
                  ),
                  fontSize: 14,
                  
                ),
              )
            ],
          ),
        );
      },
      itemCount: widget.categoriesList.length,
    );
  }
}
