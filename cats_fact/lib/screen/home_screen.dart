import 'package:cats_fact/blocs/fact/fact_bloc_event.dart';
import 'package:cats_fact/blocs/fact/fact_bloc_state.dart';
import 'package:cats_fact/screen/widgets/fact_card.dart';
import 'package:cats_fact/screen/widgets/image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share/share.dart';

import '../blocs/fact/fact_bloc.dart';
import '../blocs/random-image/random_image_bloc.dart';
import '../blocs/random-image/random_image_event.dart';
import '../blocs/random-image/random_image_state.dart';
import '../models/fact_model.dart';
import '../models/random_image_model.dart';
import 'core/button_widget.dart';
import 'core/spinkit_widget.dart';
import 'core/style/box_decoration.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDownloading = false;
  double _valueAnimated = 0;
  bool _visible = true;

  void _handlerShare(String? text) {
    Share.share(text!, subject: 'Did You Know?');
  }

  void _handlerNext() async {
    setState(() {
      _visible = false;
      _valueAnimated = 50;
    });
    await Future.delayed(Duration(milliseconds: 100));
    BlocProvider.of<RandomImageBloc>(context).add(GetRandomImageEvent());
    await Future.delayed(Duration(milliseconds: 500));
    BlocProvider.of<FactBloc>(context).add(GetFactEvent());
    setState(() {
      _valueAnimated = 0;
    });
    await Future.delayed(Duration(milliseconds: 400));
    setState(() {
      _visible = true;
    });
  }

  void _handlerDownload(Function setState, String imageUrl) async {
    try {
      setState(() {
        isDownloading = true;
      });
      var imageId = await ImageDownloader.downloadImage(imageUrl);
      if (imageId == null) {
        return;
      }
      setState(() {
        isDownloading = false;
      });
    } catch (error) {
      setState(() {
        isDownloading = false;
      });
      print(error);
    }
  }

  void _showFulllScreenImageDialog(
      {@required String? imageUrl, double? width, double? height}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Dialog(
            child: Stack(
              children: <Widget>[
                ImageCard(
                  imageUrl: imageUrl,
                  width: width,
                  height: height,
                  boxFit: BoxFit.contain,
                  fullScreen: true,
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Button(
                    icon: Icons.file_download,
                    onPressed: () {
                      _handlerDownload(setState, imageUrl!);
                    },
                    tooltip: 'Download Image',
                    isLoading: isDownloading,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then(
      (_) => setState(() {
        isDownloading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/images/Logo.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
            child: Column(
              children: <Widget>[
                BlocBuilder<RandomImageBloc, RandomImageState>(
                  builder: (context, state) {
                    RandomImage? randomImage;
                    if (state is LoadedRandomImageState) {
                      if (state.response.data != null) {
                        randomImage =
                            (state.response.data ?? '') as RandomImage?;
                      }
                    }
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: state is LoadedRandomImageState
                          ? GestureDetector(
                              onTap: () {
                                _showFulllScreenImageDialog(
                                  imageUrl: randomImage?.url,
                                  width: randomImage?.width?.toDouble(),
                                  height: randomImage?.height?.toDouble(),
                                );
                              },
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return ScaleTransition(
                                      child: child, scale: animation);
                                },
                                child: ImageCard(
                                  imageUrl: randomImage?.url,
                                  width: randomImage?.width?.toDouble(),
                                  height: randomImage?.height?.toDouble(),
                                  key: UniqueKey(),
                                ),
                              ),
                            )
                          : Spinkit(),
                    );
                  },
                ),
                SizedBox(height: 30),
                Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOutSine,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(_valueAnimated),
                      decoration: boxDecoration(useBackgroundImage: true),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecoration(
                              color: Theme.of(context).accentColor,
                              useBoxShadow: false,
                            ),
                            child: Text(
                              'Did You Know?',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          BlocBuilder<FactBloc, FactState>(
                            builder: (context, state) {
                              if (state is LoadedFactState) {
                                return AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: _visible ? 1 : 0,
                                  child: FactCard(text: state.fact.text),
                                );
                              } else
                                return Spinkit();
                            },
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Button(
                                icon: Icons.share,
                                onPressed: () {
                                  Fact fact =
                                      BlocProvider.of<FactBloc>(context).fact;
                                  _handlerShare(fact.text);
                                },
                                tooltip: 'Share',
                              ),
                              Button(
                                icon: Icons.refresh,
                                onPressed: _handlerNext,
                                tooltip: 'Another Fact',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
