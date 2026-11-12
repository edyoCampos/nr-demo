// Exercise 4: non-relational database (advanced queries)
// Uses the collection posts from exercise 3, so run exercise-3.js first.
// Runs against the orion_db database of the db_mongo service, and also against the dev and prod environments.

// 1. Update: add the field comentarios (an array of documents) to one of the posts.
print("--- 1. updateOne: add comentarios to a post");
printjson(
  db.posts.updateOne(
    { titulo: "Introdução ao MongoDB" },
    {
      $set: {
        comentarios: [
          { autor: "Ana Souza", texto: "Ótima introdução!" },
          { autor: "Beatriz Alves", texto: "Quando sai a próxima parte?" },
        ],
      },
    }
  )
);

// 2. Query inside an array: only the posts with the tag "nosql".
print("--- 2. find: posts with the tag nosql");
printjson(db.posts.find({ tags: "nosql" }).toArray());

// 3. Query by a specific author.
print("--- 3. find: posts by the author Carlos Lima");
printjson(db.posts.find({ autor: "Carlos Lima" }).toArray());

// 4. Query inside an array of nested documents: posts commented by a specific author.
print("--- 4. find: posts with a comment by Ana Souza");
printjson(db.posts.find({ "comentarios.autor": "Ana Souza" }).toArray());
