// @dart=2.9
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/layout/daily_tasks_app/todo_layout.dart';
// import 'package:untitled1/layout/news_app/news_layout.dart';
// import 'package:untitled1/modules/bmi%20result/BMI_Result_Screen.dart';
// import 'package:untitled1/modules/bmi/BMI_Screen.dart';
// import 'package:untitled1/modules/messenger/Messenger_Screen.dart';
// import 'package:untitled1/modules/counter/counter_screen.dart';
// import 'package:untitled1/modules/home/home_screem.dart';
// import 'package:untitled1/modules/login/login_file.dart';
import 'package:untitled1/shared/bloc_observer.dart';
import 'package:untitled1/shared/network/remote/dio_helper.dart';
// import 'modules/users/users_screen.dart';

void main()
{

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       // theme: ThemeData(
       //   primarySwatch: Colors.deepOrange ,
       //     scaffoldBackgroundColor:Colors.white,
       //   appBarTheme: AppBarTheme(
       //     backwardsCompatibility: false,
       //     systemOverlayStyle: SystemUiOverlayStyle(
       //       statusBarColor: Colors.white,
       //       statusBarBrightness: Brightness.dark,
       //     ),
       //     backgroundColor: Colors.white,
       //     elevation: 0.0,
       //     titleTextStyle: TextStyle(
       //       color:Colors.black,
       //       fontSize: 20.0,
       //       fontWeight: FontWeight.bold,
       //     ),
       //     iconTheme: IconThemeData(
       //       color: Colors.black,
       //       size: 25.0,
       //     ),
       //   ),
       //   floatingActionButtonTheme: FloatingActionButtonThemeData(
       //     backgroundColor: Colors.deepOrange,
       //   ),
       //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
       //     type: BottomNavigationBarType.fixed,
       //     selectedItemColor:Colors.deepOrange,
       //     elevation: 30.0,
       //
       //   ),
       // ),
       theme: ThemeData(
         scaffoldBackgroundColor:Colors.white,
           appBarTheme: AppBarTheme(
           backwardsCompatibility: false,
           systemOverlayStyle: SystemUiOverlayStyle(
             statusBarColor: Colors.purple[800],

           ),
           backgroundColor: Colors.purple[800],
           elevation: 0.0,
           titleTextStyle: TextStyle(
             color:Colors.white,
             fontSize: 20.0,
             fontWeight: FontWeight.bold,
           ),
           iconTheme: IconThemeData(
             color: Colors.white,
             size: 25.0,
           ),
         ),
         floatingActionButtonTheme: FloatingActionButtonThemeData(
           backgroundColor: Colors.purple[800],
         ),
         bottomNavigationBarTheme: BottomNavigationBarThemeData(
           type: BottomNavigationBarType.fixed,
           selectedItemColor:Colors.purple[800],
           elevation: 30.0,

         ),
       ),
       home: todoLayout(),
     );
  }

}

