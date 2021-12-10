import 'package:e_commerce/providers/auth.dart';
import 'package:e_commerce/providers/cart.dart';
import 'package:e_commerce/providers/order.dart';
import 'package:e_commerce/screens/16.1%20splash_screen.dart';
import 'package:e_commerce/screens/4.1%20auth_screen.dart';
import 'package:e_commerce/screens/cart_screen.dart';
import 'package:e_commerce/screens/edit_product_screen.dart';
import 'package:e_commerce/screens/orders_screen.dart';
import 'package:e_commerce/screens/product_details.dart';
import 'package:e_commerce/screens/product_overview_screen.dart';
import 'package:e_commerce/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/products.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[

          ChangeNotifierProvider(
          create:(context)=>Auth(),
        ),
        ChangeNotifierProxyProvider<Auth,Products>(
          create:(_)=>Products(),
          update:(context,auth,data)=>data!..update(auth.token,auth.userId),
        ),


      //     ChangeNotifierProvider(
      //     create:(context)=>Products(),
      // ),
          ChangeNotifierProvider(
          create:(context)=>Cart(),
      ),
      //     ChangeNotifierProvider(
      //     create:(context)=>Order(),
      // ),
      ChangeNotifierProxyProvider<Auth,Order>(
          create:(_)=>Order(),
          update:(context,auth,data)=>data!..update(auth.token,auth.userId),
        ),
    ],   
      child: Consumer<Auth>(
        builder: (context,auth,_)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:ThemeData(
          primarySwatch: Colors.purple, 
          ),
          home:auth.isAuth?ProductOverviewScreen():FutureBuilder(
            future: auth.tryAutoLogIn(),
            builder:(context,snapShot)=>snapShot.connectionState ==ConnectionState.waiting?SplashScreen() : AuthScreen(),
          
        ),
        routes: {
                  ProductDetails.routeName:(context)=>ProductDetails(),
                  CartScreen.routeName:(context)=>CartScreen(),
                  OrderScreen.routeName:(context)=>OrderScreen(),
                  UserProductScreen.routeName:(context)=>UserProductScreen(),
                  EditProductScreen.routeName:(context)=>EditProductScreen(),
          },
      ),
      )
    );
  }
}


