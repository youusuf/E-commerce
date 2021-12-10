import 'package:e_commerce/providers/auth.dart';
import 'package:e_commerce/providers/cart.dart';
import 'package:e_commerce/providers/product.dart';
import 'package:e_commerce/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    final authData = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap:(){
            Navigator.of(context).pushNamed(ProductDetails.routeName,arguments: product.id);
          },
          child: OctoImage.fromSet(
            
              fit: BoxFit.cover,
                 image: CachedNetworkImageProvider(
                  product.imageUrl!
               ),
                octoSet: OctoSet.circleAvatar(
                 backgroundColor: Colors.cyan.shade100,
                 text:const CircularProgressIndicator(color: Colors.blueGrey,),
                ),
                  ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder:(context,prod,child)=>IconButton(
              icon: Icon(
                product.isFavorite? Icons.favorite:Icons.favorite_border,
                color: Colors.red,
                ),
              onPressed:(){
                product.toggleFavorite(authData.token,authData.userId);
              },
            ),
            
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.red,
              ),
            onPressed:(){
                  cart.addItem(product.id, product.title, product.price);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: 
                   const Text(
                      "item Added to cart"
                      ),
                      duration:const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: "UNDO",
                         onPressed:(){
                           cart.removeSingleItem(product.id!);
                         }),

                    
                    )
                  
                  );

            },
          ),
          title: Text(
            product.title!,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}