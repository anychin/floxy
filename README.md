### Деплой

production
http://floxy.org
```
branch=<branch> bundle exec cap production deploy
```

staging
http://http://178.62.133.19/
```
branch=<branch> bundle exec cap staging deploy
```

### Полезные задачи
```
cap rails:console                  # Interact with a remote rails console

cap db:local:sync                  # Synchronize your local database using remote database data
cap db:pull                        # Synchronize your local database using remote database data
cap db:push                        # Synchronize your remote database using local database data
cap db:remote:sync                 # Synchronize your remote database using local database data

cap puma:phased-restart            # phased-restart puma
cap puma:restart                   # restart puma
cap puma:start                     # Start puma
cap puma:status                    # status puma
cap puma:stop                      # stop puma
```
