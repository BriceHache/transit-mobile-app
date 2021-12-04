import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tuple/tuple.dart';

import '../banklin_icons.dart';

int daysInMonth( int month){
  var now = new DateTime.now();

  var lastDayDateTime = (month < 12) ?
    new DateTime(now.year, month + 1, 0) : new DateTime(now.year + 1, 1,0);
  return lastDayDateTime.day;
}
List<Color> colorsList = [
   Color.fromRGBO(8, 185, 198, 1),
    Color(0xff32C5FF),
    Color(0xffFFB826),
    Color(0xffAA5E2C),
    Color(0xff147CCE),
    Color(0xff959799),
    Color(0xff44D7B6),
    Color(0xff7C1A1A),
    Color(0xff10598A),
    Color(0xff823099),
    Color(0xffE02020),
    Color(0xffF48C34),
    Color(0xff000000),
    Color(0xff5D5C5C),
    Color(0xffBE4792),
    Color(0xffFFA200),
    Color(0xff0041FF),
    Color(0xffCB0000),
    Color(0xff07A82D),
    
    Color.fromRGBO(197, 181, 125, 1),
    Color.fromRGBO(102, 101, 107, 1),
    Color.fromRGBO(19, 58, 147, 1),
    Color.fromRGBO(202, 5, 25, 1),
    Color.fromRGBO(25, 25, 25, 1),
    Color.fromRGBO(83, 43, 111, 1),
    Color.fromRGBO(222, 81, 22, 1),
    Color.fromRGBO(148, 116, 62, 1),
    Color.fromRGBO(39, 90, 148, 1),
    Color.fromRGBO(20, 139, 90, 1),
    Colors.amber[700],
    Color.fromRGBO(158, 0, 118, 1),
    Color.fromRGBO(255, 131, 52, 1),
    Color.fromRGBO(35, 204, 239, 1),
    Color.fromRGBO(53, 70, 92, 1),
    Color.fromRGBO(58, 105, 62, 1),
    Color.fromRGBO(35, 204, 239, 1),
  
  ];

  bool isNumeric( String s) {

  if( s.isEmpty) return false;

  final n = num.tryParse(s);

  return ( n == null );
}

List<String> iconsList = [
    "icons/ic_food.png",
    "icons/ic_avion.png",
    "icons/ic_online.png",
    "icons/ic_atm.png",
    "icons/ic_shopping.png",
    "icons/ic_shopping2.png",
    "icons/ic_sun_short.png",
    "icons/ic_sun_glass.png",
     "icons/ic_event.png",
    "icons/ic_interest.png",
    "icons/ic_groceries.png",
    "icons/ic_special_gift.png",
    "icons/ic_shopping_bag.png",
    "icons/ic_mobile.png",
    "icons/ic_bus.png",
    "icons/ic_fast_food.png",
    "icons/ic_travel_agency.png",
    "icons/ic_casino.png",
    "icons/ic_check.png",
    "icons/ic_room.png",
    "icons/ic_university.png",
    "icons/ic_wallet_money.png",
    "icons/ic_hotel.png",
    "icons/ic_hotel_beach.png",
    "icons/ic_route.png",
    "icons/ic_jersey.png",
    "icons/ic_clothes.png",
    "icons/ic_dress.png",
    "icons/ic_taco.png",
    "icons/ic_avatar.png",
    "icons/ic_car.png",
    "icons/ic_credit_card.png",
    "icons/ic_drink.png",
    "icons/ic_fuelstation.png",
    "icons/ic_gift.png",
    "icons/ic_grooming.png",
    "icons/ic_gym.png",
    "icons/ic_home.png",
    "icons/ic_miscellaneous.png",
    "icons/ic_money.png",
    "icons/ic_stationary.png",
    "icons/ic_tshirt.png",
    "icons/ic_wallet.png",
    "icons/ic_table.png",
    "icons/ic_castillo.png",
    "icons/ic_producto.png",
    "icons/ic_tequila.png",
    "icons/ic_bebida.png",
    "icons/ic_cerveza.png",
    "icons/ic_tazas.png",
    "icons/ic_dish.png",
    "icons/ic_candy.png",
    "icons/ic_pinata.png",
    "icons/ic_princess.png",
    "icons/ic_soud.png",
    "icons/ic_taxi.png",
    "icons/ic_travel.png",
    "icons/ic_phone.png",
    "icons/ic_iPhone.png",
    "icons/ic_health.png",
    "icons/ic_doctor.png",
    "icons/ic_supper.png",
    "icons/ic_learn.png",
    "icons/ic_cake.png",
    "icons/ic_sushi.png",
    "icons/ic_jacket.png",
    "icons/ic_pets.png",
    "icons/ic_constructions.png",
    "icons/ic_pizza.png",
    "icons/ic_cheeses.png",
    "icons/ic_supermarkert.png",
    "icons/ic_seafood.png",
    "icons/ic_meat.png",
    "icons/ic_construction.png",
    "icons/ic_suspension.png",
    "icons/ic_license.png",
    "icons/ic_papers.png",
    "icons/ic_swim_suit.png",
    "icons/ic_event.png",
    

    
    
    
  ];

  

