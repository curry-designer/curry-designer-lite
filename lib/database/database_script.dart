Map<int, String> migrationScripts = {
  1: '''
        CREATE TABLE Recipe (
            id INTEGER PRIMARY KEY
        ,   name TEXT
        );
     ''',
  2: '''
        CREATE TABLE Version (
            id INTEGER
        ,   recipe_id INTEGER
        ,   updated_date_time TEXT
        ,   star_count INTEGER
        ,   comment TEXT
        ,   PRIMARY KEY (id, recipe_id)
        );
     ''',
  3: '''
        CREATE TABLE CurryMaterial (
            id INTEGER
        ,   recipe_id INTEGER
        ,   version_id INTEGER
        ,   material_name TEXT
        ,   material_amount TEXT
        ,   order_material INTEGER
        ,   PRIMARY KEY (id, recipe_id, version_id)
        );
     ''',
  4: '''
        CREATE TABLE HowToMake (
            id INTEGER
        ,   recipe_id INTEGER
        ,   version_id INTEGER
        ,   order_how_to_make INTEGER
        ,   how_to_make TEXT
        ,   PRIMARY KEY (id, recipe_id, version_id)
        );
     ''',
  // 5: 'ALTER TABLE Version ADD COLUMN updated_date_time TEXT;'
};
