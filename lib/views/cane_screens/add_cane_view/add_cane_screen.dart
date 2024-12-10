import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:sugar_mill_app/views/cane_screens/add_cane_view/add_cane_model.dart';
import '../../../widgets/cdrop_down_widget.dart';
import '../../../widgets/ctext_button.dart';
import '../../../widgets/full_screen_loader.dart';

class AddCaneScreen extends StatefulWidget {
  final String caneId;
  const AddCaneScreen({super.key, required this.caneId});

  @override
  State<AddCaneScreen> createState() => _AddCaneScreenState();
}

class _AddCaneScreenState extends State<AddCaneScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CaneViewModel>.reactive(
        viewModelBuilder: () => CaneViewModel(),
        onViewModelReady: (model) => model.initialise(context, widget.caneId),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: model.isEdit == true
                    ? Text(model.canedata.plotNo.toString())
                    : const Text('New Cane Registration'),
              ),
              body: shimmerForm(
                child: SingleChildScrollView(
                  child: Form(
                    key: model.formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                //for plant
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.season,
                                    // Replace null with the selected value if needed
                                    decoration: const InputDecoration(
                                      labelText: 'Season *',
                                    ),
                                    hint: const Text('Select Season'),
                                    items: model.seasonlist.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(val),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        model.setSelectedSeason(value),
                                    validator: model.validateSeason,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                //for plant
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.plantName,
                                    // Replace null with the selected value if needed
                                    decoration: const InputDecoration(
                                      labelText: 'Plant *',
                                    ),
                                    hint: const Text('Select Plant'),
                                    items: model.plantlist.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(val),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        model.setSelectedPlant(value),
                                    validator: model.validatePlant,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Autocomplete<String>(
                                  key: Key(model.canedata.village ?? "03"),
                                  initialValue: TextEditingValue(
                                    text: model.canedata.village ?? "",
                                  ),
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<String>.empty();
                                    }
                                    return model.villageList
                                        .map((route) => route.name ?? "")
                                        .toList()
                                        .where((route) => route
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase()));
                                  },
                                  onSelected: (String routeName) {
                                    // Find the corresponding route object
                                    final routeData = model.villageList
                                        .firstWhere(
                                            (route) => route.name == routeName);
                                    model.setSelectedVillage(context,
                                        routeData.name); // Pass the route
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      // key: Key(model.farmerData.village ?? ""),
                                      // initialValue: model.farmerData.village,
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                        labelText: 'Village *',
                                      ),
                                      onChanged: (String value) {},
                                      validator: model.validateVillage,
                                    );
                                  },
                                  optionsViewBuilder: (BuildContext contpext,
                                      AutocompleteOnSelected<String> onSelected,
                                      Iterable<String> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4.0,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                              maxHeight: 200),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final String option =
                                                  options.elementAt(index);
                                              return GestureDetector(
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                                child: ListTile(
                                                  title: Text(option),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  optionsMaxHeight: 200,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: CdropDown(
                                  dropdownButton: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.plantationStatus,
                                    decoration: const InputDecoration(
                                      labelText: 'Plantation Status *',
                                    ),
                                    hint: const Text('Select Plantation Status'),
                                    items: model.plantationStatus.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(
                                          val,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      Logger().i(newValue);

                                      if (newValue == 'Diversion') {
                                        // Allow "Diversion" and set the selected value
                                        model.setSelectedPlantation(newValue);
                                      } else {
                                        // Reset the field if it's not "Diversion"
                                        model.setSelectedPlantation(null);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 1),
                                            backgroundColor: Colors.red,
                                            content: Text('Only "Diversion" is allowed.'),
                                          ),
                                        );
                                      }

                                      // Update the visibility state (assuming this is relevant to your logic)
                                      model.isVisible(newValue);
                                    },
                                    validator: (value) {
                                      // Validate that "Diversion" is the selected value
                                      if (value != 'Diversion' && model.isEdit==true) {
                                        return 'Only "Diversion" is allowed.';
                                      }
                                      return null; // Return null when the validation passes
                                    },
                                  ),
                                ),
                              ),

                            ],
                          ),

                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Expanded(
                              child: Autocomplete<String>(
                                key: Key(model.canedata.vendorCode ?? "05"),
                                initialValue: TextEditingValue(
                                  text: model.canedata.vendorCode ?? "",
                                ),
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  final searchText =
                                      textEditingValue.text.toLowerCase();
                                  return model.farmerList
                                      .where((grower) =>
                                          (grower.supplierName
                                                  ?.toLowerCase()
                                                  .contains(searchText) ??
                                              false) ||
                                          (grower.existingSupplierCode
                                                  ?.toLowerCase()
                                                  .contains(searchText) ??
                                              false))
                                      .map((grower) =>
                                          grower.existingSupplierCode ?? "")
                                      .toList();
                                },
                                onSelected: model.setSelectedGrowerCode,
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextFormField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                      labelText: 'Grower Code * ',
                                    ),
                                    onChanged: (String value) {},
                                    validator: model.validateGrowerCode,
                                  );
                                },
                                optionsViewBuilder: (BuildContext context,
                                    AutocompleteOnSelected<String> onSelected,
                                    Iterable<String> options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4.0,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 200),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final String option =
                                                options.elementAt(index);
                                            final routeData = model.farmerList
                                                .firstWhere((route) =>
                                                    route
                                                        .existingSupplierCode ==
                                                    option);
                                            return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: ListTile(
                                                title: Text(option),
                                                subtitle: Text(
                                                    routeData.supplierName!),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                optionsMaxHeight: 200,
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              //for plant
                              child: CdropDown(
                                dropdownButton: DropdownButtonFormField<String>(
                                  value: model.canedata.developmentPlot,
                                  // Replace null with the selected value if needed
                                  decoration: const InputDecoration(
                                    labelText: 'Development Plot',
                                  ),
                                  hint: const Text('Select Plot'),
                                  items: model.yesno.map((val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: AutoSizeText(val),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      model.setSelectedDevelopmentPlot(value),
                                ),
                              ),
                            ),
                          ]),
                          TextFormField(
                            readOnly: true,
                            key: Key(model.canedata.growerName ?? "07"),
                            initialValue: model.canedata.growerName,
                            decoration:
                                const InputDecoration(labelText: 'Grower Name'),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a Grower Name'
                                : null,
                            onChanged: model.setSelectedGrowerName,
                          ),
                          //mobile number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: false),
                                  controller: model.formNumberController,
                                  decoration: const InputDecoration(
                                      labelText: 'Form Number *'),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter a form  Number'
                                      : null,
                                  onChanged: model.setFormNumber,
                                ),
                              ),
                              // const SizedBox(
                              //   width: 20.0,
                              // ),
                              // Expanded(
                              //   //for plant
                              //   child: CdropDown(
                              //     dropdownButton:
                              //         DropdownButtonFormField<String>(
                              //       isExpanded: true,
                              //       value: model.canedata.isKisanCard,
                              //       // Replace null with the selected value if needed
                              //       decoration: const InputDecoration(
                              //         labelText: 'Is Kisan Card *',
                              //       ),
                              //       hint: const Text('Select Is Kisan Card'),
                              //       items: model.yesno.map((val) {
                              //         return DropdownMenuItem<String>(
                              //           value: val,
                              //           child: AutoSizeText(val),
                              //         );
                              //       }).toList(),
                              //       onChanged: (value) =>
                              //           model.setSelectedkisan(value),
                              //       validator: model.validateKisanCard,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          model.isEdit
                              ? const Chip(
                                  label: Text(
                                    "Route Details",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Container(),
                          Row(
                            children: [
                              Expanded(
                                child: Autocomplete<String>(
                                  key: Key(model.canedata.route ?? "02"),
                                  initialValue: TextEditingValue(
                                    text: model.selectedCaneRoute ?? "",
                                  ),
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<String>.empty();
                                    }
                                    return model.routeList
                                        .map((route) => route.route ?? "")
                                        .toList()
                                        .where((route) => route
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase()));
                                  },
                                  onSelected: (String routeName) {
                                    // Find the corresponding route object
                                    final routeData = model.routeList
                                        .firstWhere((route) =>
                                            route.route == routeName);
                                    model.setSelectedRoute(
                                        routeData); // Pass the route
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                        labelText: 'Route *',
                                      ),
                                      onChanged: (String value) {},
                                      validator: model.validateRoute,
                                    );
                                  },
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected<String> onSelected,
                                      Iterable<String> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4.0,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            maxHeight: 200,
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final String option =
                                                  options.elementAt(index);
                                              // Find the corresponding route object
                                              final routeData = model.routeList
                                                  .firstWhere((route) =>
                                                      route.route == option);
                                              return GestureDetector(
                                                onTap: () {
                                                  onSelected(routeData.route ??
                                                      ""); // Send the name as the selected route
                                                },
                                                child: ListTile(
                                                  title: Text(option),
                                                  // Display the corresponding name value
                                                  subtitle:
                                                      Text(routeData.name!),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  optionsMaxHeight: 200,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                  child: TextFormField(
                                key: Key(model.canedata.routeKm.toString()),
                                readOnly: true,
                                decoration:
                                    const InputDecoration(labelText: 'KM'),
                                initialValue: model.canedata.routeKm
                                        ?.toStringAsFixed(0) ??
                                    "",
                                onChanged: (newValue) {
                                  // Handle the newValue here, you can update the routeKm value
                                  // using the setroutekm function with the new value.
                                  double? parsedValue =
                                      double.tryParse(newValue) ?? 0;
                                  model.setRouteKm(parsedValue);
                                },
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: model.canedata.route != null,
                                child: Expanded(
                                  child: TextFormField(
                                    key: Key(model.canedata.circleOffice ??
                                        "circleoffice"),
                                    readOnly: true,
                                    initialValue: model.canedata.circleOffice,
                                    decoration: const InputDecoration(
                                      labelText: 'Circle Office',
                                    ),
                                    onChanged: model.setSelectedCircleOffice,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Visibility(
                                visible: model.isEdit,
                                child: Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    initialValue: model.canedata.taluka,
                                    decoration: const InputDecoration(
                                        labelText: 'Taluka'),
                                  ),
                                ),
                              ),

                              // Expanded(
                              //   child: TextFormField(
                              //     readOnly: true,
                              //     initialValue: model.canedata.state,
                              //     decoration: const InputDecoration(
                              //       labelText: 'State',
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: model.isEdit,
                            child: const Divider(
                              thickness: 1,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: model.surveyNumberController,
                                  decoration: const InputDecoration(
                                    labelText: 'Survey Number *',
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter a Survey Number'
                                      : null,
                                  onChanged: model.setSurveyNumber,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Autocomplete<String>(
                                  key: Key(model.canedata.cropVariety ??
                                      "cropvariety"),
                                  initialValue: TextEditingValue(
                                    text: model.canedata.cropVariety ?? "",
                                  ),
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<String>.empty();
                                    }
                                    return model.canevarietyList
                                        .map((route) => route)
                                        .toList()
                                        .where((route) => route
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase()));
                                  },
                                  onSelected: (value) =>
                                      model.setSelectedCropVariety(value),
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      // key: Key(model.farmerData.village ?? ""),
                                      // initialValue: model.farmerData.village,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              signed: false),
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                        labelText: 'Crop Variety *',
                                      ),
                                      onChanged: (String value) {},
                                      validator: model.validateVillage,
                                    );
                                  },
                                  optionsViewBuilder: (BuildContext contpext,
                                      AutocompleteOnSelected<String> onSelected,
                                      Iterable<String> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4.0,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                              maxHeight: 200),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final String option =
                                                  options.elementAt(index);
                                              return GestureDetector(
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                                child: ListTile(
                                                  title: AutoSizeText(option),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  optionsMaxHeight: 200,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.plantationSystem,
                                    decoration: const InputDecoration(
                                      labelText: 'Plantation System *',
                                    ),
                                    hint:
                                        const Text('Select Plantation System'),
                                    items:
                                        model.plantationsystemList.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(val),
                                      );
                                    }).toList(),
                                    onChanged: (value) => model
                                        .setSelectedPlantationSystem(value),
                                    validator: model.validatePlantationSystem,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.irrigationSource,
                                    // Replace null with the selected value if needed
                                    decoration: const InputDecoration(
                                      labelText: 'Irrigation Source *',
                                    ),
                                    hint: const Text(
                                        'Select Is Irrigation Source'),
                                    items:
                                        model.irrigationSourceList.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(val),
                                      );
                                    }).toList(),
                                    onChanged: (value) => model
                                        .setSelectedIrrigationSource(value),
                                    validator: model.validateirrigationSource,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.soilType,
                                    // Replace null with the selected value if needed
                                    decoration: const InputDecoration(
                                      labelText: 'Soil Type *',
                                    ),
                                    hint: const Text('Select Is Soil Type'),
                                    items: model.soilTypeList.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(val),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        model.setSelectedSoilType(value),
                                    validator: model.validateSoilType,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.roadSide,
                                    // Replace null with the selected value if needed
                                    decoration: const InputDecoration(
                                      labelText: 'Road Side *',
                                    ),
                                    hint: const Text('Select Is Road Side'),
                                    items: model.yesnoroadside.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(val),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        model.setSelectedRoadSIde(value),
                                    validator: model.validateRoadSide,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.cropType,
                                    // Replace null with the selected value if needed
                                    decoration: const InputDecoration(
                                      labelText: 'Crop Type *',
                                    ),
                                    hint: const Text('Select Crop Type'),
                                    items: model.croptypeList.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(val),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        model.setSelectedCropType(value),
                                    validator: model.validateCropType,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextFormField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  controller: model.areainAcrsController,
                                  decoration: const InputDecoration(
                                    labelText: 'Area In Acrs *',
                                  ),
                                  validator: model.validateAreaInAcrs,
                                  onChanged: model.setSelectedAreaInAcrs,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: model.plantationdateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    labelText: 'Plantation Date *',
                                    hintText: 'DD-MM-YYYY',
                                    errorText: model.errorMessage.isNotEmpty
                                        ? model.errorMessage
                                        : null,
                                  ),
                                  validator: model.validatePlantationDate,
                                  onChanged: model.onPlantationDateChanged,
                                  // Format the date before displaying it in the TextFormField
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: TextFormField(
                                  controller: model.baselDateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    labelText: 'Basel Date',
                                    hintText: 'DD-MM-YYYY',
                                    errorText:
                                        model.errorMessageforbasel.isNotEmpty
                                            ? model.errorMessageforbasel
                                            : null,
                                  ),
                                  onChanged: model.onBaselDateChanged,
                                ),
                              ),
                            ],
                          ),
                          //Text

                          Row(
                            children: [
                              Expanded(
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.irrigationMethod,
                                    // Replace null with the selected value if needed
                                    decoration: const InputDecoration(
                                      labelText: 'Irrigation Method *',
                                    ),
                                    hint:
                                        const Text('Select Irrigation Method'),
                                    items:
                                        model.irrigationmethodList.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(val),
                                      );
                                    }).toList(),
                                    onChanged: (value) => model
                                        .setSelectedIrrigationMethod(value),
                                    validator: model.validateirrigationMethod,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: model.canedata.seedMaterial,
                                    // Replace null with the selected value if needed
                                    decoration: const InputDecoration(
                                      labelText: 'Seed Material *',
                                    ),
                                    hint: const Text('Select Seed Material'),
                                    items: model.seedmaterialList.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(val),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        model.setSelectedSeedMaterial(value),
                                    validator: model.validateSeedMaterial,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    value: model.canedata.isMachine,
                                    // Replace null with the selected value if needed
                                    decoration: const InputDecoration(
                                      labelText: 'Is Machine',
                                    ),
                                    isExpanded: true,
                                    hint:
                                        const AutoSizeText('Select Is Machine'),
                                    items: model.yesnomachine.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(
                                          val,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        model.setSelectedIsMachine(value),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: CdropDown(
                                  dropdownButton:
                                      DropdownButtonFormField<String>(
                                    value: model.canedata.seedType,
                                    // Replace null with the selected value if needed
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Seed Type',
                                    ),
                                    hint:
                                        const AutoSizeText('Select Seed Type'),
                                    items: model.seedType.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: AutoSizeText(
                                          val,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        model.setSelectedSeedType(value),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Visibility(
                            visible: model.isVisible(model.canedata.plantationStatus),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: CtextButton(
                                    text: 'Cancel',
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    buttonColor: Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: CtextButton(
                                    onPressed: () {
                                      if ((model.canedata.areaAcrs ?? 0.0) > 10.0) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext dialogContext) { // Use a new context for the dialog
                                            return AlertDialog(
                                              title: const Text('More than 10 acres cane registration!'),
                                              content: const Text(
                                                  'Above Cane Registration is more than 10. Do you want to save this registration?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(dialogContext).pop(); // Close the dialog with dialogContext
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(dialogContext).pop(); // Close the dialog
                                                    if (context.mounted) { // Ensure context is mounted before proceeding
                                                      model.onSavePressed(context); // Proceed with save
                                                    }
                                                  },
                                                  child: const Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        if (context.mounted) {
                                          model.onSavePressed(context);
                                        }
                                      }
                                    },
                                    text: 'Save',
                                    buttonColor: Colors.green,
                                  ),
                                )
                                  ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                loader: model.isBusy,
                context: context,
              ),
            ));
  }
}
