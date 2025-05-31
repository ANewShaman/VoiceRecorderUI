import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/app_colors.dart';
import 'screens/home_screen/cubit/record/record_cubit.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/recordings_list/view/recordings_list_screen.dart';

import 'screens/recordings_list/cubit/files/files_cubit.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.mainColor,
      statusBarColor: Colors.transparent,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecordCubit>(
          create: (context) => RecordCubit(),
        ),

        BlocProvider<FilesCubit>(
          create: (context) => FilesCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'VOICE RECORDER',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          RecordingsListScreen.routeName: (context) => RecordingsListScreen(),
        },
      ),
    );
  }
}
