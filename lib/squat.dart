import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/cubit/counter_cubit.dart';
import 'camera.dart';

class SquatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CounterCubit, int>(builder: (context, state) {
        return FutureBuilder<List<CameraDescription>>(
            future: availableCameras(),
            builder:
                (context, AsyncSnapshot<List<CameraDescription>> snapshot) {
              if (snapshot.hasData) {
                return Camera(snapshot.data);
              } else {
                return CircularProgressIndicator();
              }
            });
      }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterCubit>(context).reset();
            },
            backgroundColor: Colors.purple,
            tooltip: 'Reset',
            child: Icon(Icons.clear),
          ),
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterCubit>(context).increment();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
