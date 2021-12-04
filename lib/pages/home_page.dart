import 'package:ball_on_a_budget_planner/dossiers/dossiers_list.dart';
import 'package:ball_on_a_budget_planner/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
//me
import 'package:ball_on_a_budget_planner/pages/budgets/add_budget_page.dart';
import 'package:ball_on_a_budget_planner/pages/budgets/add_budget_temp.dart';
import 'package:ball_on_a_budget_planner/pages/budgets/budgtes_page.dart';
import 'package:ball_on_a_budget_planner/pages/category/add_category.dart';
import 'package:ball_on_a_budget_planner/pages/category/category_list.dart';
import 'package:ball_on_a_budget_planner/pages/cc_expenses/add_expense.dart';
import 'package:ball_on_a_budget_planner/pages/cc_expenses/expenses_page.dart';
import 'package:ball_on_a_budget_planner/pages/dashboard.dart';
import 'package:ball_on_a_budget_planner/pages/incomes/add_incomes.dart';
import 'package:ball_on_a_budget_planner/pages/incomes/incomes_page.dart';
import 'package:ball_on_a_budget_planner/pages/settings/setting_page.dart';
import 'package:ball_on_a_budget_planner/pages/settings/language_settings.dart';
import 'package:ball_on_a_budget_planner/pages/profile_page.dart';
import 'package:ball_on_a_budget_planner/banklin_icons.dart';
import 'package:ball_on_a_budget_planner/bloc/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/helpers/next_screen.dart';
import 'package:ball_on_a_budget_planner/widgets/logo.dart';
import 'package:tuple/tuple.dart';

class HomePage extends StatefulWidget {

  final DateTime From_date;
  final DateTime To_date;
  final int _selectedPage;
  final  String _title;

 // const HomePage({Key key}) : super(key: key);

