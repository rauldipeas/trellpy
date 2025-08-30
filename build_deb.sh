#!/bin/bash
set -e

PKG_NAME="trellpy"
VERSION="0.1"
ARCH="all"
MAINTAINER="Raul Dipeas <github@rauldipeas.com.br>"
DESCRIPTION="Cliente desktop para Trello usando PyQt6, cookies persistentes e notificações"
INSTALL_DIR="$PWD/$PKG_NAME"
BIN_DIR="$INSTALL_DIR/usr/bin"

# Limpa builds antigos
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"/usr/share/{applications,pixmaps}
mkdir -p "$BIN_DIR"

# Copia o script Python
cp "$PWD"/src/trellpy.py "$BIN_DIR/$PKG_NAME"
chmod +x "$BIN_DIR/$PKG_NAME"

# Diretórios

# Copia lançador e ícone
tee "$INSTALL_DIR"/usr/share/applications/trellpy.desktop >/dev/null <<EOF
[Desktop Entry]
Name=Trellpy
Comment=Cliente desktop para Trello com PyQt6
Exec=trellpy
Icon=trello
Terminal=false
Type=Application
Categories=Network;Utility;
EOF

cp "$PWD"/resources/trello.png "$INSTALL_DIR"/usr/share/pixmaps/

# Cria o arquivo DEBIAN/control
mkdir -p "$INSTALL_DIR"/DEBIAN
tee "$INSTALL_DIR"/DEBIAN/control >/dev/null <<EOF
Package: $PKG_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Depends: python3, python3-pip, python3-plyer, python3-pyqt6, python3-pyqt6.qtwebengine, libnotify-bin
Maintainer: $MAINTAINER
Description: $DESCRIPTION
EOF

# Build do pacote .deb
dpkg-deb --build --root-owner-group "$INSTALL_DIR" dist/

rm -rf trellpy

echo "Pacote gerado: dist/${PKG_NAME}.deb"