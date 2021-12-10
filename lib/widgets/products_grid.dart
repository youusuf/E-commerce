import 'package:e_commerce/providers/products.dart';
import 'package:e_commerce/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductGrid extends StatelessWidget {
  final bool showfav;
  ProductGrid(this.showfav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final product = showfav ?productsData.favorite: productsData.item;
    return GridView.builder(
      shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        itemCount: product.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
        ),
       itemBuilder:(context,index){
         return ChangeNotifierProvider.value(
           value: product[index],
          // create:(context)=>,
           child: ProductItem(
             
           ),
         );
       }
       );
  }
}