import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _switchValue = true;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 17, 29),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 35,
              color: Color.fromARGB(255, 255, 255, 255),
            )),
        backgroundColor: const Color.fromARGB(126, 99, 69, 139),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight/2,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(126, 99, 69, 139),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight/15),
                child: Container(
                  alignment: Alignment.topLeft,
                  width: screenWidth,
                  height: screenHeight/2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color.fromARGB(255, 22, 17, 29),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Padding(
                      padding:  EdgeInsets.only(top: screenHeight/100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share,
                              color: Color.fromARGB(172, 224, 104, 240),
                            ),
                            label: const Text(
                              'Share',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.privacy_tip_outlined,
                              color: Color.fromARGB(172, 224, 104, 240),
                            ),
                            label: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.format_list_bulleted_sharp,
                              color: Color.fromARGB(172, 224, 104, 240),
                            ),
                            label: const Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.info,
                              color: Color.fromARGB(172, 224, 104, 240),
                            ),
                            label: const Text(
                              'About',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                           SizedBox(
                            height: screenHeight/20,
                          ),
                          const Divider(
                            thickness: 1,
                            color: Color.fromARGB(173, 168, 47, 184),
                          ),
                           SizedBox(
                            height: screenHeight/20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Notification',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                 SizedBox(
                                  width: screenWidth/2.6,
                                ),
                                _buildSwitch(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch() {
    return Switch(
      value: _switchValue,
      onChanged: _updateSwitch,
      activeColor: Colors.white,
      inactiveTrackColor: Colors.white,
      inactiveThumbColor: const Color.fromARGB(200, 130, 11, 146),
      activeTrackColor: const Color.fromARGB(172, 224, 104, 240),
      
    );
  }

  void _updateSwitch(bool newValue) {
    setState(() {
      _switchValue = newValue;
    });
  }
}
