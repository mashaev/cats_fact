import 'package:cats_fact/models/fact_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FactListState {}

class InitialFactListState extends FactListState {}

class LoadingFactListState extends FactListState {}

class LoadedFactListState extends FactListState {
  final List<Fact> facts;

  LoadedFactListState(this.facts);
}
