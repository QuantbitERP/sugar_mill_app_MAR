import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:sugar_mill_app/constants.dart';
import 'package:sugar_mill_app/views/home_view/home_view_model.dart';
import 'package:sugar_mill_app/widgets/full_screen_loader.dart';
import '../../models/aadharData_model.dart';
import '../../router.router.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // Helper function to create a button with an image and text
  Widget _buildImageButton({
    required String imagePath,
    required String buttonText,
    required Function onPressed,
  }) {
    return Material(
      color: Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Material(
          color: Colors.white,
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                height: 120,
                width: 500,
                fit: BoxFit.fill,
              ),
              Expanded(
                child: Center(
                  child: AutoSizeText(
                    maxFontSize: 15,
                    buttonText,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AutoSizeText(
                'Venkateshwara Power Project',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                model.appVersion,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            logout(context); // Close the dialog
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: fullScreenLoader(
          loader: model.isBusy,
          context: context,
          child: WillPopScope(
            onWillPop: _onWillPop,
            child: SingleChildScrollView(
                child: Hero(
                    tag: "TITLE",
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/images/sugarcane_image.jpg')),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: getHeight(context) / 5,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath: 'assets/images/farmer.jpg',
                                    buttonText: 'New Farmer',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.addFarmerScreen,
                                        arguments: AddFarmerScreenArguments(
                                            qrdata: aadharData(), farmerid: ""),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath: 'assets/images/farmer_list.jpg',
                                    buttonText: 'Farmer List',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.listFarmersScreen,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: getHeight(context) / 5,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath:
                                        'assets/images/cane_registration.jpeg',
                                    buttonText: 'New Cane Registration',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.addCaneScreen,
                                        arguments: const AddCaneScreenArguments(
                                            caneId: ""),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath: 'assets/images/cane_list.jpg',
                                    buttonText: 'Cane Master List',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.listCaneScreen,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: getHeight(context) / 5,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath:
                                        'assets/images/agri_developement.jpg',
                                    buttonText: 'New Cane Development',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.addAgriScreen,
                                        arguments: const AddAgriScreenArguments(
                                            agriId: ""),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath: 'assets/images/agri_list.jpg',
                                    buttonText: 'Cane Development List',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.listAgriScreen,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: getHeight(context) / 5,
                            child: Row(
                              children: [
                                // Expanded(
                                //   child: _buildImageButton(
                                //     imagePath:
                                //         'assets/images/crop_sampling.jpg',
                                //     buttonText: 'New Crop Sampling',
                                //     onPressed: () {
                                //       Navigator.pushNamed(
                                //         context,
                                //         Routes.addCropSamplingScreen,
                                //         arguments:
                                //             const AddCropSamplingScreenArguments(
                                //                 samplingId: ""),
                                //       );
                                //     },
                                //   ),
                                // ),
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath:
                                        'assets/images/crop_sample_list.jpg',
                                    buttonText: 'To Be Crop Samplings',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.listSamplingScreen,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath:
                                        'assets/images/crop_sample_list.jpg',
                                    buttonText: ' Completed Crop Samplings',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.listCompletedSamplingScreen,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: getHeight(context) / 5,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath: 'assets/images/trip_sheet.webp',
                                    buttonText: 'New Trip Sheet',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.addTripSheetScreen,
                                        arguments:
                                            const AddTripSheetScreenArguments(
                                                tripId: ""),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: _buildImageButton(
                                    imagePath: 'assets/images/trip_list.jpg',
                                    buttonText: 'Trip Sheet List',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.tripsheetMaster,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 15.0,
                          // ),
                          // Card(
                          //   elevation: 1,
                          //   child: ListTile(
                          //     leading:
                          //         Icon(CupertinoIcons.rectangle_on_rectangle),
                          //     title: Text('Reports'),
                          //     trailing: Icon(CupertinoIcons.arrow_right),
                          //     onTap: () {
                          //       Navigator.pushNamed(
                          //         context,
                          //         Routes.reportScreen,
                          //       );
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ))),
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) => model.initialise(context),
    );
  }
}
