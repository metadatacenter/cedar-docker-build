db["template-fields"].createIndex({ "@id": 1 }, { unique: true });
db["template-elements"].createIndex({ "@id": 1 }, { unique: true });
db["templates"].createIndex({ "@id": 1 }, { unique: true });
db["template-instances"].createIndex({ "@id": 1 }, { unique: true });
