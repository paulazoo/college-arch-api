## Requires:
- heroku cli

## Deploy:
- don't include package-lock.json when deploying through heroku
- don't include Gemfile.lock when deploying through heroku
- `git add .`, `git commit "msg"`
- `git push origin master` if needed
- `git push heroku master`

To troubleshoot heroku:
- `heroku run console -a college-arch-api`

## Currently (230501)
- Heroku stack: heroku-22

## To update heroku stack:
- `heroku stack:set heroku-22 -a college-arch-api`
- readd, recommit, and re `git push heroku master`

