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

_Steps for uploading a new dataset to our production MongoDB database hosted on mLab_

1. Make sure that you have the new dataset ready on your local machine. You can use `JsonImporter` to import data from any .json files.

2. Run the following command. This will create a folder `dump` with a subfolder `viz`.
```
mongodump -d viz -c publications
```

3. Once you have obtained a dump of your local MongoDB database, run this command to upload it to mLab, replacing `<password>` with the appropriate password obtained from a teammate.
```
mongorestore -h ds243285.mlab.com:43285 -d heroku_9nszfk0s -c publications -u heroku_9nszfk0s -p <password> dump/viz/publications.bson
```
