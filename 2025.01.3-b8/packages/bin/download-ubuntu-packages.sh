#!/bin/bash
set -e

apt-get update

# 저장 루트 경로
PKG_ROOT="${JUPYTER_SERVER_ROOT}/packages/ubuntu_packages"

# 패키지와 디렉토리 매핑
declare -A packages=(
    # https://github.com/vim/vim/blob/master/README.md
    ["vim"]="vim"
    # https://github.com/scop/bash-completion/blob/main/README.md
    ["bash-completion"]="bash-completion"
    # https://nbconvert.readthedocs.io/en/latest/install.html#installing-pandoc
    ["pandoc"]="pandoc"
    # https://nbconvert.readthedocs.io/en/latest/install.html#installing-tex
    ["texlive-xetex"]="texlive-xetex" 
    ["texlive-fonts-recommended"]="texlive-fonts-recommended"
    ["texlive-plain-generic"]="texlive-plain-generic"
    # https://zsh.sourceforge.io/
    ["zsh"]="zsh"
    # https://www.unixodbc.org/
    ["unixodbc"]="unixodbc"
    ["unixodbc-dev"]="unixodbc-dev"
    # https://github.com/powerline/powerline/blob/develop/README.rst
    ["powerline"]="powerline"
    # https://github.com/powerline/fonts/blob/master/README.rst
    ["fonts-powerline"]="fonts-powerline"
    # https://sourceforge.net/p/net-tools/code/ci/master/tree/README
    ["net-tools"]="net-tools"
    # https://github.com/iputils/iputils/blob/master/README.md
    ["iputils-ping"]="iputils-ping"
    # https://gitlab.isc.org/isc-projects/bind9/-/blob/main/README.md
    ["dnsutils"]="dnsutils"
    # https://dos2unix.sourceforge.io/
    ["dos2unix"]="dos2unix"
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