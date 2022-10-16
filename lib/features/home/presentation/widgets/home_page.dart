import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/features/home/presentation/bloc/home_bloc.dart';
import 'package:movna/features/home/presentation/tabs/history_tab.dart';
import 'package:movna/features/home/presentation/tabs/profile_tab.dart';
import 'package:movna/features/home/presentation/tabs/start_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<HomeBloc>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    const int defaultTabIndex = 1;

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous is HomeInitial &&
          current is HomeInitial &&
          previous.selectedIndex != current.selectedIndex,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title:
                  Center(child: Text(AppLocalizations.of(context)!.appName))),
          body: _buildBody(
              state is HomeInitial ? state.selectedIndex : defaultTabIndex),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 8,
            //unselectedItemColor: Colors.grey,
            //selectedItemColor: Theme.of(context).primaryColor,
            //backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.account_circle),
                label: AppLocalizations.of(context)!.profile,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: AppLocalizations.of(context)!.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart),
                label: AppLocalizations.of(context)!.history,
              ),
            ],
            currentIndex:
                state is HomeInitial ? state.selectedIndex : defaultTabIndex,
            onTap: (value) =>
                context.read<HomeBloc>().add(NavBarIndexChanged(index: value)),
          ),
        );
      },
    );
  }

  Widget _buildBody(int index) {
    late Widget body;
    switch (index) {
      case 0:
        body = const ProfileTab();
        break;
      case 1:
        body = const StartTab();
        break;
      case 2:
        body = const HistoryTab();
        break;
    }
    return body;
  }
}
