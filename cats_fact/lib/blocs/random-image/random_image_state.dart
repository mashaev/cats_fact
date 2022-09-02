import 'package:meta/meta.dart';

import '../../utils/http_response.dart';

@immutable
abstract class RandomImageState {}

class InitialRandomImageState extends RandomImageState {}

class LoadingRandomImageState extends RandomImageState {}

class LoadedRandomImageState extends RandomImageState {
  final HttpResponse response;

  LoadedRandomImageState(this.response);
}
