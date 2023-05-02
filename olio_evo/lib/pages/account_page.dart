import 'package:flutter/material.dart';
import 'package:olio_evo/pages/dashboard_page.dart';
import 'package:olio_evo/shared_service.dart';
import 'package:olio_evo/widgets/unauth_widget.dart';

import '../models/login_model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class OptionList {
  String optionTitle;
  String optionSubTitle;
  IconData optionIcon;
  Function onTap;

  OptionList(
      {this.optionIcon, this.optionTitle, this.optionSubTitle, this.onTap});
}

class _AccountPageState extends State<AccountPage> {
  List<OptionList> options = List<OptionList>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    options.add(
      OptionList(
          optionIcon: Icons.shopping_cart,
          optionTitle: "Orders",
          optionSubTitle: "Check my orders",
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardPage()));
          }),
    );
    options.add(
      OptionList(
          optionIcon: Icons.edit,
          optionTitle: "Edit Profile",
          optionSubTitle: "Update your profile",
          onTap: () {}),
    );
    options.add(
      OptionList(
          optionIcon: Icons.logout_sharp,
          optionTitle: "Sign out",
          optionSubTitle: "",
          onTap: () {
            SharedService.logout().then((value) => {setState(() {})});
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedService.isLoggedIn(),
        // ignore: missing_return
        builder: (
          BuildContext context,
          AsyncSnapshot<bool> loginModel,
        ) {
          if (loginModel.hasData) {
            if (loginModel.data != null && loginModel.data) {
              return _listView(context);
            } else {
              return const UnAuthWidget();
            }
          } else {
            return const Text("No data");
          }
        });
  }

  Widget _buildRow(OptionList optionList, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(optionList.optionIcon, size: 30),
        ),
        // ignore: void_checks
        onTap: () {
          return optionList.onTap();
        },
        title: Text(
          optionList.optionTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            optionList.optionSubTitle,
            style: const TextStyle(color: Colors.redAccent, fontSize: 14),
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return FutureBuilder(
      future: SharedService.loginDetails(),
      builder:
          (BuildContext context, AsyncSnapshot<LoginResponseModel> loginModel) {
        if (loginModel.hasData) {
          return ListView(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, ${loginModel.data.data.displayName}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                itemCount: options.length,
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: _buildRow(options[index], index),
                  );
                },
              )
            ],
          );
        }

        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Login model has no data"),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                SharedService.logout().then((value) => {setState(() {})});
              },
            )
          ],
        ));
      },
    );
  }
}
