#!/bin/bash

while true; do
  clear
  echo "=============================="
  echo "🚀 DEV TOOLKIT"
  echo "=============================="
  echo "1) Status geral"
  echo "2) Atualizar submodules"
  echo "3) Commit + Push (devflow)"
  echo "4) Rodar projeto (Docker)"
  echo "5) Sair"
  echo ""

  read -p "Escolha: " opt

  case $opt in
    1)
      echo "📊 STATUS"
      git status
      git submodule foreach git status
      read -p "Enter para continuar..."
      ;;
    2)
      git submodule update --init --recursive
      git submodule foreach git pull origin main
      read -p "Atualizado. Enter..."
      ;;
    3)
      bash devflow.sh
      read -p "Enter..."
      ;;
    4)
      docker-compose up --build
      ;;
    5)
      exit 0
      ;;
    *)
      echo "Opção inválida"
      ;;
  esac
done