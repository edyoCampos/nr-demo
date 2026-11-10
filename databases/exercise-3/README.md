# Exercise 3: Non-relational database (basic CRUD)

Create the `posts` collection in MongoDB, insert two documents with different structures to show the flexible schema, and list them with `find()`.

## How to run

Start the environment first (see [databases/README.md](../README.md)), then run from this folder:

```bash
docker exec -i orion_mongo_db mongosh "mongodb://orion_admin:orion_admin_pass@localhost:27017/orion_db?authSource=admin" --quiet --file /dev/stdin < exercise-3.js
```

The script connects to the `orion_db` database as `orion_admin` (`authSource=admin`) and reads the file from stdin through `--file /dev/stdin`, so nothing is copied into the container. It drops the collection first, so it can be run again at any time.

Passing the script as plain stdin (`mongosh ... < exercise-3.js`) also works, but the output is mixed with the interactive prompts.

## Results

### Collection and inserts

`exercise-3.js` creates the collection `posts`, inserts a document with `titulo`, `autor` and `conteudo`, then a second one with the extra field `tags`, and ends with the `find()` listing.

![Creating the collection and inserting the documents](01-create-and-insert.png)

### find()

`find()` returns both documents. The second one has the field `tags` and the first one does not, so the collection accepted two different structures.

![find() on posts](02-find-posts.png)
