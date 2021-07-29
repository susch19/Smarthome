import 'dart:convert';
import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'dart:async';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/simple_dialog_single_input.dart';
import 'package:flutter/foundation.dart';
import 'package:smarthome/session/cert_file.dart';
import 'package:smarthome/session/requests.dart';
import 'package:smarthome/session/responses.dart';
import 'package:smarthome/syncfusion.dart';
import 'package:http/http.dart' as http;
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() async {
  SyncFusionLicense.registerLicense();
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode));
}

class MyApp extends StatelessWidget {
  MyApp(this.savedThemeMode);

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
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
  final widgets = <Widget>[];
  // var devices = List<Device>();
  var serverUrl = "http://192.168.49.56:5055/smarthome";
  late SharedPreferences prefs;
  ForInput urlAddressInput = new ForInput();
  IconData? infoIcon;
  late HubConnection hubConnection;
  CertFile? certFile;

  @override
  void initState() {
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

  dynamic subscribeToDevive(List<int?> deviceIds) async => await hubConnection.invoke("Subscribe", args: [deviceIds]);

  Future doStuff() async {
    setState(() {
      infoIcon = Icons.refresh;
    });
    prefs = await SharedPreferences.getInstance();
    // certFile = await loadCertFile(prefs);
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
      var ids = <int?>[];
      for (var key in prefs.getKeys().where((x) => x.startsWith("SHD"))) {
        var id = prefs.getInt(key);
        ids.add(id);
      }
      var subs = await subscribeToDevive(ids);

      for (var id in ids) {
        var sub = subs.firstWhere((x) => x["id"] == id, orElse: () => null);
        var type = prefs.getString("Type" + id.toString());
        BaseModel model = DeviceManager.jsonFactory[type!]!(jsonDecode(prefs.getString("Json" + id.toString())!));
        model.isConnected = false;

        model.friendlyName += "(old)";
        if (sub != null) {
          model = DeviceManager.jsonFactory[type]!(sub);
          try {
            var dev = DeviceManager.ctorFactory[type]!(id, model, hubConnection, prefs);
            DeviceManager.devices.add(dev as Device<BaseModel>);
          } catch (e) {}
        } else {
          var dev = DeviceManager.ctorFactory[type]!(id, model, hubConnection, prefs);
          DeviceManager.devices.add(dev as Device<BaseModel>);
          DeviceManager.notSubscribedDevices.add(dev);
          DeviceManager.subToNonSubscribed(hubConnection);
        }
      }
      DeviceManager.currentSort = SortTypes.values[prefs.getInt("SortOrder") ?? 0];
      DeviceManager.sortDevices(prefs);
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

  Widget buildBody() {
    return RefreshIndicator(
      child: ConstrainedBox(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return StaggeredGridView.extentBuilder(
                maxCrossAxisExtent: 260,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                itemCount: DeviceManager.devices.length,
                itemBuilder: (context, i) => Card(
                      child: GestureDetector(
                        child: MaterialButton(
                          padding: EdgeInsets.all(5.0),
                          child: DeviceManager.devices[i].dashboardView(),
                          onPressed: () => DeviceManager.devices[i].navigateToDevice(context),
                        ),
                        onLongPress: () {
                          deviceAction(DeviceManager.devices[i]);
                          setState(() {});
                        },
                        onTapDown: (q) => print(i),
                      ),
                    ),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1));
            // itemCount: DeviceManager.devices.length,
            // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //   maxCrossAxisExtent: 220,
            //   // crossAxisSpacing: 2.0,
            //   // mainAxisSpacing: 2.0,
            //   // childAspectRatio: DeviceManager.showDebugInformation ? 1.0 : 1.49,
            // ),

            // );
            // return GridView.count(
            //     padding: EdgeInsets.only(top: 16.0),
            //     crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
            //     childAspectRatio: 1.8,
            //     shrinkWrap: true,
            //     children: DeviceManager.devices
            //         .map((x) => GestureDetector(
            //               child: MaterialButton(
            //                 child: x.dashboardView(),
            //                 onPressed: () => x.navigateToDevice(context),
            //               ),
            //               onLongPress: () {
            //                 deviceAction(x);
            //                 setState(() {});
            //               },
            //             ))
            //         .toList(growable: true));
          },
        ),
        constraints: BoxConstraints.tight(Size.infinite),
      ),
      onRefresh: () async {
        newHubConnection();
        setState(() {});
        return null;
      },
    );
  }

  Future addDevice(int? id, dynamic device) async {
    DeviceManager.devices.add(DeviceManager.ctorFactory[device["typeName"]]!(
            device["id"], DeviceManager.jsonFactory[device["typeName"]]!(device), hubConnection, prefs)
        as Device<BaseModel>);
    prefs.setInt("SHD" + device["id"].toString(), device["id"]);
    prefs.setString("Json" + device["id"].toString(), jsonEncode(device));
    prefs.setString("Type" + device["id"].toString(), device["typeName"]);

    await subscribeToDevive([device["id"]]);
    DeviceManager.sortDevices(prefs);
    setState(() {});
  }

  void removeDevice(Device d) {
    DeviceManager.devices.remove(d);
    prefs.remove("SHD" + d.id.toString());
    prefs.remove("Json" + d.id.toString());
    prefs.remove("Type" + d.id.toString());
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Home App"),
        leading: Icon(infoIcon),
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
              PopupMenuItem<String>(value: 'Debug', child: Text("Toggle Debug")),
              PopupMenuItem<String>(value: 'RemoveAll', child: Text("Entferne alle Geräte")),
            ],
          )
        ],
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(icon: Icon(Icons.add), onPressed: addNewDevice),
      ),
    );
  }

  void selectedOption(String value) {
    switch (value) {
      case "URL":
        var sd = SimpleDialogSingleInput.create(
            hintText: "URL of LED Strip",
            labelText: "URL",
            defaultText: serverUrl,
            onSubmitted: (s) {
              serverUrl = s;
              prefs.setString("mainserverurl", s);
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
        AdaptiveTheme.of(context).toggleThemeMode();

        break;
      case "RemoveAll":
        for (int i = DeviceManager.devices.length - 1; i >= 0; i--) {
          var d = DeviceManager.devices.removeAt(i);
          prefs.remove("SHD" + d.id!.toString());
          prefs.remove("Json" + d.id!.toString());
          prefs.remove("Type" + d.id!.toString());
        }
        setState(() {});
        break;
    }
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

    setState(() => DeviceManager.sortDevices(prefs));
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

  Future addNewDevice() async {
    Device? choosen;
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
    showDialog(context: context, builder: (b) => dialog).then((x) {
      if (choosen != null)
        setState(
          () => widgets.add(
            MaterialButton(
              child: Column(
                children: <Widget>[
                  choosen,
                ],
              ),
              onPressed: () {},
            ),
          ),
        );
    });
    setState(() {});
  }

  HubConnection createHubConnection() {
    var mainUrl = prefs.getString("mainserverurl") ?? "";
    serverUrl = mainUrl == "" ? "http://192.168.49.56:5055/SmartHome" : mainUrl;
    return HubConnectionBuilder()
        .withUrl(
            serverUrl,
            HttpConnectionOptions(
                //accessTokenFactory: () async => await getAccessToken(prefs),
                logging: (level, message) => print('$level: $message')))
        .build();
  }

  Future<String?> getAccessToken(SharedPreferences prefs) async {
    var lastTime = prefs.getInt("TokenGetTime")!;

    if (DateTime.fromMillisecondsSinceEpoch(lastTime).add(Duration(days: 10)).millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      var res = (await (post(
          certFile!.serverUrl, "/session", UserLoginArgs(certFile!.username, certFile!.email, certFile!.pw))));
      if (res?.statusCode == 200) {
        UserLoginResult tokenRes = jsonDecode(res?.body ?? "{}");
        prefs.setInt("TokenGetTime", DateTime.now().millisecondsSinceEpoch);
        prefs.setString("Token", tokenRes.token!);
        return tokenRes.token;
      }
    } else
      return prefs.getString("Token");

    return "";
  }

  // Future<String> getAccessTokenNewFile(SharedPreferences prefs) async {
  //   var file =
  //       (await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["smarthome"])).files.first;
  //   prefs.setString("ServerTokenFileLocation", file.path);
  //   return getAccessToken(prefs);
  // }

  // Future<CertFile> loadCertFile(SharedPreferences prefs) async {
  //   var location = prefs.getString("ServerTokenFileLocation");
  //   if (location?.isEmpty ?? false) {
  //     var file =
  //         (await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["smarthome"])).files.first;
  //     location = file.path;
  //     prefs.setString("ServerTokenFileLocation", location);
  //   }
  //   if (location == null) {
  //     return null;
  //   }
  //   var cert = File(location);
  //   var lines = await cert.readAsLines();
  //   return CertFile(lines[0], lines[1], lines[2], lines[3]);
  // }

  static Future<http.Response?> post(String url, String path, [Object? body]) async {
    var g = http.post(Uri(path: "$url/$path"), body: jsonEncode(body), headers: {"Content-Type": "application/json"});
    http.Response? res;
    await g.then((x) => res = x);
    return res;
  }
}
