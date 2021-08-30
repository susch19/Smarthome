import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/dashboard/group_devices.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'dart:async';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/simple_dialog_single_input.dart';
import 'package:flutter/foundation.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/session/cert_file.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'controls/expandable_fab.dart';
import 'session/permanent_retry_policy.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  PreferencesManager.instance = PreferencesManager(prefs);

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  ThemeManager.initThemeManager(savedThemeMode);
  DeviceManager.init();
  runApp(MyApp(savedThemeMode));
}

class MyApp extends StatelessWidget {
  MyApp(this.savedThemeMode);

  static late PreferencesManager prefManager;
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    // ThemeManager.initalize();
    return AdaptiveTheme(
        //      light: ThemeData(
        //   brightness: Brightness.light,
        //   primarySwatch: Colors.blue,
        // ),
        // dark: ThemeData(
        //   brightness: Brightness.dark,
        //   primarySwatch: Colors.blue,
        // ),
        light: ThemeManager.getLightTheme(),
        dark: ThemeManager.getDarkTheme(),
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
              scrollBehavior: CustomScrollBehavior(),
              title: 'Smarthome',
              theme: theme,
              darkTheme: darkTheme,
              home: MyHomePage(title: 'Smarthome Home Page'),
            ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  var serverUrl = "http://192.168.49.56:5055/smarthome";
  ForInput urlAddressInput = new ForInput();
  IconData? infoIcon;
  late HubConnection hubConnection;
  CertFile? certFile;
  bool isGrouped = true;

  @override
  void initState() {
    isGrouped = PreferencesManager.instance.getBool("Groupings") ?? true;
    infoIcon = Icons.refresh;
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    doStuff();
    Timer.periodic(Duration(milliseconds: 500), (timer) async {
      setState(() {
        if (hubConnection.state == HubConnectionState.disconnected)
          infoIcon = Icons.warning;
        else if (hubConnection.state == HubConnectionState.connected) infoIcon = Icons.check;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //resumed: 0, inactive: 1, paused: 2
    if (state.index == 0)
      newHubConnection();
    else if (state.index == 2) {
      infoIcon = Icons.error_outline;
      if (hubConnection.state == HubConnectionState.connected) hubConnection.stop();
    }
  }

  Future<dynamic> subscribeToDevive(List<int?> deviceIds) async =>
      await hubConnection.invoke("Subscribe", args: [deviceIds]);

  Future doStuff() async {
    setState(() {
      infoIcon = Icons.refresh;
    });
    // certFile = await loadCertFile(PreferencesManager.instance);
    certFile = null;
    if (certFile != null) serverUrl = certFile!.serverUrl + "/smarthome";
    urlAddressInput.textEditingController.text = serverUrl;

    hubConnection = createHubConnection();
    hubConnection.serverTimeoutInMilliseconds = 30000;
    hubConnection.onclose((e) async {
      if (e == null) return;
      while (true) {
        if (hubConnection.state != HubConnectionState.connected) {
          if (infoIcon != Icons.error_outline) {
            infoIcon = Icons.error_outline;
            setState(() {});
          }
          DeviceManager.stopSubbing();
          try {
            hubConnection.stop();
            hubConnection = createHubConnection();
            await hubConnection.start();
          } catch (e) {}
          sleep(Duration(seconds: 1));
        } else {
          if (infoIcon != Icons.check) {
            setState(() {
              infoIcon = Icons.check;
            });
          }
          var dev = await subscribeToDevive(DeviceManager.devices.map((x) => x.id).toList());
          for (var d in DeviceManager.devices) {
            if (!dev.any((x) => x["id"] == d.id)) DeviceManager.notSubscribedDevices.add(d);
          }
          DeviceManager.subToNonSubscribed(hubConnection);
          break;
        }
      }
    });
    hubConnection.on("Update", updateMethod);

    if (serverUrl != "") {
      await hubConnection.start();
      setState(() {
        infoIcon = Icons.check;
      });
      var ids = <int>[];
      for (var key in PreferencesManager.instance.getKeys().where((x) => x.startsWith("SHD"))) {
        var id = PreferencesManager.instance.getInt(key);
        if (id == null) continue;
        ids.add(id);
      }
      var subs = await subscribeToDevive(ids);

      DeviceManager.loadDevices(subs, ids, hubConnection);
      DeviceManager.currentSort = SortTypes.values[PreferencesManager.instance.getInt("SortOrder") ?? 0];
      DeviceManager.sortDevices();
    }
    setState(() {});
  }

  void newHubConnection() async {
    setState(() {
      infoIcon = Icons.refresh;
    });
    hubConnection.off("Update");
    hubConnection.stop();
    hubConnection = createHubConnection();

    hubConnection.on("Update", updateMethod);

    await hubConnection.start();
    setState(() {
      infoIcon = Icons.check;
    });
    for (var device in DeviceManager.devices) {
      device.connection = hubConnection;
    }
    await subscribeToDevive(DeviceManager.devices.map((x) => x.id).toList());
  }

  void updateMethod(List<Object?>? arguments) {
    arguments!.forEach((a) {
      var asd = a as Map;
      if (asd["id"] == 0)
        DeviceManager.devices
            .where((x) => x.id == asd["id"])
            .forEach((x) => x.updateFromServer(asd as Map<String, dynamic>));
      else
        DeviceManager.getDeviceWithId(asd["id"]).updateFromServer(asd as Map<String, dynamic>);
    });
    setState(() {});
  }

  Widget buildBodyGrouped() {
    var deviceGroups = DeviceManager.devices.groupManyBy((x) => x.groups);
    return Container(
      decoration: ThemeManager.getBackgroundDecoration(context),
      child: RefreshIndicator(
        child: ConstrainedBox(
          child: OrientationBuilder(
            builder: (context, orientation) {
              return StaggeredGridView.extentBuilder(
                  maxCrossAxisExtent: !kIsWeb && Platform.isAndroid ? 370 : 300,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: deviceGroups.length,
                  itemBuilder: (context, i) {
                    var deviceGroup = deviceGroups.elementAt(i);
                    if (deviceGroup == null) return Text("Empty Entry");
                    return Container(
                      margin: EdgeInsets.only(left: 2, top: 4, right: 2, bottom: 2),
                      child: getDashboardCard(deviceGroup, context),
                    );
                    // var device = DeviceManager.devices[i];
                    // return device.dashboardView(
                    //   () {
                    //     deviceAction(device);
                    //     setState(() {});
                    //   },
                    // );
                  },
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1));
            },
          ),
          constraints: BoxConstraints.tight(Size.infinite),
        ),
        onRefresh: () async => refresh(),
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
      ),
    );
  }

  Widget buildBody() {
    return Container(
      decoration: ThemeManager.getBackgroundDecoration(context),
      child: RefreshIndicator(
        child: ConstrainedBox(
          child: OrientationBuilder(
            builder: (context, orientation) {
              return StaggeredGridView.extentBuilder(
                  maxCrossAxisExtent: !kIsWeb && Platform.isAndroid ? 370 : 300,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  itemCount: DeviceManager.devices.length,
                  itemBuilder: (context, i) {
                    var device = DeviceManager.devices[i];
                    return Container(
                      margin: EdgeInsets.only(left: 2, top: 4, right: 2, bottom: 2),
                      child: device.dashboardView(
                        () {
                          deviceAction(device);
                          setState(() {});
                        },
                      ),
                    );
                    // var device = DeviceManager.devices[i];
                    // return device.dashboardView(
                    //   () {
                    //     deviceAction(device);
                    //     setState(() {});
                    //   },
                    // );
                  },
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1));
            },
          ),
          constraints: BoxConstraints.tight(Size.infinite),
        ),
        onRefresh: () async => refresh(),
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
      ),
    );
  }

  Widget getDashboardCard(MapEntry<String, List<Device<BaseModel>>> deviceGroup, BuildContext context) {
    return
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10),
        //   child:
        Container(
      // color: (ThemeManager.isLightTheme ? Colors.blue.shade300.withOpacity(0.1) : Colors.blue.shade800).withAlpha(75),
      child: Container(
        // blur: 5,
        child: Column(
            children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            DeviceManager.getGroupName(
                              deviceGroup.key,
                            ),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (o) => groupOption(o, deviceGroup),
                          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                            PopupMenuItem<String>(value: 'Rename', child: Text("Umbenennen")),
                            PopupMenuItem<String>(value: 'Delete', child: Text("Entfernen")),
                            PopupMenuItem<String>(value: 'Edit', child: Text("Geräte zuordnen")),
                          ],
                        )
                        // IconButton(
                        //   icon: Icon(Icons.edit),
                        //   onPressed: () {

                        //   },
                        // ),
                      ],
                    ),
                  ),
                ] +
                deviceGroup.value
                    .map<Widget>(
                      (e) => Container(
                        margin: EdgeInsets.only(bottom: 0),
                        child: e.dashboardView(
                          () {
                            deviceAction(e);
                            setState(() {});
                          },
                        ),
                      ),
                    )
                    .toList()),
      ),
      // ),
    );
  }

  void groupOption(String value, MapEntry<String, List<Device<BaseModel>>> deviceGroup) {
    switch (value) {
      case 'Rename':
        var sd = SimpleDialogSingleInput.create(
            hintText: "Name der Gruppe",
            labelText: "Name",
            acceptButtonText: "Umbenennen",
            cancelButtonText: "Abbrechen",
            defaultText: DeviceManager.getGroupName(
              deviceGroup.key,
            ),
            onSubmitted: (s) {
              DeviceManager.changeGroupName(deviceGroup.key, s);
            },
            title: "Gruppenname ändern",
            context: context);
        showDialog(builder: (BuildContext context) => sd, context: context);
        break;
      case 'Delete':
        deviceGroup.value.forEach((element) {
          element.groups.remove(deviceGroup.key);
          if (element.groups.length == 0) removeDevice(element, pop: false);
        });
        DeviceManager.saveDeviceGroups();

        break;
      case 'Edit':
        Navigator.push(context, MaterialPageRoute(builder: (c) => GroupDevices(deviceGroup)));
        // var devicesToSelect = <Widget>[];
        // var t = true;
        // for (var i in DeviceManager.devices) {
        //   if (deviceGroup.value.any((element) => element.id == i.id)) continue;
        //   devicesToSelect.add(
        //     SimpleDialogOption(
        //       child: Row(
        //         children: [
        //           Checkbox(
        //               value: t,
        //               onChanged: (v) => setState(() {
        //                     t = !t;
        //                   })),
        //           Icon(i.icon),
        //           Text(i.baseModel.friendlyName + " : " + i.typeName),
        //         ],
        //       ),
        //       onPressed: () async {
        //         // Navigator.pop(context);
        //       },
        //     ),
        //   );
        // }

        // var dialog = SimpleDialog(
        //   children: devicesToSelect,
        //   title: Text((devicesToSelect.length == 0 ? "No new Devices found" : "Add new Smarthome Device")),
        // );
        // showDialog(context: context, builder: (b) => dialog);
        // setState(() {});
        break;
      default:
        break;
    }
  }

  Future addDevice(int? id, dynamic device) async {
    DeviceManager.devices.add(DeviceManager.ctorFactory[device["typeName"]]!(
            device["id"], DeviceManager.stringNameJsonFactory[device["typeName"]]!(device), hubConnection)
        as Device<BaseModel>);
    PreferencesManager.instance.setInt("SHD" + device["id"].toString(), device["id"]);
    PreferencesManager.instance.setString("Json" + device["id"].toString(), jsonEncode(device));
    PreferencesManager.instance.setString("Type" + device["id"].toString(), device["typeName"]);

    await subscribeToDevive([device["id"]]);
    DeviceManager.sortDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Home App"),
        leading: IconButton(icon: Icon(infoIcon), onPressed: refresh),
        // backgroundColor: Colors.blue.shade800.withAlpha(128),
        // gradient: LinearGradient(
        //   colors: [Colors.blue.shade900, Colors.deepPurple.shade900],
        //   begin: Alignment(-2.0, -1.0),
        //   end: Alignment(2.0, 1.0),
        //   // tileMode: TileMode.clamp,
        //   // begin: Alignment(-1.0, 0.0),
        //   // end: Alignment(1.0, 30.0),
        // ),
        actions: <Widget>[
          PopupMenuButton<String>(
            child: Icon(Icons.sort),
            onSelected: selectedSort,
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(value: 'Name', child: Text("Name")),
              PopupMenuItem<String>(value: 'Typ', child: Text("Gerätetyp")),
              PopupMenuItem<String>(value: 'Id', child: Text("Id")),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: selectedOption,
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(value: 'URL', child: Text("Ändere Server Url")),
              PopupMenuItem<String>(value: 'Time', child: Text("Zeit Update")),
              PopupMenuItem<String>(value: 'Theme', child: Text("Theme umstellen")),
              PopupMenuItem<String>(value: 'Groups', child: Text("Gruppierungen ein/-ausblenden")),
              PopupMenuItem<String>(value: 'Debug', child: Text("Toggle Debug")),
              PopupMenuItem<String>(value: 'RemoveAll', child: Text("Entferne alle Geräte")),
            ],
          ),
        ],
      ),
      body: isGrouped ? buildBodyGrouped() : buildBody(),
      floatingActionButton: ExpandableFab(
        distance: 64.0,
        children: [
          ActionButton(
            onPressed: addNewDevice,
            icon: const Icon(Icons.add),
          ),
          ActionButton(
            onPressed: addGroup,
            icon: const Icon(Icons.group_rounded),
          ),
        ],
      ),

      // FloatingActionButton(
      //   onPressed: addNewDevice,

      //   child: Icon(Icons.add),
      // ),
    );
  }

  void selectedOption(String value) {
    switch (value) {
      case "URL":
        var sd = SimpleDialogSingleInput.create(
            hintText: "URL of Smarthome Server",
            labelText: "URL",
            defaultText: serverUrl,
            onSubmitted: (s) {
              serverUrl = s;
              PreferencesManager.instance.setString("mainserverurl", s);
              newHubConnection();
            },
            title: "Change URL",
            context: context);
        showDialog(builder: (BuildContext context) => sd, context: context);
        break;
      case "Time":
        hubConnection.invoke("UpdateTime");
        break;
      case "Debug":
        DeviceManager.showDebugInformation = !DeviceManager.showDebugInformation;
        setState(() {});
        break;
      case "Theme":
        ThemeManager.toogleThemeMode(context);

        break;
      case "Groups":
        setState(() {
          isGrouped = !isGrouped;
        });
        PreferencesManager.instance.setBool("Groupings", isGrouped);

        break;
      case "RemoveAll":
        for (int i = DeviceManager.devices.length - 1; i >= 0; i--) {
          var d = DeviceManager.devices.removeAt(i);
          PreferencesManager.instance.remove("SHD" + d.id!.toString());
          PreferencesManager.instance.remove("Json" + d.id!.toString());
          PreferencesManager.instance.remove("Type" + d.id!.toString());
        }
        DeviceManager.saveDeviceGroups();
        setState(() {});
        break;
    }
  }

  void deviceAction(Device d) {
    var actions = <Widget>[];

    actions.add(
      SimpleDialogOption(
        child: Text("Umbenennen"),
        onPressed: () => renameDevice(d),
      ),
    );
    actions.add(
      SimpleDialogOption(
        child: Text("Entfernen"),
        onPressed: () => removeDevice(d),
      ),
    );

    var dialog = SimpleDialog(
      children: actions,
      title: Text("Gerät " + (d.baseModel.friendlyName)),
    );
    showDialog(context: context, builder: (b) => dialog);
  }

  void removeDevice(Device d, {bool pop = true}) {
    DeviceManager.devices.remove(d);
    PreferencesManager.instance.remove("SHD" + d.id.toString());
    PreferencesManager.instance.remove("Json" + d.id.toString());
    PreferencesManager.instance.remove("Type" + d.id.toString());
    if (pop) Navigator.pop(context);
    setState(() {});
  }

  renameDevice(Device x) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialogSingleInput.create(
            context: context,
            title: "Gerät benennen",
            hintText: "Name für das Gerät",
            labelText: "Name",
            defaultText: x.baseModel.friendlyName,
            maxLines: 2,
            onSubmitted: (s) async {
              x.baseModel.friendlyName = s;
              x.updateDeviceOnServer();
              setState(() {});
            })).then((x) => Navigator.of(context).pop());
  }

  void selectedSort(String value) {
    switch (value) {
      case "Name":
        DeviceManager.currentSort =
            DeviceManager.currentSort == SortTypes.NameAsc ? SortTypes.NameDesc : SortTypes.NameAsc;
        break;
      case "Typ":
        DeviceManager.currentSort =
            DeviceManager.currentSort == SortTypes.TypeAsc ? SortTypes.TypeDesc : SortTypes.TypeAsc;
        break;
      case "Id":
        DeviceManager.currentSort = DeviceManager.currentSort == SortTypes.IdAsd ? SortTypes.IdDesc : SortTypes.IdAsd;
        break;
    }

    setState(() => DeviceManager.sortDevices());
  }

  Future addNewDevice() async {
    if (hubConnection.state != HubConnectionState.connected) {
      await hubConnection.start();
    }

    var s = hubConnection.invoke("GetAllDevices", args: []);

    List<dynamic> serverDevices = await s;

    var devicesToSelect = <Widget>[];
    serverDevices.sort((x, y) => x["typeName"].compareTo(y["typeName"]));
    for (var i in serverDevices) {
      if (!DeviceManager.devices.any((x) => x.id == i["id"]))
        devicesToSelect.add(
          SimpleDialogOption(
            child: Text((i["friendlyName"] ?? i["id"].toString()) + ": " + i["typeName"].toString()),
            onPressed: () async {
              await addDevice(i["Id"], i);
              Navigator.pop(context);
            },
          ),
        );
    }
    if (devicesToSelect.length > 1) {
      devicesToSelect.insert(
        0,
        SimpleDialogOption(
          child: Text("Subscribe to all"),
          onPressed: () async {
            for (var dev in serverDevices) {
              if (!DeviceManager.devices.any((x) => x.id == dev["id"])) await addDevice(dev["Id"], dev);
            }
            Navigator.pop(context);
          },
        ),
      );
    }

    var dialog = SimpleDialog(
      children: devicesToSelect,
      title: Text((devicesToSelect.length == 0 ? "No new Devices found" : "Add new Smarthome Device")),
    );
    showDialog(context: context, builder: (b) => dialog);
    setState(() {});
  }

  HubConnection createHubConnection() {
    var mainUrl = PreferencesManager.instance.getString("mainserverurl") ?? "";
    serverUrl = mainUrl == "" ? "http://192.168.49.56:5055/SmartHome" : mainUrl;
    return HubConnectionBuilder()
        .withUrl(
            serverUrl,
            HttpConnectionOptions(
                //accessTokenFactory: () async => await getAccessToken(PreferencesManager.instance),
                logging: (level, message) => print('$level: $message')))
        .withAutomaticReconnect(PermanentRetryPolicy())
        .build();
  }

  void refresh() {
    newHubConnection();
    setState(() {});
  }

  void addGroup() {
    var sd = SimpleDialogSingleInput.create(
        hintText: "Name der neuen Gruppe",
        labelText: "Name",
        acceptButtonText: "Erstellen",
        cancelButtonText: "Abbrechen",
        onSubmitted: (s) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => GroupDevices(MapEntry(s, []))));
        },
        title: "Neue Gruppe",
        context: context);
    showDialog(builder: (BuildContext context) => sd, context: context);
  }
}
