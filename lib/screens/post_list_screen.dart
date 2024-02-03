import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:session13_api/models/post_model.dart';
import 'package:http/http.dart' as http;

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {

  Future<List<PostModel>> getAllPostsFromApi() async{

    List<PostModel> posts = [];

    String url = 'https://jsonplaceholder.typicode.com/posts';

    http.Response response = await http.get(Uri.parse(url));

    if( response.statusCode == 200 ){

      var jsonResponse = jsonDecode(response.body);

      for( var jsonPost in jsonResponse){

        PostModel postModel = PostModel.fromJson(jsonPost);
        posts.add(postModel);
      }

      return posts;

    }else{
      throw Exception('Something went wrong');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),

      body: FutureBuilder<List<PostModel>>(

        future: getAllPostsFromApi(),
        builder: (context, snapshot){

          if( snapshot.hasData){

            List<PostModel> posts = snapshot.data!;

            return ListView.builder(
                itemCount: posts.length ,
                itemBuilder: (context, index){

                  PostModel postModel = posts[index];

                  return Card(
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('User ID ${postModel.userId}'),
                          Text('ID ${postModel.id}'),
                          Text(postModel.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 40),),
                          Divider(),
                          Text(postModel.body!),
                        ],
                      ),
                    ),
                  );
            });



          }else if( snapshot.hasError){
            return const Center(child: Text('Something went wrong'),);

          }else{
            return const Center(child: SpinKitPouringHourGlass(color: Colors.blue),);

          }
        },
      ),
    );
  }
}
