import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squatter/blocs/cubit/counter_cubit.dart';
import 'package:squatter/blocs/cubit/pose_analyzer_cubit.dart';

class BlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider<CounterCubit>(
        create: (BuildContext context) => CounterCubit()),
    BlocProvider<PoseAnalyzerCubit>(
      create: (BuildContext context) => PoseAnalyzerCubit(),
      lazy: false,
    ),
  ];
}
