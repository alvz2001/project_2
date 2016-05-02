require 'bundler/setup'
require 'pg'
require 'pry'
require 'faker'


if ENV["RACK_ENV"] == "production"
    conn = PG.connect(
        dbname: ENV["POSTGRES_DB"],
        host: ENV["POSTGRES_HOST"],
        password: ENV["POSTGRES_PASS"],
        user: ENV["POSTGRES_USER"]
     )
else
    conn = PG.connect(dbname: "travel")
end



conn.exec("DROP TABLE IF EXISTS places")
conn.exec("DROP TABLE IF EXISTS categories")
conn.exec("DROP TABLE IF EXISTS users")

conn.exec("CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
  )")

conn.exec("INSERT INTO users (email, password) VALUES (
    'alvz2001@yahoo.com',
    'hey'
  )"
)

conn.exec("INSERT INTO users (email, password) VALUES (
    'alvin@aol.com',
    'hello'
  )"
)

conn.exec("INSERT INTO users (email, password) VALUES (
    'brett@aol.com',
    'never'
  )"
)

conn.exec("CREATE TABLE threads(
  id SERIAL PRIMARY KEY,
  topic VARCHAR(255),
  user_id INTEGER REFERENCES users(id)
  )"
)


# conn.exec("CREATE TABLE categories(
#     id SERIAL PRIMARY KEY,
#     name VARCHAR(255) NOT NULL
#   )");


# conn.exec("INSERT INTO categories (name) VALUES (
#    'Places to visit'
#   )"
#   )


# conn.exec("INSERT INTO categories (name) VALUES (
#    'Places visited'
#   )"
#   )

# conn.exec("INSERT INTO categories (name) VALUES (
#    'Favorite place'
#   )"
#   )




# conn.exec("CREATE TABLE places(
#     id SERIAL PRIMARY KEY,
#     category_id INTEGER REFERENCES categories(id),
#     user_id INTEGER REFERENCES users(id),
#     name VARCHAR(255) NOT NULL,
#     date_of_visit VARCHAR(255) NOT NULL,
#     description TEXT NOT NULL
#   )");

# conn.exec("INSERT INTO places (category_id, user_id, name, date_of_visit, description) VALUES (
#    '1',
#    '1',
#    'Los Angeles',
#    'May 5, 1999',
#    'Very sunny and many palm trees'
#   )"
#   )

# conn.exec("INSERT INTO places (category_id, user_id, name, date_of_visit, description) VALUES (
#    '2',
#    '2',
#    'New York',
#    'April 23, 2000',
#    'Very windy and brisk, many tall buildings'
#   )"
#   )



