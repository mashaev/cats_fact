import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import '../../models/fact_model.dart';
import '../fact_list/fact_list_bloc.dart';
import '../fact_list/fact_list_state.dart';
import './bloc.dart';

class FactBloc extends Bloc<FactEvent, FactState> {
  final FactListBloc factListBloc;
  late StreamSubscription factListSubscription;
  Random random = Random();
  List<Fact> _facts = [];
  late Fact _fact;

  FactBloc({required this.factListBloc}) : super(InitialFactState()) {
    // factListBloc.state
    factListSubscription = factListBloc.stream.listen((state) {
      if (state is LoadedFactListState) {
        _facts = state.facts;
        add(GetFactEvent());
      }
    });

    on<FactEvent>((event, emit) async {
      emit(LoadingFactState());
      if (event is GetFactEvent) {
        final int maxIndex = _facts.length;
        if (maxIndex != 0) {
          final Fact fact = _facts[random.nextInt(maxIndex)];
          _fact = fact;
          emit(LoadedFactState(fact));
        }
      }
    });
  }

  get fact => _fact;

  @override
  FactState get initialState => InitialFactState();

  @override
  Future<void> close() {
    factListSubscription.cancel();
    return super.close();
  }
}
