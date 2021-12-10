import 'package:e_commerce/providers/auth.dart';
import 'package:e_commerce/screens/orders_screen.dart';
import 'package:e_commerce/screens/product_overview_screen.dart';
import 'package:e_commerce/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title:const Text("Options"),
          ),
         const Divider(),
          ListTile(
           title:const Text('Shop'),
           leading:const Icon(Icons.shop),
           onTap:(){
             Navigator.of(context).pushReplacementNamed('/');
           //Navigator.push(context,MaterialPageRoute(builder:(context)=>ProductOverviewScreen()));
           },
          ),
          const Divider(),
          ListTile(
           title: const Text('Orders'),
           leading: const Icon(Icons.payment),
           onTap:(){
            // Navigator.push(context,MaterialPageRoute(builder:(context)=>OrderScreen()));
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
           },
          ),
          const Divider(),
          ListTile(
           title: const Text('Manage Product'),
           leading: const Icon(Icons.edit),
           onTap:(){
             //Navigator.push(context,MaterialPageRoute(builder:(context)=>UserProductScreen()));
           Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
           },
          ),
          const Divider(),
          ListTile(
           title:const Text('Log Out'),
           leading:const Icon(Icons.exit_to_app),
           onTap:(){
             Navigator.of(context).pop();
             Navigator.of(context).pushReplacementNamed('/');
             Provider.of<Auth>(context,listen: false).logOut();
           },
          ),

        ],
      ),
    );
  }
}