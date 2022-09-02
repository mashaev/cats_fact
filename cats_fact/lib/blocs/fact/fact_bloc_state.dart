import 'package:cats_fact/models/fact_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FactState {}

class InitialFactState extends FactState {}

class LoadingFactState extends FactState {}

class LoadedFactState extends FactState {
  final Fact fact;

  LoadedFactState(this.fact);
}