  HomePage({Key key, DateTime from ,DateTime to, int selectedPage = 0, String title = "Accueil" }):
        this.From_date = from,
        this.To_date = to,
        this._selectedPage = selectedPage,
        this._title = title,
        super(key: key)
  ;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController(initialPage: 0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedPage;
  String _title, _currentBudget;
  bool isSigningOut;
  SignInBloc signinBloc;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));
  

  @override
  void initState() {
    signinBloc = BlocProvider.of<SignInBloc>(context);

    //_selectedPage = 0;
    _selectedPage = widget._selectedPage;

    //_title = 'Accueil';

    _title = widget._title;

    _currentBudget = 'Budget Planner';


    DateTime nowDate = DateTime.now();
    Tuple2<DateTime, DateTime> currentMontDates = GetFirstAndLastDateOfMonth(nowDate);

    if(widget.From_date !=null){
      _startDate = widget.From_date;
    }else{
      _startDate = currentMontDates.item1;
    }

    if(widget.To_date !=null){

      _endDate = widget.To_date;

    }else{

      _endDate = currentMontDates.item2;

    }


    super.initState();


  }

  @override
  Widget build(BuildContext context) {
   
   return Scaffold(
     
     key: _scaffoldKey,
     drawer: drawerMenu(),
     
          floatingActionButton: SpeedDial(
            overlayColor: Theme.of(context).primaryColor,
            animatedIcon: AnimatedIcons.add_event,
            backgroundColor: Theme.of(context).accentColor,
            activeBackgroundColor: Theme.of(context).accentColor,
           
            marginBottom: 50,
            children: [
              SpeedDialChild(
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(BanklinIcons.plus),
                //label: 'add_expense'.tr(), labelBackgroundColor: Colors.white,
                label: 'add_reglement'.tr(), labelBackgroundColor: Colors.white,
                onTap: (){
                  
                  nextScreen(context, AddExpensePage());
                  
                  } 
              ),
              SpeedDialChild(
                 backgroundColor: Theme.of(context).accentColor,
                child: Icon(BanklinIcons.wallet),
                //label: 'add_incomes'.tr(), labelBackgroundColor: Colors.white,
                label: 'add_dossier'.tr(), labelBackgroundColor: Colors.white,
                onTap: () {
                  
                  nextScreen(context, AddIncomePage());
              } ),
              SpeedDialChild(
                 backgroundColor: Theme.of(context).accentColor,
                child: Icon(BanklinIcons.plus),
               // label: 'categories'.tr(), labelBackgroundColor: Colors.white,
                label: 'add_dossier_depense'.tr(), labelBackgroundColor: Colors.white,
                onTap: () {
                   
                  nextScreen(context, AddCategory());
                  } 
              ),
              /*SpeedDialChild(
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(FontAwesomeIcons.moneyCheck),
                label: 'add_budget_temp'.tr(), labelBackgroundColor: Colors.white,
                onTap: () {
                   
                  nextScreen(context, AddTempBudgetPage());
                } 
              ),
              SpeedDialChild(
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(FontAwesomeIcons.moneyCheckAlt),
                label: 'add_budget_month'.tr(), labelBackgroundColor: Colors.white,
                onTap: () {
                 
                  nextScreen(context, AddBudgetPage());
                  } 
              ),*/
              
            ],
          ),
    body: Column(

      children: [
        customAppBar(),
        
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              DashboardPage(),
              DossiersPage(_startDate, _endDate),
              // ExpensesPage(),
              IncomesPage(),
              CategoryList(),
              // BudgetsPage(),
              ProfilePage(),
              SettingsPage(),
              LanguageSettingsPage()
            ],
          ),
        ),
      ],
    )
    );
  }

   Widget customAppBar(){
    Size size = MediaQuery.of(context).size;
    return 
    Container(
      width: double.infinity,
      height: size.height * .10,
      margin: const EdgeInsets.only(
          bottom: 5.0 ),
       decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 35.0, ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
               ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.5),
                    onTap: () {
                     
                      _scaffoldKey.currentState.openDrawer();
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      width: 38.0,
                      height: 38.0,
                      child: Icon(
                        Icons.dehaze,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: customStyle(Colors.white, 20.0, FontWeight.w700,)
                ),
              ),
              _selectedPage == 10
              ? ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.5),
                    onTap: () {
                      //sign out
                      showSignoutConfimationDialog(size);
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      width: 40.0,
                      height: 40.0,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                        size: 28.0,
                      ),
                    ),
                  ),
                ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.5),
                    onTap: () {
                      //sign out
                      print('salir');
                    },
                    child: Container(
                      
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40,),
            ],
          ),
        
      ),
    );
  }

  showSignoutConfimationDialog(Size size) {
    return showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Êtes vous sûr?',
              style: customStyleLetterSpace(Colors.black87, 14.5, FontWeight.w600, 0.3)
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Voulez vous vous déconnecter?',
              style: customStyleLetterSpace(Colors.black87, 14, FontWeight.w600, 0.3),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 50.0,
                  child: TextButton(
                    
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: customStyleLetterSpace(Colors.black87, 13.5, FontWeight.w600, 0.3)
                    ),
                  ),
                ),
                Container(
                  width: 50.0,
                  child: TextButton(
                    
                    onPressed: () {
                      Navigator.pop(context);
                      signinBloc.add(SignoutEvent());
                      isSigningOut = true;
                    },
                    child: Text(
                      'Yes',
                      style: customStyleLetterSpace(Colors.red.shade700, 13.5, FontWeight.w600, 0.3)
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), barrierDismissible: false,
      context: context,
    );
  }

  Widget drawerMenu(){
    return  AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,   
      child: Theme(
        data: Theme.of(context).copyWith(
                 canvasColor:Theme.of(context).accentColor, //This will change the drawer background to blue.
                 //other styles
              ),
        child: Drawer(
          
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              children: [
                Container(height: 25,),
        
                Logo(title: 'CTI'),
                SizedBox(height: 10,),
                /* Container(
                  padding: EdgeInsets.all(20),
                  child: LargeButton( title: 'Create a budget', onTap: ()=> Navigator.pushReplacement(context, navegateFadein(context, NewBudgetPage()))),
                ), */
                builLlistTile(
                  () {
                    setState(() {
                      _selectedPage = 0;
                      Navigator.pop(context);
                      _pageController.jumpToPage(0);
                      _title = 'Dashboard'.tr();
                    });
                  },
                  Icons.dashboard,
                  30.0,
                  _selectedPage == 0
                  ? Theme.of(context).primaryColor
                  : Colors.white,
                    'Dashboard'.tr(),
                  0

                ),
                builLlistTile(
                  () {
                    setState(() {
                      _selectedPage = 1;
                      Navigator.pop(context);
                      _pageController.jumpToPage(1);
                    //  _title = 'expense'.tr();
                      _title = 'dossiers'.tr();
                    });
                  },
                  FontAwesomeIcons.folder,
                  30.0,
                  _selectedPage == 1
                  ? Theme.of(context).primaryColor
                  : Colors.white,
                  //'expense'.tr(),
                     'dossiers'.tr(),
                  1

                ),
                builLlistTile(
                  () {
                    setState(() {
                      _selectedPage = 2;
                      Navigator.pop(context);
                      _pageController.jumpToPage(2);
                      //_title = 'incomes'.tr();
                      _title = 'reglements'.tr();
                    });
                  },
                  BanklinIcons.business,
                  30.0,
                  _selectedPage == 2
                  ? Theme.of(context).primaryColor
                  : Colors.white,
                 // 'incomes'.tr(),
                    'reglements'.tr(),
                  2

                ),
                builLlistTile(
                  () {
                    setState(() {
                      _selectedPage = 3;
                      Navigator.pop(context);
                      _pageController.jumpToPage(3);
                     // _title = 'categories_list'.tr();
                      _title = 'clients'.tr();
                    });
                  },
                  FontAwesomeIcons.gripVertical,
                  30.0,
                  _selectedPage == 3
                  ? Theme.of(context).primaryColor
                  : Colors.white,
                  //'categories_list'.tr(),
                  'clients'.tr(),
                  3

                ),
               /* builLlistTile(
                  () {
                    setState(() {
                      _selectedPage = 4;
                      Navigator.pop(context);
                      _pageController.jumpToPage(4);
                      _title = 'budgets'.tr();
                    });
                  },
                  BanklinIcons.wallet,
                  30.0,
                  _selectedPage == 4
                  ? Theme.of(context).primaryColor
                  : Colors.white,
                  'budgets'.tr(),
                  4

                ),*/
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(
                    'tools'.tr(),
                      style: GoogleFonts.roboto(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                  ),
                  )
                ),
                builLlistTile(
                  () {
                    setState(() {
                      _selectedPage = 10;
                      Navigator.pop(context);
                      _pageController.jumpToPage(5);
                      _title = 'my_profile'.tr();
                    });
                  },
                  BanklinIcons.settings,
                  30.0,
                  _selectedPage == 10
                  ? Theme.of(context).primaryColor
                  : Colors.white,
                  'my_profile'.tr(),
                  10

                ),
                builLlistTile(
                  () {
                    setState(() {
                      _selectedPage = 6;
                      Navigator.pop(context);
                      _pageController.jumpToPage(6);
                      _title = 'settings'.tr();
                    });
                  },
                  FontAwesomeIcons.cog,
                  30.0,
                  _selectedPage == 6
                  ? Theme.of(context).primaryColor
                  : Colors.white,
                  'settings'.tr(),
                  6

                ),

                builLlistTile(
                  () {
                    setState(() {
                      _selectedPage = 7;
                      Navigator.pop(context);
                      _pageController.jumpToPage(7);
                      _title = 'lang_settin'.tr();
                    });
                  },
                  Icons.translate,
                  30.0,
                  _selectedPage == 7
                  ? Theme.of(context).primaryColor
                  : Colors.white,
                  'languages'.tr(),
                  7

                ),

              ],
            ),
          
        ),
      ),
    );
  }

  Widget builLlistTile(Function onTap, IconData icon, double iconSize, Color colorIcon, String title,  int selectedPage) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: iconSize,
        color: colorIcon
      ),
      title: Text(
        title,
        style: customStyle(
          _selectedPage == selectedPage
              ? Theme.of(context).primaryColor
              : Colors.white, 
          16.0, 
          FontWeight.w600,
          
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color:  _selectedPage == selectedPage
              ? Theme.of(context).primaryColor
              : Colors.white,),
    );
  }

}