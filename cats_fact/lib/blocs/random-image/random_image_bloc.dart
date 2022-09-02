import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cats_fact/repositories/random_image_repository.dart';
import '../../utils/http_response.dart';
import './bloc.dart';

class RandomImageBloc extends Bloc<RandomImageEvent, RandomImageState> {
  final RandomImageRepository randomImageRepository;

  // ignore: empty_constructor_bodies
  RandomImageBloc(this.randomImageRepository)
      : super(InitialRandomImageState()) {
    on<RandomImageEvent>((event, emit) async {
      emit(LoadingRandomImageState());
      if (event is GetRandomImageEvent) {
        final HttpResponse response =
            await randomImageRepository.getRandomImage();
        emit(LoadedRandomImageState(response));
      }
    });
  }

  @override
  RandomImageState get initialState => InitialRandomImageState();
}
