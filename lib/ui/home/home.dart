import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/constant/snackbar.dart';
import 'package:ispy/repository/auth_repository.dart';
import 'package:ispy/repository/home_repository.dart';
import 'package:ispy/theme/app_color.dart';
import 'package:ispy/ui/auth/login.dart';
import 'package:ispy/widgets/primary_button.dart';
import 'package:ispy/widgets/vspace.dart';

import '../../bloc/home/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Stream<QuerySnapshot<Map<String, dynamic>>>? onlineUserNamesStream;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    setUserOnline();
    context.read<HomeBloc>().add(GetOnlineUserNamesEvent());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setUserOnline();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "I-SPY",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white, fontSize: 20),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<HomeBloc>().add(SetUserStatusOfflineEvent());
                AuthRepository().logout();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen()), // replace NewPage with your actual page
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoadingState) {
              showOverlayLoader(context);
            } else if (state is HomeSetOnlineSuccessState) {
              hideOverlayLoader(context);
              showSuccessSnackbar(context, "You are online");
            } else if (state is HomeSetOfflineSuccessState) {
              hideOverlayLoader(context);
            } else if (state is HomeErrorState) {
              hideOverlayLoader(context);
              showErrorSnackbar(context, state.message);
            } else if (state is HomeGetOnlineUserNamesSuccessState) {
              hideOverlayLoader(context);
              setState(() {
                onlineUserNamesStream = state.onlineUserNames;
              });
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Currently online users",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18),
                ),
                VSpace(30),
                onlineUserNamesStream == null
                    ? Container()
                    : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: onlineUserNamesStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null &&
                                (snapshot.data!.docs.isEmpty ||
                                    snapshot.data!.docs.length == 1)) {
                              return SizedBox(
                                child: Text(
                                  "OOps! No one is online",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.primary),
                                ),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data?.docs.length ?? 0,
                              separatorBuilder: (context, index) {
                                return VSpace(10);
                              },
                              itemBuilder: (context, index) {
                                if (userId ==
                                    snapshot.data?.docs[index]['userId']) {
                                  return const SizedBox.shrink();
                                }
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ColoredBox(
                                    color: Colors.greenAccent.shade100,
                                    child: ListTile(
                                      title: Text(snapshot.data?.docs[index]
                                          ['username']),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
              ],
            ),
          ),
        ));
  }

  void setUserOnline() {
    context.read<HomeBloc>().add(SetUserStatusOnlineEvent());
  }
}
