#!/bin/bash

# ================================
# CONFIG
# ================================
REPOS=("api-books" "frontend-books")

# Detecta branch automaticamente
get_branch() {
  git rev-parse --abbrev-ref HEAD
}

# Verifica se há mudanças
has_changes() {
  [ -n "$(git status --porcelain)" ]
}

# Rodar testes/lint (customizável)
run_checks() {
  if [ -f "package.json" ]; then
    echo "🧪 Rodando npm test..."
    npm test || return 1

    echo "🔍 Rodando lint..."
    npm run lint || return 1
  fi
}

# ================================
# START
# ================================
MSG=$1

if [ -z "$MSG" ]; then
  read -p "📝 Mensagem de commit: " MSG
fi

echo ""
echo "🚀 Iniciando fluxo..."
echo ""

# ================================
# LOOP NOS SUBMODULES
# ================================
for d in "${REPOS[@]}"; do
  echo "===================================="
  echo "📦 $d"
  echo "===================================="

  cd $d || exit

  BRANCH=$(get_branch)
  echo "🌿 Branch: $BRANCH"

  if ! has_changes; then
    echo "✅ Sem alterações"
    cd ..
    continue
  fi

  git status -s

  echo ""
  read -p "👉 Rodar testes/lint? (y/n): " checkopt
  if [ "$checkopt" == "y" ]; then
    run_checks || { echo "❌ Falha nos testes"; exit 1; }
  fi

  echo ""
  read -p "👉 Commitar? (y/n/edit): " opt

  case $opt in
    y)
      git add .
      git commit -m "$MSG"
      ;;
    edit)
      git add .
      git commit
      ;;
    *)
      echo "⏭️ Pulando commit"
      cd ..
      continue
      ;;
  esac

  echo ""
  read -p "👉 Push para $BRANCH? (y/n): " pushopt
  [ "$pushopt" == "y" ] && git push origin $BRANCH

  cd ..
done

# ================================
# REPO PRINCIPAL
# ================================
echo ""
echo "===================================="
echo "🏠 Repo principal"
echo "===================================="

BRANCH=$(get_branch)
echo "🌿 Branch: $BRANCH"

if has_changes; then
  git status -s

  read -p "👉 Commitar principal? (y/n): " opt
  [ "$opt" == "y" ] && git add . && git commit -m "$MSG"

  read -p "👉 Push principal? (y/n): " pushopt
  [ "$pushopt" == "y" ] && git push origin $BRANCH
else
  echo "✅ Sem alterações no principal"
fi

echo ""
echo "🎉 Fluxo finalizado!"