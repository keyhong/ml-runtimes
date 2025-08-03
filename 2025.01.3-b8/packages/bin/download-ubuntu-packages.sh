#!/bin/bash
set -e

apt-get update

# 저장 루트 경로
PKG_ROOT="${JUPYTER_SERVER_ROOT}/packages/ubuntu_packages"

# 패키지와 디렉토리 매핑
declare -A packages=(
    ["powerline"]="powerline"
    ["vim"]="vim"
    ["bash-completion"]="bash-completion"
    ["pandoc"]="pandoc"
    ["texlive-xetex"]="texlive-xetex"
    ["texlive-fonts-recommended"]="texlive-fonts-recommended"
    ["texlive-plain-generic"]="texlive-plain-generic"
    ["zsh"]="zsh"
    ["unixodbc"]="unixodbc"
    ["unixodbc-dev"]="unixodbc-dev"
    ["fonts-powerline"]="fonts-powerline"
)

# 일반 패키지 다운로드 및 이동
for pkg in "${!packages[@]}"; do
    echo -e "\n--------------------- Downloading package: \e[32m$pkg\e[0m ---------------------\n"
    apt-get install --yes --no-install-recommends --download-only "$pkg"
    mkdir -p "${PKG_ROOT}/${packages[$pkg]}"
    mv /var/cache/apt/archives/*.deb "${PKG_ROOT}/${packages[$pkg]}" || true
    rm -rf /var/cache/apt/archives
    echo -e "\nPackage \e[32m$pkg\e[0m downloaded successfully."
done