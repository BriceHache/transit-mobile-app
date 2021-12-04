

import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/models/category.dart';

class CategoryList extends StatefulWidget {
  CategoryList({Key key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  Stream<QuerySnapshot> query;
  Category categoryInsert = new Category();
  String timestamp;
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
    return Scaffold(
      
     
      body: StreamBuilder(
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

          }else if(data.data.docs.length == 0){
            insertCategory();
            return Center(
            child:SpinKitFadingCircle(
              size: 50,
              color: Theme.of(context).accentColor,
            ),
            ); 
          }else{
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
 
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio:  MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 5.5),),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                
                var categories = categoryList[index];
                return GestureDetector(
                  onTap: () {
                   Navigator.pushNamed(context, 'editCate', arguments: categoryList[index]);
                  },
                  child: Container(
                    //color: ThemeProvider().getColor(Themes.cardBGColor),
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 7, bottom: 7),
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            color: Color(
                              int.parse(categories.color),
                            ),
                          ),
                          height: 50,
                          width: 50,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage('${categories.icon}'),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              categories.categoryName.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: customStyle(Colors.white, 16, FontWeight.w600)
                            ),
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                );
              },
              itemCount: categoryList.length,
            ),
            SizedBox(height: 100.0),
          ],
        ),
      );
    
  }

  Future _insertPredefineCategories() async {
   

    DateTime now = DateTime.now();
    String _date = DateFormat('dd MMMM yy').format(now);
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    
      categoryInsert.date = _date;
      timestamp = _timestamp;
      categoryInsert.timestamp = _timestamp;
     
     List<String> iconsList = [
    "icons/ic_clothes.png",
    "icons/ic_food.png",
    "icons/ic_cerveza.png",
    "icons/ic_supper.png",
    "icons/ic_taxi.png",
    "icons/ic_learn.png",
    "icons/ic_health.png",
    "icons/ic_phone.png",
    "icons/ic_travel.png",
    "icons/ic_car.png",
    "icons/ic_home.png",
    "icons/ic_fuelstation.png",
    "icons/ic_gift.png",
    "icons/ic_gym.png",
  ];


  List<String> categoryList =[
    'cat1'.tr(),
    'cat2'.tr(),
    'cat3'.tr(),
    'cat4'.tr(),
    'cat5'.tr(),
    'cat6'.tr(),
    'cat7'.tr(),
    'cat8'.tr(),
    'cat9'.tr(),
    'cat10'.tr(),
    'cat11'.tr(),
    'cat12'.tr(),
    'cat13'.tr(),
    'cat14'.tr(),
   
  ];


  List<Color> colorsList = [
    
    Color(0xff147CCE),
    Color(0xffFFB826),
    Color(0xffAA5E2C),
    Color(0xff44D7B6),
    Color(0xff32C5FF),
    Color(0xff10598A),
    Color(0xff959799),
    Color(0xff7C1A1A),
    Color(0xff10598A),
    Color(0xff823099),
    Color(0xffE02020),
    Color(0xffFFA200),
    Color(0xff5D5C5C),
    Color(0xff5D5C5C),
  ];

    for (var i = 0; i < categoryList.length; i++) {
      
      DateTime now = DateTime.now();
    String _date = DateFormat('dd MMMM yy').format(now);
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    
      categoryInsert.date = _date;
      timestamp = _timestamp;
      categoryInsert.timestamp = _timestamp;
       await FirebaseFirestore.instance.collection('users').doc(userid).collection('categories').doc(timestamp).set({
        'timestamp'     : timestamp,
        'category name' : categoryList[i],
        'color'         : colorsList[i].value.toString(),
        'icon'          : iconsList[i],
        'date'          : categoryInsert.date
    });
     await Future.delayed(Duration(seconds: 1));
     
    }
    
  }

  Widget insertCategory(){
    _insertPredefineCategories();
    return  Center(
      child:SpinKitFadingCircle(
        size: 50,
        color: Theme.of(context).accentColor,
      ),
    );  
  }

}
