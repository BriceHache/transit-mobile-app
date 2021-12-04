import 'package:flutter/material.dart';


class ImageCircleAvatar extends StatelessWidget {
  
  final String photoUrl;
  final bool isOnline;

  const ImageCircleAvatar({
    Key key,
    @required this.photoUrl, 
    @required this.isOnline,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.only(left: 5),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child:
              photoUrl != '' ?
               CircleAvatar(
                radius: 60,
                
                  child: FadeInImage(
                  image: NetworkImage(photoUrl),
                  placeholder:  AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                ),
              ): CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue[400],
                child: Image(
                  image: AssetImage('assets/images/user_avatar.png'),
                ),
              )
            ),
            Positioned(
              bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.brightness_1,
                      color: isOnline ? Colors.green[300]: Colors.transparent,
                      size: 16,
                    )
            ),
        ],
      ),
    );
  }
}