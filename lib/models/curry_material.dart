class CurryMaterial {
  // Constructor.
  CurryMaterial({
    this.id,
    this.recipeId,
    this.versionId,
    this.materialName,
    this.materialAmount,
    this.orderMaterial,
  });

  factory CurryMaterial.fromDatabaseJson(Map<String, dynamic> data) =>
      CurryMaterial(
        id: data['id'] as int,
        recipeId: data['recipe_id'] as int,
        versionId: data['version_id'] as int,
        materialName: data['material_name'] as String,
        materialAmount: data['material_amount'] as String,
        orderMaterial: data['order_material'] as int,
      );

  final int id;
  final int recipeId;
  final int versionId;
  final String materialName;
  final String materialAmount;
  final int orderMaterial;

  // Getter.
  int get getId => id;
  int get getRecipeId => recipeId;
  int get getVersionId => versionId;
  String get getMaterialName => materialName;
  String get getMaterialAmount => materialAmount;
  int get getOrderMaterial => orderMaterial;
}
