# karao

# For development environment

```shell-session
cp .envrc.example .envrc
vim .envrc # edit HUBOT_SLACK_TOKEN
direnv allow
```

```shell-session
bundle install
```

```shell-session
docker-compose up -d
```

```shell-session
bundle exec db:setup
```

# For production environment

Mind your shell history.

```shell-session
HUBOT_SLACK_TOKEN=xoxb-9999999999-999999999999-XXXXXXXXXXXXXXXXXXXXXXXX docker-compose run app --rm bundle exec rake db:setup
HUBOT_SLACK_TOKEN=xoxb-9999999999-999999999999-XXXXXXXXXXXXXXXXXXXXXXXX docker-compose up -d
```
