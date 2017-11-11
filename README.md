# Simon Says: Backend

## Setup

1. _(Optional)_ Install a ruby version manager such as `rvm` or `rbenv`
1. Install ruby 2.4.1 (You may do `rvm install 2.4.1` or `rbenv install 2.4.1`)
1. Install `mongodb`
1. Clone the git repo and `cd` into it.
1. `gem install bundler`
1. `bundle`
1. Obtain a copy of `output.json` (~500 MB) from a teammate and place it in the same folder as your cloned repo. Make sure to do this in the top-level folder and not in any subfolders.
1. `rails c` followed by `JsonImporter.import`

## Populating the hosted DB

```
mongodump -d viz -c publications
```

This will create a folder `dump` with a subfolder `viz`.

```
mongorestore -h ds243285.mlab.com:43285 -d heroku_9nszfk0s -c publications -u heroku_9nszfk0s -p <password> dump/viz/publications.bson
```

Replacing `<password>` with the appropriate password obtained from a teammate.

## API

### Citation Web
https://simon-says-backend.herokuapp.com/api/citation_web?title=Low-density%20parity%20check%20codes%20over%20GF(q)

_TODO_
