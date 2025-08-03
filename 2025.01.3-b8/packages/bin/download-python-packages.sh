#!/bin/bash
set -e

apt-get update

# 저장 루트 경로
PKG_ROOT="${JUPYTER_SERVER_ROOT}/packages/python_packages"

# pip 패키지와 버전 매핑
declare -A pip_packages=(
    # ["tensorflow[and-cuda]==2.15.1"]="tensorflow[and-cuda]-2.15.1"
    # ["tensorflow[and-cuda]==2.16.2"]="tensorflow[and-cuda]-2.16.2"
    # ["tensorflow[and-cuda]==2.18.1"]="tensorflow[and-cuda]-2.18.1"
    ["torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0"]="torch-2.6.0"
)

declare -A pip_index_urls=(
    ["torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0"]="https://download.pytorch.org/whl/cu124"
)

# for pkg in "${!pip_packages[@]}"; do
#     echo -e "\n--------------------- Downloading package: \e[32m$pkg\e[0m ---------------------\n"
#     mkdir -p "${PKG_ROOT}/${pip_packages[$pkg]}"
#     pip download --no-cache-dir "$pkg" -d "${PKG_ROOT}/${pip_packages[$pkg]} $index_url"
#     echo -e "\nPackage \e[32m$pkg\e[0m downloaded successfully."
# done

for pkg in "${!pip_packages[@]}"; do
    echo -e "\n--------------------- Downloading package: \e[32m$pkg\e[0m ---------------------\n"
    mkdir -p "${PKG_ROOT}/${pip_packages[$pkg]}"

    # 공백 포함 문자열을 배열로 변환
    read -r -a pkg_array <<< "$pkg"
    
    pip download --no-cache-dir ${pkg_array[@]} \
        -d "${PKG_ROOT}/${pip_packages[$pkg]}" \
        ${pip_index_urls[$pkg]:+--index-url "${pip_index_urls[$pkg]}"}

    echo -e "\nPackage \e[32m$pkg\e[0m downloaded successfully."
done


