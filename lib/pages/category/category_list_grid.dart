

import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class CategoryListGrid extends StatefulWidget {
  CategorySelectionListener _clickListener;

  CategoryListGrid(CategorySelectionListener clickListener) {
    this._clickListener = clickListener;
  }

  @override
  _CategoryListGridState createState() => _CategoryListGridState();
}

class _CategoryListGridState extends State<CategoryListGrid> {
  

  Stream<QuerySnapshot> query;
  Category categoryInsert = new Category();
  String userid;
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    
    super.initState();
    setUserid();
  }

  void setUserid()async{
     userid = await storage.read(key: 'userId');
   print(userid);
   setState(() {
     
   });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream:  query = FirebaseFirestore.instance
                            .collection('users')
                            .doc(userid)
                            .collection('categories')
                            .orderBy('date')
                            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
          if (data.connectionState == ConnectionState.active) {
                              if (data.data.docs.length > 0 ){
                               List<Category> categories = data.data.docs.map((data) => Category.fromMap(data.data())).toList();
                                return _showCategories(categories);

                              }else {
                                return  Center(
                              child:SpinKitFadingCircle(
                                size: 50,
                                color: Theme.of(context).accentColor,
                              ),
                              );  
                              }
                              }
                              return Center(
                              child:SpinKitFadingCircle(
                                size: 50,
                                color: Theme.of(context).accentColor,
                              ),
                              );  
                            },
                          ),
    );
  }

  Widget _showCategories(List<Category> categoryList) {
    return Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        //color: ThemeProvider().getColor(Themes.backgroundColor),
        child: GridView.count(
          crossAxisCount: 4,
          children: List.generate(
            categoryList.length,
            (index) {
              var categories = categoryList[index];
              return GestureDetector(
                onTap: () {
                  widget._clickListener.onCategorySelected(categories);
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: 25,
                      child: Image(
                        image: AssetImage(categories.icon),
                        color: Color(int.parse(categories.color)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        categories.categoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: customStyle(Colors.white, 12, FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  
}

abstract class CategorySelectionListener {
  void onCategorySelected(Category category);
}
