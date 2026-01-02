#!/bin/bash

# Instala o repositório de temas e configurações
# Executar na raiz do repositório

set -e  # Para o script se algum comando falhar

# Determina a pasta atual do repositório (diretório onde o script está)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Diretório do repositório detectado: $REPO_DIR"

# Criação de links simbólicos
echo "Criando links simbólicos..."

ln -sf "$REPO_DIR/Thunar"     ~/.config/Thunar
ln -sf "$REPO_DIR/asciiart"   ~/.config/asciiart

# Descompacta iSettings.zip e cria link
echo "Descompactando iSettings.zip..."
unzip -o "$REPO_DIR/iSettings.zip" -d "$REPO_DIR"  # -o sobrescreve se necessário

ln -sf "$REPO_DIR/iSettings"  ~/.config/iSettings

# Permissões gerais
echo "Aplicando permissões de execução..."

chmod +x "$REPO_DIR/asciiart"/*
chmod +x "$REPO_DIR/02-themes.sh"
chmod +x "$REPO_DIR/03-icons.sh"
chmod +x "$REPO_DIR/04-cursors.sh"

chmod +x "$REPO_DIR/iSettings/bin"/*
chmod +x "$REPO_DIR/iSettings/rofi"/*
chmod +x "$REPO_DIR/iSettings/scripts"/*

# Lista de todos os temas existentes na pasta iSettings/themes
THEMES_DIR="$REPO_DIR/iSettings/themes"
THEMES=("tokyo-night" "gruvbox" "gruvbox-light" "everforest" "dracula" "chad" "catppuccin" "nordico")

for theme in "${THEMES[@]}"; do
    theme_path="$THEMES_DIR/$theme"
    if [ -d "$theme_path" ]; then
        echo "Aplicando permissões no tema: $theme"
        chmod +x "$theme_path"/apply.sh    2>/dev/null || true
        chmod +x "$theme_path"/blur.sh     2>/dev/null || true
        chmod +x "$theme_path"/theme.bash  2>/dev/null || true
        chmod +x "$theme_path/polybar"/launch.sh 2>/dev/null || true
    else
        echo "Aviso: Tema $theme não encontrado, ignorando."
    fi
done

# Permissão extra no polybar.sh que está na raiz dos themes (se existir)
chmod +x "$THEMES_DIR/polybar.sh" 2>/dev/null || true

# Instalando tema e icones
echo "Instalando tema e ícones!"
# Executa os scripts usando o interpretador correto
"$REPO_DIR/02-themes.sh"
"$REPO_DIR/03-icons.sh"
"$REPO_DIR/04-cursors.sh"

# Ou, se preferires ser mais explícito:
# bash "$REPO_DIR/02-themes.sh"
# bash "$REPO_DIR/03-icons.sh"
# bash "$REPO_DIR/04-cursors.sh"

echo ""
echo "Instalação concluída com sucesso!"
echo "Links simbólicos criados em ~/.config/"
echo "Todos os scripts necessários têm permissão de execução."
echo "Podes agora aplicar o tema que quiseres executando os scripts correspondentes em iSettings/themes/<tema>/"
