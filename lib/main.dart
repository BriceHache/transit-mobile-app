import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
//me
import 'package:ball_on_a_budget_planner/bloc/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:ball_on_a_budget_planner/routes/routes.dart';
import 'authentication_repository/authentication_repository.dart';
import 'authentication_repository/user_data_repository.dart';
import 'bloc/profile_bloc/profile_bloc_bloc.dart';
import 'route_observer.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
  EasyLocalization(
    supportedLocales: [
      Locale('fr', 'FR'),
      Locale('en', 'US'),
     // Locale('es', 'MX'),
      
    ],
    fallbackLocale: Locale('fr', 'FR'),
   // fallbackLocale: Locale('en', 'US'),
    path:'assets/translations' ,
    child: MyApp(),
  )
);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(0, 149, 100, 2.0),
        
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInBloc>(create: ( context ) => new SignInBloc(
          authenticationRepository: authenticationRepository, 
          userDataRepository:userDataRepository)),
         BlocProvider<ProfileBloc>(
          create: ( context ) =>  new ProfileBloc(userDataRepository) 
        ),
      ],
      child: MaterialApp(
        
          theme: ThemeData(
          appBarTheme: AppBarTheme(brightness: Brightness.dark),
          primaryColor: Color.fromRGBO(9, 27, 46, 1),
          accentColor: Color.fromRGBO(0, 149, 100, 2.0),
          scaffoldBackgroundColor: Color.fromRGBO(9, 27, 46, 1),
        ),
        
        localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              EasyLocalization.of(context).delegate,
        ],
        
        supportedLocales: EasyLocalization.of(context).supportedLocales,
        locale: EasyLocalization.of(context).locale,
        debugShowCheckedModeBanner: false,
        title: 'CTI',
        initialRoute: 'splash',
        //initialRoute: 'email',
        /*navigatorObservers: <NavigatorObserver>[
          MyRouteObserver(),
        ],*/
        routes: appRoutes,

      ),
    );
  }
}