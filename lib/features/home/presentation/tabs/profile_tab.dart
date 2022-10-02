import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/utils/translator.dart';
import 'package:movna/core/presentation/widgets/number_field.dart';
import 'package:movna/core/presentation/widgets/titled_box.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/features/home/presentation/bloc/profile_tab_bloc.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<ProfileTabBloc>(),
      child: const _ProfileTabView(),
    );
  }
}

class _ProfileTabView extends StatelessWidget {
  const _ProfileTabView({Key? key}) : super(key: key);

  static const double textFieldsWidth = 120;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TitledBox(
          title: AppLocalizations.of(context)!.myProfile,
          //onMorePressed: nothing more to show or do here,
          child: BlocBuilder<ProfileTabBloc, ProfileTabState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.userName),
                      SizedBox(
                        width: textFieldsWidth,
                        child: state is ProfileTabLoaded
                            ? TextField(
                                decoration:
                                    const InputDecoration(isDense: true),
                                controller: TextEditingController(
                                    text: state.settings.userName),
                                onSubmitted: (value) => context
                                    .read<ProfileTabBloc>()
                                    .add(UserNameChanged(name: value)),
                              )
                            : Text(AppLocalizations.of(context)!.loading),
                      ),
                    ],
                  ),
                  // Height row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.userHeight),
                      SizedBox(
                        width: textFieldsWidth,
                        child: state is ProfileTabLoaded
                            ? NumberField(
                                decoration:
                                    const InputDecoration(isDense: true),
                                allowDecimal: true,
                                controller: TextEditingController(
                                    text: state.settings.userHeightInMeters
                                        .toString()),
                                // TODO : add event when field just lost focus
                                onSubmitted: (value) => context
                                    .read<ProfileTabBloc>()
                                    .add(UserHeightChanged(
                                        heightInMeters: double.parse(value))),
                              )
                            : Text(AppLocalizations.of(context)!.loading),
                      ),
                    ],
                  ),
                  // Weight row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.userWeight),
                      SizedBox(
                        width: textFieldsWidth,
                        child: state is ProfileTabLoaded
                            ? NumberField(
                                decoration:
                                    const InputDecoration(isDense: true),
                                allowDecimal: true,
                                controller: TextEditingController(
                                    text: state.settings.userWeightInKilograms
                                        .toString()),
                                onSubmitted: (value) => context
                                    .read<ProfileTabBloc>()
                                    .add(UserWeightChanged(
                                        weightInKg: double.parse(value))),
                              )
                            : Text(AppLocalizations.of(context)!.loading),
                      ),
                    ],
                  ),
                  // Gender row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.userGender),
                      state is ProfileTabLoaded
                          ? DropdownButton<Gender>(
                              value: state.settings.userGender,
                              onChanged: (Gender? value) {
                                if (value != null) {
                                  context
                                      .read<ProfileTabBloc>()
                                      .add(UserGenderChanged(gender: value));
                                }
                              },
                              items: Gender.values
                                  .map<DropdownMenuItem<Gender>>(
                                      (Gender value) =>
                                          DropdownMenuItem<Gender>(
                                            value: value,
                                            child: Text(
                                              translateGender(value, context),
                                            ),
                                          ))
                                  .toList(),
                            )
                          : Text(AppLocalizations.of(context)!.loading),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        const Divider(),
        TitledBox(
          title: AppLocalizations.of(context)!.myItineraries,
          onMorePressed: () {
            //TODO
          },
          child: BlocBuilder<ProfileTabBloc, ProfileTabState>(
              builder: (context, state) {
            return Text(state is ProfileTabLoaded
                ? AppLocalizations.of(context)!
                    .itinerariesCountText(state.itinerariesCount)
                : AppLocalizations.of(context)!.loading);
          }),
        ),
        const Divider(),
        TitledBox(
          title: AppLocalizations.of(context)!.myGear,
          onMorePressed: () {
            //TODO
          },
          child: BlocBuilder<ProfileTabBloc, ProfileTabState>(
              builder: (context, state) {
            return Text(state is ProfileTabLoaded
                ? AppLocalizations.of(context)!.gearCountText(state.gearCount)
                : AppLocalizations.of(context)!.loading);
          }),
        ),
        const Divider(),
        TitledBox(
          title: AppLocalizations.of(context)!.settings,
          //onMorePressed: nothing more to show or do here,
          child: BlocBuilder<ProfileTabBloc, ProfileTabState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // automatic pause speed threshold row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!
                          .automaticPauseThreshold),
                      SizedBox(
                        width: textFieldsWidth,
                        child: state is ProfileTabLoaded
                            ? NumberField(
                                decoration:
                                    const InputDecoration(isDense: true),
                                allowDecimal: true,
                                controller: TextEditingController(
                                    text: state.settings
                                        .automaticPauseThresholdSpeedInKilometersPerHour
                                        .toString()),
                                onSubmitted: (value) => context
                                    .read<ProfileTabBloc>()
                                    .add(AutomaticPauseSpeedThresholdChanged(
                                        thresholdInKmPH: double.parse(value))),
                              )
                            : Text(AppLocalizations.of(context)!.loading),
                      ),
                    ],
                  ),
                  // automatic pause duration without movement threshold
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!
                          .automaticPauseDurationWithoutMovement),
                      SizedBox(
                        width: textFieldsWidth,
                        child: state is ProfileTabLoaded
                            ? NumberField(
                                decoration:
                                    const InputDecoration(isDense: true),
                                allowDecimal: false,
                                controller: TextEditingController(
                                    text: state
                                        .settings
                                        .automaticPauseThresholdDurationWithoutMovement
                                        .inSeconds
                                        .toString()),
                                onSubmitted: (value) => context
                                    .read<ProfileTabBloc>()
                                    .add(AutomaticPauseDurationThresholdChanged(
                                        durationInSeconds: int.parse(value))),
                              )
                            : Text(AppLocalizations.of(context)!.loading),
                      ),
                    ],
                  ),
                  // automatic lock duration without input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.automaticLockDuration),
                      SizedBox(
                        width: textFieldsWidth,
                        child: state is ProfileTabLoaded
                            ? NumberField(
                                decoration:
                                    const InputDecoration(isDense: true),
                                allowDecimal: false,
                                controller: TextEditingController(
                                    text: state
                                        .settings
                                        .automaticLockThresholdDurationWithoutInput
                                        .inSeconds
                                        .toString()),
                                onSubmitted: (value) => context
                                    .read<ProfileTabBloc>()
                                    .add(AutomaticLockDurationThresholdChanged(
                                        durationInSeconds: int.parse(value))),
                              )
                            : Text(AppLocalizations.of(context)!.loading),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
