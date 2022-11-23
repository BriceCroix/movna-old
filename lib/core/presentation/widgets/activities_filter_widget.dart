import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/domain/entities/activities_filter.dart';
import 'package:movna/core/domain/entities/sport.dart';
import 'package:movna/core/presentation/utils/translator.dart';
import 'package:movna/core/presentation/widgets/number_field.dart';
import 'package:movna/core/presentation/widgets/presentation_constants.dart';

class ActivitiesFilterWidget extends StatefulWidget {
  ActivitiesFilterWidget({
    required this.value,
    this.onChanged,
    this.sportChoices = Sport.values,
    DateTime? minimumDate,
    Key? key,
  })  : minimumDate = minimumDate ?? DateTime(1900),
        super(key: key);

  /// The current filter value.
  /// Must not be null.
  ActivitiesFilter? value;

  /// Called when the value of the filter widget should change.
  ///
  /// The filter passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the Widget with the new
  /// value.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// ActivitiesFilterWidget(
  ///   value: _myFilter,
  ///   onChanged: (ActivitiesFilter newValue) {
  ///     setState(() {
  ///       _my filter = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<ActivitiesFilter>? onChanged;

  /// The sports available in the sport filter.
  final List<Sport> sportChoices;

  /// The minimum date available in the date pickers.
  final DateTime minimumDate;

  @override
  State<ActivitiesFilterWidget> createState() => _ActivitiesFilterWidgetState();
}

class _ActivitiesFilterWidgetState extends State<ActivitiesFilterWidget> {
  static const _numberFieldsWidth = 100.0;
  static const _dateFieldsWidth = 100.0;
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();
  final _distanceFromController = TextEditingController();
  final _distanceToController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(globalPadding),
          child: Row(
            children: [
              Column(
                children: [
                  Text(AppLocalizations.of(context)!.sport),
                  const SizedBox(height: globalPadding),
                  DropdownButton<Sport?>(
                    value: widget.value?.sport,
                    onChanged: (sportValue) {
                      setState(() {
                        widget.value =
                            widget.value?.copyWith(sport: sportValue);
                        if (widget.value != null && widget.onChanged != null) {
                          widget.onChanged!(widget.value!);
                        }
                      });
                    },
                    items: [
                      DropdownMenuItem<Sport?>(
                        value: null,
                        child: Text(AppLocalizations.of(context)!.all),
                      ),
                      ...widget.sportChoices
                          .map<DropdownMenuItem<Sport?>>((value) {
                        return DropdownMenuItem<Sport?>(
                          value: value,
                          child: Text(translateSport(value, context)),
                        );
                      }),
                    ],
                  )
                ],
              ),
              const SizedBox(width: globalPadding),
              Column(
                children: [
                  Text(AppLocalizations.of(context)!.dateFrom),
                  const SizedBox(height: globalPadding),
                  SizedBox(
                    width: _dateFieldsWidth,
                    child: TextField(
                        controller: _dateFromController,
                        decoration: const InputDecoration(
                          isDense: true,
                          //icon: Icon(Icons.calendar_today_rounded),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: widget.minimumDate,
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            _dateFromController.text =
                                pickedDate.toString().split(' ').first;
                            setState(() {
                              widget.value = widget.value
                                  ?.copyWith(dateTimeFrom: pickedDate);
                              if (widget.value != null &&
                                  widget.onChanged != null) {
                                widget.onChanged!(widget.value!);
                              }
                            });
                          }
                        }),
                  )
                ],
              ),
              const SizedBox(width: globalPadding),
              Column(
                children: [
                  Text(AppLocalizations.of(context)!.dateTo),
                  const SizedBox(height: globalPadding),
                  SizedBox(
                    width: _dateFieldsWidth,
                    child: TextField(
                        controller: _dateToController,
                        decoration: const InputDecoration(
                          isDense: true,
                          //icon: Icon(Icons.calendar_today_rounded),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: widget.minimumDate,
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            // Add a day to include the picked day.
                            pickedDate.add(const Duration(
                                milliseconds: Duration.millisecondsPerDay));
                            _dateToController.text =
                                pickedDate.toString().split(' ').first;
                            setState(() {
                              widget.value = widget.value
                                  ?.copyWith(dateTimeTo: pickedDate);
                              if (widget.value != null &&
                                  widget.onChanged != null) {
                                widget.onChanged!(widget.value!);
                              }
                            });
                          }
                        }),
                  )
                ],
              ),
              const SizedBox(width: globalPadding),
              Column(
                children: [
                  // TODO : handle unit (meter / km / mile)
                  Text('${AppLocalizations.of(context)!.distanceMin} (m)'),
                  const SizedBox(height: globalPadding),
                  SizedBox(
                    width: _numberFieldsWidth,
                    child: NumberField(
                      decoration: const InputDecoration(isDense: true),
                      allowDecimal: false,
                      controller: _distanceFromController,
                      // TODO : add event when field just lost focus
                      onSubmitted: (distance) {
                        setState(() {
                          widget.value = widget.value
                              ?.copyWith(distanceFrom: double.parse(distance));
                          if (widget.value != null &&
                              widget.onChanged != null) {
                            widget.onChanged!(widget.value!);
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(width: globalPadding),
              Column(
                children: [
                  // TODO : handle unit (meter / km / mile)
                  Text('${AppLocalizations.of(context)!.distanceMax} (m)'),
                  const SizedBox(height: globalPadding),
                  SizedBox(
                    width: _numberFieldsWidth,
                    child: NumberField(
                      decoration: const InputDecoration(isDense: true),
                      allowDecimal: false,
                      controller: _distanceToController,
                      // TODO : add event when field just lost focus
                      onSubmitted: (distance) {
                        setState(() {
                          widget.value = widget.value
                              ?.copyWith(distanceTo: double.parse(distance));
                          if (widget.value != null &&
                              widget.onChanged != null) {
                            widget.onChanged!(widget.value!);
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(width: globalPadding),
              ElevatedButton.icon(
                onPressed: () {
                  widget.value = const ActivitiesFilter();
                  _dateFromController.text = '';
                  _dateToController.text = '';
                  _distanceFromController.text = '';
                  _distanceToController.text = '';
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.value!);
                  }
                },
                icon: const Icon(Icons.loop_rounded),
                label: Text(AppLocalizations.of(context)!.reset),
              )
            ],
          ),
        ));
  }
}