String labelMonth(String month){
 
    String monthLabel;
    switch (month) {
    case '120':
      {
        monthLabel = 'jan'.tr() ;
      }
    break;
    case '220':
      {
        monthLabel = 'feb'.tr() ;
      }
    break;
    case '320':
      {
        monthLabel = 'mar'.tr() ;
      }
    break;
    case '420':
      {
        monthLabel = 'apr'.tr() ;
      }
    break;
    case '520':
      {
        monthLabel = 'may'.tr() ;
      }
    break;
    case '620':
      {
        monthLabel = 'jun'.tr() ;
      }
    break;
    case '720':
      {
        monthLabel = 'jul'.tr() ;
      }
    break;
    case '820':
      {
        monthLabel = 'aug'.tr() ;
      }
    break;
    case '920':
      {
        monthLabel = 'sep'.tr() ;
      }
    break;
    case '102':
      {
        monthLabel = 'oct'.tr() ;
      }
    break;
    case '112':
      {
        monthLabel = 'nov'.tr() ;
      }
    break;
    case '122':
      {
        monthLabel = 'dec'.tr() ;
      }
    break;
   
    
  }
  return monthLabel;
}

String labelToInt(String month){

    String onlyMonth = month.substring(0,3);
    String year = month.substring(month.length -4, month.length);
    String monthLabel;
    switch (onlyMonth) {
    case  'Jan':
      {
        monthLabel = '1$year';
      }
    break;
     case  'Ene':
      {
        monthLabel = '1$year';
      }
    break;
    case  'Feb':
      {
        monthLabel = '2$year';
      }
    break;
    case  'Mar':
      {
        monthLabel = '3$year';
      }
    break;
    case  'Apr':
      {
        monthLabel = '4$year';
      }
    break;
    case  'Abr':
      {
        monthLabel = '4$year';
      }
    break;
    case  'May':
      {
        monthLabel = '5$year';
      }
    break;
    case  'Jun':
      {
        monthLabel = '6$year';
      }
    break;
    case  'Jul':
      {
        monthLabel = '7$year';
      }
    break;
    case  'Aug':
      {
        monthLabel = '8$year';
      }
    break;
    case  'Ago':
      {
        monthLabel = '8$year';
      }
    break;
    case  'Sep':
      {
        monthLabel = '9$year';
      }
    break;
    case  'Oct':
      {
        monthLabel = '10$year';
      }
    break;
     case  'Nov':
      {
        monthLabel = '11$year';
      }
    break;
    case  'Dec':
      {
        monthLabel = '12$year';
      }
    break;
     case  'Dic':
      {
        monthLabel = '12$year';
      }
    break;
    
   
    
  }
  return monthLabel;
}

Tuple2<DateTime, DateTime> GetFirstAndLastDateOfMonth(DateTime date)
{
  DateTime firstDate = new DateTime(date.year, date.month, 1);
  DateTime lastDate = new DateTime(date.year, date.month + 1, 1).add(Duration(days: -1));
  DateTime ld = new DateTime(lastDate.year, lastDate.month, lastDate.day, 23, 59, 59);
  return new Tuple2<DateTime, DateTime>(firstDate, ld);
}
