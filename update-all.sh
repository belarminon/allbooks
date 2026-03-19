#!/bin/bash

# ================================
# PARAMETRO: mensagem de commit
# ================================
MSG=$1

if [ -z "$MSG" ]; then
  echo "❗ Informe a mensagem de commit:"
  read MSG
fi

echo ""
echo "📝 Commit message: $MSG"
echo ""

# ================================
# PROCESSAR SUBMODULES
# ================================
for d in api-books frontend-books; do
  echo "===================================="
  echo "🚀 PROCESSANDO: $d"
  echo "===================================="

  cd $d || exit

  echo "📌 STATUS:"
  git status -s

  echo ""
  echo "📜 ÚLTIMOS COMMITS:"
  git log --oneline -5

  echo ""
  read -p "👉 Deseja commitar alterações em $d? (y/n/edit/exit): " opt

  case $opt in
    y)
      git add .
      git commit -m "$MSG" || echo "⚠️ Sem mudanças"
      ;;
    edit)
      git add .
      git commit
      ;;
    exit)
      echo "❌ Operação cancelada"
      exit 1
      ;;
    *)
      echo "⏭️ Pulando $d"
      ;;
  esac

  echo ""
  read -p "👉 Deseja dar push em $d? (y/n/exit): " pushopt

  case $pushopt in
    y)
      git push
      ;;
    exit)
      echo "❌ Operação cancelada"
      exit 1
      ;;
    *)
      echo "⏭️ Push ignorado em $d"
      ;;
  esac

  cd ..
done

# ================================
# REPO PRINCIPAL
# ================================
echo ""
echo "===================================="
echo "📦 REPO PRINCIPAL"
echo "===================================="

git status -s

echo ""
git log --oneline -5

echo ""
read -p "👉 Commitar repo principal? (y/n/edit/exit): " opt

case $opt in
  y)
    git add .
    git commit -m "$MSG" || echo "⚠️ Sem mudanças"
    ;;
  edit)
    git add .
    git commit
    ;;
  exit)
    echo "❌ Operação cancelada"
    exit 1
    ;;
  *)
    echo "⏭️ Commit ignorado"
    ;;
esac

echo ""
read -p "👉 Push repo principal? (y/n/exit): " pushopt

case $pushopt in
  y)
    git push
    ;;
  exit)
    echo "❌ Operação cancelada"
    exit 1
    ;;
  *)
    echo "⏭️ Push ignorado"
    ;;
esac

echo ""
echo "✅ Processo finalizado!"