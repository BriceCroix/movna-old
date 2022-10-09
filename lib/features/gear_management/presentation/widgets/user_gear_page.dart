import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/entities/gear_type.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/utils/translator.dart';
import 'package:movna/core/presentation/widgets/delete_alert_dialog.dart';
import 'package:movna/core/presentation/widgets/movna_loading_spinner.dart';
import 'package:movna/core/presentation/widgets/presentation_constants.dart';
import 'package:movna/features/gear_management/presentation/blocs/user_gear_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Initial parameters of the page, only used to initialize the state.
class UserGearPageParams {
  final Gear gear;
  final bool editMode;

  UserGearPageParams({
    required this.gear,
    this.editMode = false,
  });
}

class UserGearPage extends StatelessWidget {
  const UserGearPage({Key? key, required UserGearPageParams pageParams})
      : _pageParams = pageParams,
        super(key: key);
  final UserGearPageParams _pageParams;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<UserGearBloc>()..add(ParametersGiven(params: _pageParams)),
      child: const _UserGearView(),
    );
  }
}

class _UserGearView extends StatelessWidget {
  const _UserGearView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserGearBloc, UserGearState>(
      listener: (context, state) {
        if (state is UserGearDone) {
          Navigator.of(context).pop();
        }
      },
      buildWhen: (previous, current) => current is! UserGearBusy,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () => Future.value(state is! UserGearBusy),
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: globalPadding),
                  child: GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext newContext) =>
                            BlocProvider.value(
                          value: context.read<UserGearBloc>(),
                          child: DeleteAlertDialog(
                            onConfirm: () {
                              context
                                  .read<UserGearBloc>()
                                  .add(DeleteGearEvent());
                              Navigator.of(context).pop();
                            },
                            onCancel: () => Navigator.of(context).pop(),
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.delete_rounded),
                  ),
                )
              ],
            ),
            body: Center(
              child: state is UserGearLoaded
                  ? _buildGearProperties(context, state)
                  : const MovnaLoadingSpinner(),
            ),
            floatingActionButton: state is UserGearLoaded
                ? (state.editMode
                    ? _buildValidateButton(context)
                    : _buildEditButton(context))
                : const SizedBox(),
          ),
        );
      },
    );
  }

  FloatingActionButton _buildEditButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.read<UserGearBloc>().add(EditModeEnabled()),
      child: const Icon(Icons.edit_rounded),
    );
  }

  FloatingActionButton _buildValidateButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.read<UserGearBloc>().add(EditDone()),
      child: const Icon(Icons.done_rounded),
    );
  }

  Widget _buildGearProperties(BuildContext context, UserGearLoaded state) {
    const double textFieldsWidth = 120;
    return Container(
      padding: const EdgeInsets.all(globalPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.name),
              AnimatedSwitcher(
                duration: globalAnimationDuration,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: state.editMode
                    ? SizedBox(
                        width: textFieldsWidth,
                        child: TextField(
                          decoration: const InputDecoration(isDense: true),
                          controller: TextEditingController(
                              text: state.gearEdited.name),
                          onSubmitted: (value) => context
                              .read<UserGearBloc>()
                              .add(GearNameEdited(name: value)),
                        ),
                      )
                    : Text(state.gear.name),
              ),
            ],
          ),
          const SizedBox(height: globalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.gearType),
              AnimatedSwitcher(
                duration: globalAnimationDuration,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: state.editMode
                    ? DropdownButton<GearType>(
                        value: state.gearEdited.gearType,
                        onChanged: (GearType? value) {
                          if (value != null) {
                            context
                                .read<UserGearBloc>()
                                .add(GearTypeEdited(gearType: value));
                          }
                        },
                        items: GearType.values
                            .map<DropdownMenuItem<GearType>>(
                                (GearType value) => DropdownMenuItem<GearType>(
                                      value: value,
                                      child: Text(
                                        translateGearType(value, context),
                                      ),
                                    ))
                            .toList(),
                      )
                    : Text(translateGearType(state.gear.gearType, context)),
              ),
            ],
          ),
          //TODO : add statistics about gear (total ran distance, total use time...)
        ],
      ),
    );
  }
}
