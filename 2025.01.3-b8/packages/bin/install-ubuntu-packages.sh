#!/bin/bash
set -e

TARGET_DIR="${JUPYTER_SERVER_ROOT}/packages/ubuntu_packages"

PKG_INSTALL_MAX_RETRY=3

for ((RETRY_CNT=1; RETRY_CNT<=PKG_INSTALL_MAX_RETRY; RETRY_CNT++)); do
    echo -e "\n================================ \e[32mInstallation attempt ${RETRY_CNT}/${PKG_INSTALL_MAX_RETRY}\e[0m =================================\n"

    # 재시도할 패키지 목록 구성
    if [ $RETRY_CNT -eq 1 ]; then
        # 첫 번째 시도:
        #   - TARGET_DIR 아래 모든 .deb 파일을 찾아 pkg_list 배열에 저장
        pkg_list=($(find "$TARGET_DIR" -type f -name "*.deb"))
    else
        # 두 번째 ~ PKG_INSTALL_MAX_RETRY 시도:
        #   - 이전 반복에서 설치 실패한 패키지들만 재시도
        pkg_list=("${failed_pkgs[@]}")      
        
        # 다음 반복을 위해 실패 패키지 배열 초기화
        failed_pkgs=()
    fi

    # 현재 시도에서 처리할 패키지 수 출력
    echo -e "\n[Attempt ${RETRY_CNT}/${PKG_INSTALL_MAX_RETRY}] Packages to install: \e[32m${#pkg_list[@]}\e[0m"

    # 패키지 리스트 순회하며 설치 시도
    for i in "${!pkg_list[@]}"; do
        echo -e "\n--------------------- [$i] Installing package: \e[32m${pkg_list[$i]}\e[0m ---------------------\n"

        if ! apt-get install --yes --no-install-recommends "${pkg_list[$i]}"; then
            echo -e "\nPackage \e[33m${pkg_list[$i]}\e[0m install failed. Will retry shortly."
            failed_pkgs+=("${pkg_list[$i]}")  # 실패한 패키지는 배열에 저장
        else
            echo -e "\nPackage \e[32m${pkg_list[$i]}\e[0m installed successfully."
        fi
    done

    # 실패한 패키지가 없으면 반복 종료
    if [ ${#failed_pkgs[@]} -eq 0 ]; then
        echo -e "\n\e[32mAll packages installed successfully.\e[0m"
        break
    else
        # 최대 재시도 횟수 도달 시 실패 패키지 목록 출력 후 종료
        if [ $RETRY_CNT -eq $PKG_INSTALL_MAX_RETRY ]; then
            echo -e "\n\e[31m[ Installation failed after $PKG_INSTALL_MAX_RETRY attempts for following packages ]\e[0m\n"
            # for pkg in "${failed_pkgs[@]}"; do
            #     echo -e "\040\040- \e[31m$pkg\e[0m"
            # done
            for i in "${!failed_pkgs[@]}"; do
                echo -e "\040\040\e[33m[$i] ${failed_pkgs[$i]}\e[0m"
            done            
            exit 1
        # 재시도 예정인 실패 패키지 목록 출력
        else
            echo -e "\n\e[33m[ Retrying Failed Packages ]\e[0m\n"
            # for pkg in "${failed_pkgs[@]}"; do
            #     echo -e "  - \e[33m$pkg\e[0m"
            for i in "${!failed_pkgs[@]}"; do
                echo -e "\040\040\e[33m- [$i] ${failed_pkgs[$i]}\e[0m"
            done

            sleep 300
        fi
    fi

done