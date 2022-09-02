import 'package:cats_fact/providers/random_image_provider.dart';

class RandomImageRepository {
  final randomImageRepositry = RandomImageProvider();

  Future getRandomImage() => randomImageRepositry.getRandomImage();
}
