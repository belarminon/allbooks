#!/bin/bash

for d in api-books frontend-books; do
  echo "🚀 $d"
  cd $d
  git add .
  git commit -m "feat: auto update" || echo "sem mudanças"
  git push
  cd ..
done

git add .
git commit -m "chore: sync submodules" || echo "sem mudanças"
git push