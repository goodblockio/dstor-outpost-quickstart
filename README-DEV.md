Direnv needs to be installed.  Starting from the develop branch and only after cloning the first time run:
```
git clone (repo)
git flow init -d
cd hooks
./link-hooks
```

Then:
```
git flow feature start <name>_<feature_short_name>
git add -A .
git commit -m 'Some sort of message' -a
git push
```

Once you are happy with it, then if this is your repo you can merge it back with, or goto your branch on GitHub and submit a pull request.  Merge to develop, release to master.

```
git flow feature finish <name>_<feature_short_name>
```
