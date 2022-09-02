import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cats_fact/models/fact_model.dart';
import 'package:cats_fact/repositories/fact_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/constants.dart';
import '../../../utils/http_response.dart';
import './bloc.dart';

class FactListBloc extends Bloc<FactListEvent, FactListState> {
  final FactRepository factRepository;

  // ignore: empty_constructor_bodies
  FactListBloc(this.factRepository) : super(InitialFactListState()) {
    on<FactListEvent>((event, emit) async {
      emit(LoadingFactListState());
      if (event is GetFactListEvent) {
        List<Fact> facts = [];

        final prefs = await SharedPreferences.getInstance();
        // prefs.remove(APP_NAME);
        if (prefs.containsKey(APP_NAME)) {
          var string = prefs.getString(APP_NAME);
          await jsonDecode(string!).forEach((item) {
            facts.add(Fact.fromJson(item));
          });
        } else {
          final HttpResponse response = await factRepository.fetchFacts();
          //  response.data.forEach((item){

          // });
          if (response.data != null) {
            facts = (response.data ?? []) as List<Fact>;
          }

          facts = facts.where((item) {
            return item.type == 'cat' && item.text!.length > 25;
          }).toList();
          prefs.setString(APP_NAME,
              jsonEncode(facts.map((item) => item.toJson()).toList()));
        }

        emit(LoadedFactListState(facts));
      }
    });
  }

  FactListState get initialState => InitialFactListState();
}
