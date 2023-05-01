## Requires:
- heroku cli

## Deploy:
- delete Gemfile.lock
- run `bundle install`
- run `bundle lock --add-platform x86_64-linux` bc otherwise only ["arm64-darwin-21"] error
    - needs to give the following output:
    - Fetching gem metadata from https://rubygems.org/.........
    - Resolving dependencies.......
    - Writing lockfile to /Users/paulazhu/coding/college-arch-api/Gemfile.lock
- `heroku ps:scale web=1`
- `git add .`, `git commit "msg"` to actually commit changes
- `git push origin master` if needed
- `git push -f heroku master`

To troubleshoot heroku:
- `heroku run console -a college-arch-api`

## Currently (230501)
- Heroku stack: heroku-22

## To update heroku stack:
- `heroku stack:set heroku-22 -a college-arch-api`
- readd, recommit, and re `git push heroku master`

