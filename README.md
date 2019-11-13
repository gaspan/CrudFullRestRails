# README

## Technology
- ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-linux]
- Mysql
- Postman 

## SETTING YOUR OWN DATABASE
set it in folder config > databse.yml

## INSTALL DEPENDENCIES
```bash
$ bundle install
```

## CREATE DATABASE
```bash
$ rake db:create
```

## RUN MIGRATION
```bash
$ rake db:migrate
```

## MAKE DUMMY DATA
```bash
$ rake db:seed
```
## RUN SERVER
```bash
$ rails s
```

## Testing use Postman

import to your own Postman, import from link
[a link](https://www.getpostman.com/collections/21855a6c72c4900b43ab)

```
