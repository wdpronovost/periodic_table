# Instructions

You are started with a `periodic_table` database that has information about some chemical elements. You can connect to it via the terminal by entering

    psql --username=freecodecamp --dbname=periodic_table

You may want to get a little familiar with the existing tables, columns, and rows. Read the instructions below and complete user stories to finish the project. Certain tests may not pass until other user stories are complete. Good luck!

## Part 1: Fix the `database`

There are some mistakes in the database that need to be fixed or changed. See the user stories below for what to change.

## Part 2: Create your `git` repository

You need to make a small bash program. The code needs to be version controlled with `git`, so you will need to turn the suggested folder into a git repository.

## Part 3: Create the `script`

Lastly, you need to make a script that accepts an argument in the form of an `atomic number`, `symbol`, or `name` of an element and outputs some information about the given element.

**Notes:**

If you leave your virtual machine, your database may not be saved. You can make a dump of it by entering the command below in a `bash` terminal

    pg_dump -cC --inserts -U freecodecamp periodic_table > periodic_table.sql

It will save the commands to rebuild your database in `periodic_table.sql`. The file will be located where the command was entered. If it's anything inside the project folder, the file will be saved in the VM. You can rebuild the database by entering the following command in a terminal where the `sql` file is located.

    psql -U postgres < periodic_table.sql

If you are saving your progress on [FreeCodeCamp](freeCodeCamp.org), after getting all the tests to pass, follow the instructions above to save a dump of your database. Save the `periodic_table.sql` file, as well as the final version of your `element.sh` file, in a public repository and submit the URL to it on [FreeCodeCamp](freeCodeCamp.org).

### Complete the tasks below

* You should rename the `weight` column to `atomic_mass`

        ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;

* You should rename the `melting_point` column to `melting_point_celsius` and the `boiling_point` column to `boiling_point_celsius`

        ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
        ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

* Your `melting_point_celsius` and `boiling_point_celsius` columns should **not** accept `null` values

        ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
        ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

* You should add the `UNIQUE` constraint to the `symbol` and `name` columns from the elements table

        ALTER TABLE elements ADD UNIQUE (symbol, name);

* Your `symbol` and `name` columns should have the `NOT NULL` constraint

        ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
        ALTER TABLE elements ALTER COLUMN name SET NOT NULL;

* You should set the `atomic_number` column from the `properties` table as a `foreign key` that references the column of the same name in the `elements` table

        ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number);

* You should create a `types` table that will store the three types of elements

  * Your `types` table should have a `type_id` column that is an `integer` and the `primary key`

  * Your `types` table should have a `type` column that's a `VARCHAR` and **cannot be `null`**. It will store the different types from the `type` column in the `properties` table

        CREATE TABLE types(type_id INT PRIMARY KEY, type VARCHAR(30) NOT NULL);

* You should add three rows to your `types` table whose values are the three different types from the `properties` table

        INSERT INTO types(type_id, type) VALUES(...);

* Your `properties` table should have a `type_id` foreign key column that references the `type_id` column from the `types` table. It should be an `INT` with the `NOT NULL` constraint

  * Each row in your `properties` table should have a `type_id` value that links to the correct `type` from the `types` table

  * Your `properties` table should not have a `type` column

        UPDATE properties SET type = 1 WHERE type = 'nonmetal';

        UPDATE properties SET type = 2 WHERE type = 'metal';

        UPDATE properties SET type = 3 WHERE type = 'metalloid';

        ALTER TABLE properties RENAME COLUMN type TO type_id;

        ALTER TABLE properties ALTER COLUMN type_id TYPE INT USING type_id::integer;

        ALTER TABLE properties ADD FOREIGN KEY (type_id) REFERENCES types(type_id);

* You should **capitalize the first letter** of all the `symbol` values in the `elements` table. Be careful to only capitalize the letter and not change any others

        UPDATE elements SET symbol = initcap(symbol);

* You should **remove all the trailing zeros** after the decimals from each row of the `atomic_mass` column. You may need to adjust a data type to `DECIMAL` for this. Be careful not to change the value

        ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;

        UPDATE properties SET atomic_mass = TRIM(TRAILING '0' FROM atomic_mass::text)::numeric;

* You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal

        INSERT INTO elements(atomic_number, symbol, name) VALUES(9, 'F', 'Fluorine');

        INSERT INTO properties(atomic_number, type_id, atomic_mass, melting_point_celsius, boiling_point_celsius) VALUES(9,1,18.998, -220, -188.1);

* You should add the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal

        INSERT INTO elements(atomic_number, symbol, name) VALUES(10, 'Ne', 'Neon');

        INSERT INTO properties(atomic_number, type_id, atomic_mass, melting_point_celsius, boiling_point_celsius) VALUES(10,1,20.18,-248.6, -246.1);

* You should delete the non existent element, whose `atomic_number` is `1000`, from the two tables

        DELETE FROM properties WHERE atomic_number=1000;
        DELETE FROM elements WHERE atomic_number=1000;

* You should create a `periodic_table` folder in the project folder and turn it into a `git repository` with `git init`

        mkdir periodic_table
        cd periodic_table
        git init

* Your repository should have a `main` branch with all your commits

        git checkout -b main

* You should create an `element.sh` file in your repo folder for the program I want you to make

        touch element.sh

* Your script (`.sh`) file should have executable permissions

        chmod +x element.sh

* If you run `./element.sh`, it should output `Please provide an element as an argument.` and finish running.

        if [[ -z $1 ]]
        then
            echo Please provide an element as an argument.
        else
            STATEMENTS
        fi

* If you run `./element.sh 1`, `./element.sh H`, or `./element.sh Hydrogen`, it should output the element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.

  * If you run `./element.sh` script with another element as input, you should get the same output but with information associated with the given element.

  * If the argument input to your `element.sh` script doesn't exist as an `atomic_number`, `symbol`, or `name` in the database, the output should be `I could not find that element in the database.`

* Your `periodic_table` repo should have at least **five** commits

  * The message for the `first` commit in your repo should be `Initial commit`

  * The rest of the commit messages should start with `fix:`, `feat:`, `refactor:`, `chore:`, or `test:`

* You should finish your project while on the `main` branch. Your working tree should be clean and you should not have any uncommitted changes
