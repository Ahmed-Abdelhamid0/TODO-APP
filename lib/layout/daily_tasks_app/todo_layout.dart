import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled1/archived_tasks/archived_tasks.dart';
import 'package:untitled1/done_tasks/done_tasks.dart';
import 'package:untitled1/shared/cubit/cubit.dart';
import 'package:untitled1/shared/cubit/states.dart';
import '../../new_tasks/new_tasks.dart';
import '../../shared/components/constants.dart';

class todoLayout extends StatelessWidget
{
  var scaffold=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();

  bool isClicable=false;
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => AppCupit()..creatDatabase(),
      child: BlocConsumer<AppCupit,AppStates>(
        listener: (context,state)
        {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context,state){
          AppCupit cubit=AppCupit.get(context);
          return Scaffold(
            key: scaffold,
            appBar: AppBar(
              title:Text(
               cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context)=>cubit.screen[cubit.currentIndex],
              fallback:(context) =>Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()
              {
                if(cubit.isBottomSheetShown)
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                }else
                {
                  scaffold.currentState!.showBottomSheet(
                        (context) =>SingleChildScrollView(
                          child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,

                                validator: (value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'title must me not empty';

                                  }else
                                  {
                                    return null;

                                  }
                                },

                                decoration: InputDecoration(
                                  labelText:'Task Title',
                                  border: OutlineInputBorder(),
                                  prefixIcon:Icon(
                                    Icons.title,
                                    color: Colors.purple[800],

                                  ),

                                ),
                              ),
                              SizedBox(height: 20.0,),
                              TextFormField(
                                controller: timeController,
                                keyboardType: TextInputType.datetime,


                                onTap:(){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),

                                  ).then((value) {

                                    timeController.text=value!.format(context).toString();
                                    print(value!.format(context));
                                  });
                                },

                                validator: (value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'time must me not empty';

                                  }else
                                  {
                                    return null;

                                  }
                                },

                                decoration: InputDecoration(
                                  labelText:'Task Time',
                                  border: OutlineInputBorder(),
                                  prefixIcon:Icon(
                                    Icons.watch_later_outlined,
                                    color: Colors.purple[800],

                                  ),

                                ),
                              ),
                              SizedBox(height: 20.0,),
                              TextFormField(
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                onTap:(){
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1999),
                                    lastDate: DateTime(2100),
                                  ).then((value) {
                                    print(DateFormat.yMMMd().format(value!));
                                    dateController.text=DateFormat.yMMMd().format(value!);
                                  });
                                } ,
                                validator: (value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'date must  not be empty';

                                  }else
                                  {
                                    return null;

                                  }
                                },

                                decoration: InputDecoration(
                                  labelText:'Date',
                                  border: OutlineInputBorder(),
                                  prefixIcon:Icon(
                                    Icons.calendar_today,
                                    color: Colors.purple[800],

                                  ),

                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                        ),
                    elevation: 20.0,
                  ).closed.then((value) {
                      cubit.changeBottomSheetState
                      (isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState
                    (isShow: true, icon: Icons.add);

                }


              },
              child: Icon(
                cubit.fabIcon,
              ),
              backgroundColor: Colors.purple[800],

            ),
            bottomNavigationBar: BottomNavigationBar(
              type:BottomNavigationBarType.fixed ,
              currentIndex:cubit.currentIndex,
              onTap: (index)
              {
                 cubit.changeIndex(index);
              },
              items: [

                BottomNavigationBarItem(


                  icon:Icon(
                    Icons.menu,
                    color: Colors.purple[800],
                  ) ,
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon:Icon(
                    Icons.check_circle_outline,
                    color: Colors.purple[800],
                  ) ,
                  label: 'Done',

                ),
                BottomNavigationBarItem(
                  icon:Icon(
                    Icons.archive_outlined,
                    color: Colors.purple[800],
                  ) ,
                  label: 'Archived',


                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


