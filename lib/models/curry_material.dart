class CurryMaterial {
  final int id;
  final int recipeId;
  final int versionId;
  final String materialName;
  final String materialAmount;
  final int orderMaterial;

  // Constructor.
  CurryMaterial({
    this.id,
    this.recipeId,
    this.versionId,
    this.materialName,
    this.materialAmount,
    this.orderMaterial,
  });

  // Getter.
  int get getId => id;
  int get getRecipeId => recipeId;
  int get getVersionId => versionId;
  String get getMaterialName => materialName;
  String get getMaterialAmount => materialAmount;
  int get getOrderMaterial => orderMaterial;

  factory CurryMaterial.fromDatabaseJson(Map<String, dynamic> data) =>
      CurryMaterial(
        id: data['id'],
        recipeId: data['recipe_id'],
        versionId: data['version_id'],
        materialName: data['material_name'],
        materialAmount: data['material_amount'],
        orderMaterial: data['order_material'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "recipe_id": this.recipeId,
        "version_id": this.versionId,
        "material_name": this.materialName,
        "material_amount": this.materialAmount,
        "order_material": this.orderMaterial,
      };
}
