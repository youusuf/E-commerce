import 'package:e_commerce/providers/products.dart';
import 'package:e_commerce/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class UserProductWidget extends StatelessWidget {

    

  final String? id;
  final String? title;
  final String? imageUrl;
  UserProductWidget(
    this.id,
    this.title,
    this.imageUrl
    );

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title!),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl!),      
      ),
    trailing: SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
           onPressed:(){
             Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
           },
           icon: const Icon(Icons.edit)
           ),
            IconButton(
           onPressed:()async{
             try{
                  await  Provider.of<Products>(context,listen: false).deleteProduct(id!);
             }catch(error){
               scaffold.showSnackBar(SnackBar(content: Text("Deleting Failed")));

             }
             
           },
           icon: const Icon(Icons.delete)
           ),
        ],
      ),
    )
    );
  }
}