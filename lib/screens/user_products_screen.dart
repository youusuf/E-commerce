import 'package:e_commerce/screens/edit_product_screen.dart';
import 'package:e_commerce/widgets/app_drawer.dart';
import 'package:e_commerce/widgets/user_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/providers/products.dart';
class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen'; 
  const UserProductScreen({Key? key}) : super(key: key);
  Future<void> getData(BuildContext context)async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }
  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title:const Text("Manage Products"),
        actions: [
          IconButton(onPressed: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProductScreen()));
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
          },
           icon:const Icon(Icons.add)
           )
        ],
      ),
      body: FutureBuilder(
        future: getData(context),
        builder:(context,snapShot)=>snapShot.connectionState==ConnectionState.waiting?const Center(child: CircularProgressIndicator(),): RefreshIndicator(
          onRefresh:(){
            return getData(context);
          },
          child: Consumer<Products>(
            builder: (context,product,_)=>Padding(
            padding:const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: product.item.length,
              itemBuilder:(context,index){
                return Column(
                  children: [
                    UserProductWidget(
                      product.item[index].id!,
                      product.item[index].title!,
                      product.item[index].imageUrl!
                    ),
                    const Divider(),
                  ],
                );
              },
        
            ),
          ),

          ),
        ),
      ),

    );
  }
}
