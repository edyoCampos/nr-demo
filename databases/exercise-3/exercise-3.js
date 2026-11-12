// Exercise 3: non-relational database (basic CRUD)
// Runs against the orion_db database of the db_mongo service (see ../README.md).

// Drop the collection first so the script can be run again.
printjson({ dropped: db.posts.drop() });

// 1. Create the collection posts.
printjson(db.createCollection("posts"));

// 2. Create: a document with titulo, autor and conteudo.
printjson(
  db.posts.insertOne({
    titulo: "Introdução ao MongoDB",
    autor: "Carlos Lima",
    conteudo: "MongoDB guarda os dados em documentos JSON.",
  })
);

// 3. Flexible schema: a second document with a new field, tags (an array of strings).
printjson(
  db.posts.insertOne({
    titulo: "Schema flexível",
    autor: "Ana Souza",
    conteudo: "Documentos da mesma coleção podem ter campos diferentes.",
    tags: ["nosql", "flexivel"],
  })
);

// 4. Read: list all the documents of the collection posts.
printjson(db.posts.find().toArray());
