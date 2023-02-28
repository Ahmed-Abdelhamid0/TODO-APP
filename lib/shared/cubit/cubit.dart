import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:untitled1/archived_tasks/archived_tasks.dart';
import 'package:untitled1/done_tasks/done_tasks.dart';
import 'package:untitled1/new_tasks/new_tasks.dart';
import 'package:untitled1/shared/cubit/states.dart';

class AppCupit extends Cubit<AppStates>
{

  AppCupit():super(AppInitialState());

  static AppCupit get(context)=>BlocProvider.of(context);

  int currentIndex=0;
  List<String> titles=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Widget> screen=[
    newTasks(),
    doneTasks(),
    archiveTasks(),
  ];

  void changeIndex(int index)
  {
    currentIndex=index;
    emit(AppChangeBottomNavBarState ());

  }

  late Database database;
  List<Map>newtasks=[];
  List<Map>donetasks=[];
  List<Map>archivedtasks=[];

  void creatDatabase()  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate:(database,version)
      {
        print('database created');
        database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)').then((value){
          print('table created');
        }).catchError((error){
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
    });
  }
   insertToDatabase({
    required String title,
    required String time,
    required String date,

  })  async {
     await database.transaction((txn)

    async {
      txn.rawInsert(
          'INSERT INTO tasks(title,time,date,status) VALUES("$title","$time","$date","new")'
      ).then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
        print('database opened');
      }).catchError((error){
        print('error when Inserting New Record ${error.toString()}');
      });

    });
  }

  void getDataFromDatabase(database)
  {
    newtasks=[];
    donetasks=[];
    archivedtasks=[];
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value)
     {

       value.forEach((element)
       {
       if(element['status']=='new'){
         newtasks.add(element);
       }else if(element['status']=='done')
       {
           donetasks.add(element);
       }else
       {
            archivedtasks.add(element);
       }
       });
       emit(AppGetDatabaseState());
     });
  }


  void deleteData({
    required int  id,

}) async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value){
      getDataFromDatabase(database);
      emit( AppUpDeleteDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int  id,

  }) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],

    ).then((value){
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }




  bool isBottomSheetShown=false;
  IconData fabIcon=Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown=isShow;
    fabIcon=icon;
    
    emit(AppChangeBottomSheetState());
  }
}