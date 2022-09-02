import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/fact/fact_bloc.dart';
import '../blocs/fact_list/fact_list_bloc.dart';
import '../blocs/fact_list/fact_list_event.dart';
import '../blocs/random-image/random_image_bloc.dart';
import '../blocs/random-image/random_image_event.dart';
import '../repositories/fact_repository.dart';
import '../repositories/random_image_repository.dart';
import 'home_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<FactListBloc>(
            create: (context) =>
                FactListBloc(FactRepository())..add(GetFactListEvent())),
        BlocProvider<FactBloc>(
            create: (context) =>
                FactBloc(factListBloc: BlocProvider.of<FactListBloc>(context))),
        BlocProvider<RandomImageBloc>(
          create: (context) => RandomImageBloc(RandomImageRepository())
            ..add(GetRandomImageEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.amber,
          accentColor: Colors.black87,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
