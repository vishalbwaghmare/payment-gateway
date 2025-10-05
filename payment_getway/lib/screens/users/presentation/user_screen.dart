import 'package:flutter/material.dart';

import '../models/database_helper.dart';
import '../models/user.dart';
import 'add_user.dart';

class UserScreen extends StatefulWidget{
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>{
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final userMap = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      _users = userMap.map((user) => User.fromMap(user)).toList();
    });
  }

  Future<void> _deleteUser(int id) async {
    await DatabaseHelper.instance.deleteUser(id);

    final userMaps = await DatabaseHelper.instance.queryAllUsers();

    setState(() {
      _users = userMaps.map((userMap) => User.fromMap(userMap)).toList();
    });
  }


  Future<void> _showAddUserDialog() async {
    final added = await showDialog<bool>(
      context: context,
      builder: (context) => AddUser(),
    );

    if (added == true) {
      _fetchUsers(); // Refresh user list
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Users"),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black12,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: (){
                _showAddUserDialog();
              }, child: Text("Add user")),
              SizedBox(width: 16,)
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context , index){
                return ListTile(
                  hoverColor: Colors.white,
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  trailing: IconButton(onPressed: (){
                    setState(() {
                      _deleteUser(_users[index].id!);
                    });
                  },
                    color: Colors.redAccent,
                    icon: Icon(Icons.delete),
                  ),
                  title: Text(_users[index].username),
                  subtitle: Text(_users[index].email),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}