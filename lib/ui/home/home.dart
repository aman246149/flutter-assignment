import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/constant/snackbar.dart';
import 'package:ispy/repository/auth_repository.dart';
import 'package:ispy/repository/home_repository.dart';
import 'package:ispy/widgets/primary_button.dart';

import '../../bloc/home/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    setUserOnline();
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
        }
      },
      child: Column(
        children: [],
      ),
    ));
  }

  void setUserOnline() {
    context.read<HomeBloc>().add(SetUserStatusOnlineEvent());
  }
}
