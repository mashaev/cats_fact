import 'package:cats_fact/providers/fact_provider.dart';

class FactRepository {
  final factRepository = FactProvider();

  Future fetchFacts() => factRepository.fetchFacts();
}
