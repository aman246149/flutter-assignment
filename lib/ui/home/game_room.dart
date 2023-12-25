import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/constant/snackbar.dart';

import '../../bloc/home/home_bloc.dart';
import '../../constant/app_dialogs.dart';
import '../../theme/app_color.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/vspace.dart';

class GameRoom extends StatefulWidget {
  const GameRoom({super.key, required this.gameLobbyIdRequired});

  final String gameLobbyIdRequired;

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
    context
        .read<HomeBloc>()
        .add(GetGameLobbySteamEvent(gameLobbyId: widget.gameLobbyIdRequired));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showConfirmDialog(
          context: context,
          title: "Exit Game",
          confirmTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
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
                                          setState(() {
                                            localDx += details.delta.dx;
                                            localDy += details.delta.dy;
                                          });
                                        },
                                        onPanEnd: (details) {
                                          onPanStart = false;
                                          context.read<HomeBloc>().add(
                                              UpdatePositionEvent(
                                                  position: [localDx, localDy],
                                                  gameLobbyId: widget
                                                      .gameLobbyIdRequired));
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: Colors.green, width: 2),
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
                                        // context.read<HomeBloc>().add(
                                        //     ExitGameEvent(
                                        //         opponentId: snapshot.data
                                        //             ?.docs[index]['userId']));
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
                            Row(
                              children: [
                                Expanded(
                                    child: PrimaryButton(
                                  text: "Wrong",
                                  onTap: () {},
                                )),
                                Expanded(
                                    child: PrimaryButton(
                                  text: "Correct",
                                  onTap: () {},
                                )),
                              ],
                            )
                          ],
                        );
                      }))),
    );
  }
}
