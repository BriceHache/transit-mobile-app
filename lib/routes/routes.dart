import 'package:ball_on_a_budget_planner/dossiers/dossiers_list.dart';
import 'package:ball_on_a_budget_planner/pages/budgets/add_budget_page.dart';
import 'package:ball_on_a_budget_planner/pages/budgets/add_budget_temp.dart';
import 'package:ball_on_a_budget_planner/pages/budgets/budget_options.dart';
import 'package:flutter/material.dart';
//me
import 'package:ball_on_a_budget_planner/pages/auth/login_email_page.dart';
import 'package:ball_on_a_budget_planner/pages/auth/on_boarding.dart';
import 'package:ball_on_a_budget_planner/pages/auth/register_page.dart';
import 'package:ball_on_a_budget_planner/pages/auth/reset_password.dart';
import 'package:ball_on_a_budget_planner/pages/auth/splash_screen.dart';
import 'package:ball_on_a_budget_planner/pages/auth/welcome_page.dart';
import 'package:ball_on_a_budget_planner/pages/home_page.dart';


final Map<String, Widget Function(BuildContext)> appRoutes = {

  
  'email'      : ( _ ) => LoginEmailPage(),
  'welcome'    : ( _ ) => WelcomePage(),
  'register'   : ( _ ) => RegisterPage(),
  'splash'     : ( _ ) => SplashScreenPage(),
  'reset'      : ( _ ) => ResetPassword(),
  'onboard'    : ( _ ) => OnBoardingPage(), 
  'home'       : ( _ ) => HomePage(),
  //'dossiers'     : (BuildContext context) => DossiersPage(),
  'budgetOpt'  : ( _ ) => BudgetOptPage(),
  //'editCate'   : (BuildContext context) => AddCategory(),
  'mBudget'   : (BuildContext context) => AddBudgetPage(),
  'tBudget'   : (BuildContext context) => AddTempBudgetPage(),
            


};