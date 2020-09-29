import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    this.emit(state + 1);
  }

  void reset() {
    this.emit(0);
  }
}
