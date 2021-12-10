import 'package:e_commerce/providers/cart.dart';
import 'package:e_commerce/providers/products.dart';
import 'package:e_commerce/screens/cart_screen.dart';
import 'package:e_commerce/widgets/app_drawer.dart';
import 'package:e_commerce/widgets/badge.dart';
import 'package:e_commerce/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
enum selectedValue{
  seeAll,
  onlyFavorite
}
class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}
class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showOnlyFavorite = false;
  var isInit = true;
  var isLoading = false;
  // Future<void>getData()async{
  //    setState(() {
  //         isLoading = true;
  //       });
  //     try{      
  //       await Provider.of<Products>(context).fetchAndSetProducts();
  //     }catch(error){
  //       await showDialog(context: context, builder:(context){
  //             return AlertDialog(
  //               title:const Text('An error occurred'),
  //               content:const Text("Something went wrong"),
  //               actions: [
  //                 TextButton(onPressed:(){
  //                   Navigator.pop(context);
  //                 }, 
  //                 child:const Text("Okay")
  //                 )
  //               ],
  //             );
  //           }      
  //           );
  //     }finally{
  //       setState(() {
  //         isLoading = false;
  //       });
  //       Navigator.of(context).pop();
  //     }  
  // }
  // @override
  // void initState() {
  //   getData();
  //   super.initState();
  // }

@override
  void didChangeDependencies() {
    if(isInit){
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_){
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text("Shop App"),
        actions: [
          PopupMenuButton(
            onSelected:(selectedValue value){
              setState(() {
                    if(value==selectedValue.onlyFavorite){
                showOnlyFavorite = true;
              }
              else{
                  showOnlyFavorite = false;
              }
              });
            },
            itemBuilder:(_)=>[
              const PopupMenuItem(
                  child: Text('See All'), 
                  value: selectedValue.seeAll
                  ),
              const PopupMenuItem(
                  child: Text('Only Favorite'),
                   value: selectedValue.onlyFavorite
                   ),
            ],
          ),
          Consumer<Cart>(
            builder:(_,cart,ch)=>Badge(
              child: ch!,
               value:cart.totalItem.toString()
               ),
               child: IconButton(
                 icon:const Icon(Icons.shopping_cart) ,
                 onPressed:(){
                   Navigator.of(context).pushNamed(CartScreen.routeName);
                 },
                 ),
          ),
        ],
      ),
      body: isLoading?const Center(child: CircularProgressIndicator(),): 
      ProductGrid(showOnlyFavorite)
      //ProductGrid(showOnlyFavorite),
    );
  }
}