import 'package:cats_fact/models/fact_model.dart';
import 'package:dio/dio.dart';

import '../config/api.dart';
import '../utils/http_response.dart';

class FactProvider {
  static const String providerName = 'facts';

  static BaseOptions options = new BaseOptions(
    baseUrl: FACTS_URL,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  Dio dio = new Dio(options);

  Future<HttpResponse> fetchFacts() async {
    try {
      Response response = await dio.get(providerName);

      List result = response.data['all'] as List;
      List<Fact> facts = result.isNotEmpty
          ? result.map((item) => Fact.fromJson(item)).toList()
          : [];

      return HttpResponse(isSuccess: true, data: facts);
    } catch (error) {
      return HttpResponse(message: error.toString());
    }
  }
}
