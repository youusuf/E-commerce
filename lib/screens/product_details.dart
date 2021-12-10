import 'package:e_commerce/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product-details';

  const ProductDetails({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    var productId = ModalRoute.of(context)!.settings.arguments as String;
    final productData = Provider.of<Products>(context,listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productData.title!
        ),
      ),
      body: Column(
        
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child:Image.network(
              productData.imageUrl!,
              fit: BoxFit.cover,
            )
          ),
         const SizedBox(height: 10,),
          SizedBox(
            child: Text(
             "\$${productData.price}",
             style: const TextStyle(
               fontSize: 30
             ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Text(
               "${productData.description}",
               style: const TextStyle(
                 fontSize: 16
               ),
              ),
            ),
          ),

          
        ],
      ),
    );
  }
}