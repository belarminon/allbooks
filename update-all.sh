#!/bin/bash

echo "🔄 Atualizando submodules..."

git submodule foreach '
  echo "Atualizando $name"
  git pull origin main
'

echo "📦 Commitando referências..."

git add .
git commit -m "chore: update submodules"
git push

echo "✅ Tudo atualizado!"