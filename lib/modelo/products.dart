class Products {
  int id;
  String name;
  String precio;
  String image;
  double rating;
  String description_short;
  String evento='listarProductos';
  String calificado_por_mi;
  double precioDolar;
  double precioBolivar;
  int stock;
  int promocion;
  int pedidoMax;
  String image_previa;

  Products({this.image_previa,this.name='', this.precio='', this.image='', this.rating=0.00,this.description_short='',this.id,this.evento,this.calificado_por_mi,this.precioBolivar,this.precioDolar,this.stock,this.pedidoMax,this.promocion});
}