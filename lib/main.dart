import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MultiBlocProvider(
      providers: [BlocProvider<CinemaBloc>(create: (context) => CinemaBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Frave - Projects',
        initialRoute: '/',
        routes: routes,
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColorBrightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity),
      ),
    );
  }
}

Map<String, Widget Function(BuildContext)> routes = {
  '/': (_) => AuthenticationPage(),
  'authentication': (_) => AuthenticationPage(),
};

class CinemaBloc extends Bloc<CinemaEvent, CinemaState> {
  CinemaBloc() : super(CinemaState()) {
    on<OnSelectedDateEvent>(_onSelectedDate);
    on<OnSelectedTimeEvent>(_onSelectedTime);
    on<OnSelectedSeatsEvent>(_onSelectedSeats);
    on<OnSelectMovieEvent>(_onSelectedMovie);
  }

  List<String> seats = [];

  Future<void> _onSelectedDate(
      OnSelectedDateEvent event, Emitter<CinemaState> emit) async {
    emit(state.copyWith(date: event.date));
  }

  Future<void> _onSelectedTime(
      OnSelectedTimeEvent event, Emitter<CinemaState> emit) async {
    emit(state.copyWith(time: event.time));
  }

  Future<void> _onSelectedSeats(
      OnSelectedSeatsEvent event, Emitter<CinemaState> emit) async {
    if (seats.contains(event.selectedSeats)) {
      seats.remove(event.selectedSeats);
      emit(state.copyWith(selectedSeats: seats));
    } else {
      seats.add(event.selectedSeats);
      emit(state.copyWith(selectedSeats: seats));
    }
  }

  Future<void> _onSelectedMovie(
      OnSelectMovieEvent event, Emitter<CinemaState> emit) async {
    emit(state.copyWith(nameMovie: event.name, imageMovie: event.image));
  }
}

@immutable
abstract class CinemaEvent {}

class OnSelectMovieEvent extends CinemaEvent {
  final String name;
  final String image;

  OnSelectMovieEvent(this.name, this.image);
}

class OnSelectedDateEvent extends CinemaEvent {
  final String date;

  OnSelectedDateEvent(this.date);
}

class OnSelectedTimeEvent extends CinemaEvent {
  final String time;

  OnSelectedTimeEvent(this.time);
}

class OnSelectedSeatsEvent extends CinemaEvent {
  final String selectedSeats;

  OnSelectedSeatsEvent(this.selectedSeats);
}

@immutable
class CinemaState {
  final String nameMovie;
  final String imageMovie;
  final String date;
  final String time;
  final List<String> selectedSeats;

  CinemaState(
      {this.nameMovie = '',
      this.imageMovie = '',
      this.date = '0',
      this.time = '00',
      List<String>? selectedSeats})
      : this.selectedSeats = selectedSeats ?? [];

  CinemaState copyWith(
          {String? date,
          String? time,
          List<String>? selectedSeats,
          String? nameMovie,
          String? imageMovie}) =>
      CinemaState(
          nameMovie: nameMovie ?? this.nameMovie,
          imageMovie: imageMovie ?? this.imageMovie,
          date: date ?? this.date,
          time: time ?? this.time,
          selectedSeats: selectedSeats ?? this.selectedSeats);
}
