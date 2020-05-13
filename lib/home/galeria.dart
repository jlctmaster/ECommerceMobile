import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:biomercados/config.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Galeria extends StatefulWidget {
  final List galleryItems;
  final String imagenPrevia;
  const Galeria({Key key, this.galleryItems, this.imagenPrevia}) : super(key: key);

  @override
  _GaleriaState createState() => _GaleriaState();
}
class _GaleriaState extends State<Galeria> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            print("$BASE_URL/storage/"+widget.galleryItems[index]);
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage("$BASE_URL/storage/"+widget.galleryItems[index], ),//AssetImage(),
              initialScale: PhotoViewComputedScale.contained * 1.1,
              //heroAttributes: HeroAttributes(tag: widget.galleryItems[index].id),
            );
          },
          itemCount: widget.galleryItems.length,
          loadingBuilder: (context, event) =>
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[

                    CachedNetworkImage(
                      //  color: Colors.white,
                      height: 200,
                      fit: BoxFit.cover,
                      imageUrl: widget.imagenPrevia,

                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator()
                      ),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 180,left: 290),
                      child: Text("HD",style: TextStyle(color: Colors.black45),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 180,left: 290),
                      child: Center(child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes,
                      ),),
                    )
                    ,
                  ],
                )

              ),
          backgroundDecoration: BoxDecoration(color: Colors.white),

          // pageController: widget.pageController,
          // onPageChanged: onPageChanged,
        )
    );
  }
}