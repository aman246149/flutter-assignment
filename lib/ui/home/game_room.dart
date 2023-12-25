import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/constant/snackbar.dart';
import 'package:ispy/main.dart';
import 'package:ispy/repository/home_repository.dart';
import 'package:ispy/ui/home/home.dart';

import '../../bloc/home/home_bloc.dart';
import '../../constant/app_dialogs.dart';
import '../../theme/app_color.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/vspace.dart';

class GameRoom extends StatefulWidget {
  const GameRoom(
      {super.key,
      required this.gameLobbyIdRequired,
      required this.battleWithId});

  final String gameLobbyIdRequired;
  final String battleWithId;

  @override
  State<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends State<GameRoom> {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? gameStream;

  double localDx = 0;
  double localDy = 0;

  bool onPanStart = false;

  @override
  void initState() {
    callGameLobby();

    super.initState();
  }

  void callGameLobby() async {
    try {
      List<double> resp =
          await HomeRepository().callGameLobby(widget.gameLobbyIdRequired);
      localDx = resp[0];
      localDy = resp[1];
    } catch (e) {
      print('Failed to call gameLobby: $e');
    }
  }

  @override
  void didChangeDependencies() {
    context
        .read<HomeBloc>()
        .add(GetGameLobbySteamEvent(gameLobbyId: widget.gameLobbyIdRequired));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showConfirmDialog(
          context: context,
          title: "Exit Game",
          confirmTap: () {
            context.read<HomeBloc>().add(ExitGameEvent(
                gameLobbyId: widget.gameLobbyIdRequired,
                battleWithId: widget.battleWithId));
          },
          cancelTap: () {
            Navigator.pop(context);
          },
          message: "Are you sure you want to exit the game?",
        );
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Game Room ${widget.gameLobbyIdRequired}'),
          ),
          body: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is HomeLoadingState) {
                  showOverlayLoader(context);
                } else if (state is GetGameLobbySteamSuccessState) {
                  hideOverlayLoader(context);
                  gameStream = state.gameLobbyStream;
                  setState(() {});
                } else if (state is HomeErrorState) {
                  hideOverlayLoader(context);
                  showErrorSnackbar(context, state.message);
                } else if (state is UpdatePositionSuccessState) {
                  hideOverlayLoader(context);
                } else if (state is ExitGameSuccessState) {
                  hideOverlayLoader(context);
                  // replace this screen route with the home screen route
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ));
                } else if (state is UpdatePointsSuccessState) {
                  hideOverlayLoader(context);
                } else if (state is DecreasePointsSuccessState) {
                  hideOverlayLoader(context);
                }
              },
              child: gameStream == null
                  ? Center(
                      child: Text("GAME WILL START SOON"),
                    )
                  : StreamBuilder(
                      stream: gameStream,
                      builder: (context, snapshot) {
                        print(snapshot.data.toString());
                        String? imageUrl = snapshot.data?.data()?["imageUrl"];
                        List<dynamic>? imageCordinates =
                            snapshot.data?.data()?["position"];

                        if (snapshot.hasData) {
                          var data = snapshot.data?.data();
                          if (data != null &&
                              data.containsKey("gameFinished") &&
                              data["gameFinished"]) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => MyApp(),
                                ),
                              );
                            });
                          }

                          if (data != null &&
                              data.containsKey("chances") &&
                              data["chances"] < 1) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.read<HomeBloc>().add(ExitGameEvent(
                                  gameLobbyId: widget.gameLobbyIdRequired,
                                  battleWithId: widget.battleWithId));
                            });
                          }

                          return Column(
                            children: [
                              Container(
                                height: 500,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    imageUrl == null
                                        ? Container()
                                        : Image.network(
                                            imageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                    Positioned(
                                      left: onPanStart
                                          ? localDx
                                          : imageCordinates?[0].toDouble() ??
                                              localDx,
                                      top: onPanStart
                                          ? localDy
                                          : imageCordinates?[1].toDouble() ??
                                              localDy,
                                      child: UnconstrainedBox(
                                        child: GestureDetector(
                                          onTap: () {
                                            onPanStart = true;
                                          },
                                          onPanStart: (details) {
                                            onPanStart = true;
                                          },
                                          onPanUpdate:
                                              (DragUpdateDetails details) {
                                            onPanStart = true;

                                            if (snapshot.data
                                                    ?.data()?["challengerId"] ==
                                                FirebaseAuth.instance
                                                    .currentUser!.uid) {
                                              return;
                                            }
                                            setState(() {
                                              localDx += details.delta.dx;
                                              localDy += details.delta.dy;
                                            });
                                          },
                                          onPanEnd: (details) {
                                            onPanStart = false;
                                            if (snapshot.data
                                                    ?.data()?["challengerId"] ==
                                                FirebaseAuth.instance
                                                    .currentUser!.uid) {
                                              return;
                                            }
                                            context.read<HomeBloc>().add(
                                                    UpdatePositionEvent(
                                                        position: [
                                                      localDx,
                                                      localDy
                                                    ],
                                                        gameLobbyId: widget
                                                            .gameLobbyIdRequired));
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 2),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          showConfirmDialog(
                                            context: context,
                                            title: "Exit Game",
                                            confirmTap: () {
                                              context.read<HomeBloc>().add(
                                                  ExitGameEvent(
                                                      gameLobbyId: widget
                                                          .gameLobbyIdRequired,
                                                      battleWithId:
                                                          widget.battleWithId));
                                            },
                                            cancelTap: () {
                                              Navigator.pop(context);
                                            },
                                            message:
                                                "Are you sure you want to exit the game?",
                                          );
                                        },
                                        child: Icon(
                                          Icons.cancel,
                                          color: AppColors.primary,
                                          size: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                visible:
                                    snapshot.data?.data()?["challengerId"] ==
                                        FirebaseAuth.instance.currentUser!.uid,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: PrimaryButton(
                                      text: "Wrong",
                                      onTap: () {
                                        context.read<HomeBloc>().add(
                                            DecreasePointsEvent(
                                                gameLobbyId: widget
                                                    .gameLobbyIdRequired));
                                      },
                                    )),
                                    Expanded(
                                        child: PrimaryButton(
                                      text: "Correct",
                                      onTap: () {
                                        context.read<HomeBloc>().add(
                                            UpdatePointsEvent(
                                                gameLobbyId: widget
                                                    .gameLobbyIdRequired));
                                      },
                                    )),
                                  ],
                                ),
                              ),
                              VSpace(10),
                              Text(
                                "Chances Left :: ${snapshot.data?.data()?["chances"]}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "OpponentScore :: ${snapshot.data?.data()?["opponentScore"]}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container();
                      }))),
    );
  }
}
