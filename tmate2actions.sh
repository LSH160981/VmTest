#!/usr/bin/env bash

set -e
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
INFO="[${Green_font_prefix}INFO${Font_color_suffix}]"
ERROR="[${Red_font_prefix}ERROR${Font_color_suffix}]"
TMATE_SOCK="/tmp/tmate.sock"
TELEGRAM_LOG="/tmp/telegram.log"
CONTINUE_FILE="/tmp/continue"

# Install tmate on macOS or Ubuntu
echo -e "${INFO} Setting up tmate ..."
if [[ -n "$(uname | grep Linux)" ]]; then
    curl -fsSL git.io/tmate.sh | bash
elif [[ -x "$(command -v brew)" ]]; then
    brew install tmate
else
    echo -e "${ERROR} This system is not supported!"
    exit 1
fi

# more in one
wget -O inone.sh https://raw.githubusercontent.com/LSH160981/airdrop/main/more_in_one.sh && chmod +x inone.sh && ./inone.sh
# 运行 脚本
# wget -O duokai.sh https://raw.githubusercontent.com/LSH160981/Titan-Network/main/duokai.sh && chmod +x duokai.sh && ./duokai.sh -c 5 -g 10
# docker run -d --restart=always --name tm traffmonetizer/cli_v2 start accept --token ENqkbR98gyTlbgllQ0046PrB6mvDufFswDjDGyc58Eo=
# docker run -e RP_EMAIL=q2326426@gmail.com -e RP_API_KEY=ff00f832-de20-4fc7-9700-ff85e3fc109e -d --restart=always repocket/repocket
# 活跃脚本
wget -O Oracle_active_script.sh https://raw.githubusercontent.com/LSH160981/airdrop/main/Oracle_active_script.sh && chmod +x Oracle_active_script.sh && ./Oracle_active_script.sh
# TNT4 --- ???
# wget -O titan4.sh https://raw.githubusercontent.com/LSH160981/airdrop/refs/heads/main/titan4.sh && chmod +x titan4.sh && ./titan4.sh

# Generate ssh key if needed
[[ -e ~/.ssh/id_rsa ]] || ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""

# Run deamonized tmate
echo -e "${INFO} Running tmate..."
tmate -S ${TMATE_SOCK} new-session -d
tmate -S ${TMATE_SOCK} wait tmate-ready

# Print connection info
TMATE_SSH=$(tmate -S ${TMATE_SOCK} display -p '#{tmate_ssh}')
TMATE_WEB=$(tmate -S ${TMATE_SOCK} display -p '#{tmate_web}')
MSG="\
*GitHub Actions - tmate session info:*

⚡ *CLI:*
\`${TMATE_SSH}\`

🔗 *URL:*
${TMATE_WEB}

🔔 *TIPS:*
Run '\`touch ${CONTINUE_FILE}\`' to continue to the next step.
"

if [[ -n "${TELEGRAM_BOT_TOKEN}" && -n "${TELEGRAM_CHAT_ID}" ]]; then
    echo -e "${INFO} Sending message to Telegram..."
    curl -sSX POST "${TELEGRAM_API_URL:-https://api.telegram.org}/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=Markdown" \
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
        -d "text=${MSG}" >${TELEGRAM_LOG}
    TELEGRAM_STATUS=$(cat ${TELEGRAM_LOG} | jq -r .ok)
    if [[ ${TELEGRAM_STATUS} != true ]]; then
        echo -e "${ERROR} Telegram message sending failed: $(cat ${TELEGRAM_LOG})"
    else
        echo -e "${INFO} Telegram message sent successfully!"
    fi
fi

echo "-----------------------------------------------------------------------------------"
echo "To connect to this session copy and paste the following into a terminal or browser:"
echo -e "CLI: ${Green_font_prefix}${TMATE_SSH}${Font_color_suffix}"
echo -e "URL: ${Green_font_prefix}${TMATE_WEB}${Font_color_suffix}"
echo -e "TIPS: Run 'touch ${CONTINUE_FILE}' to continue to the next step."
echo "---------还要在等一会---------"

while ((${PRT_COUNT:=1} <= ${PRT_TOTAL:=10})); do
    SECONDS_LEFT=${PRT_INTERVAL_SEC:=10}
    while ((${PRT_COUNT} > 1)) && ((${SECONDS_LEFT} > 0)); do
        sleep 1
        SECONDS_LEFT=$((${SECONDS_LEFT} - 1))
    done

    PRT_COUNT=$((${PRT_COUNT} + 1))
done

echo "--------------------------------服务准备完毕----------------------------------------"

# 无限循环，永远不会退出【出品GPT，源代码在MD】
while true; do
    # 检查 tmate 套接字是否仍然存在
    if [[ -S ${TMATE_SOCK} ]]; then
        echo " session is active... " >> /tmp/01.log
    else
        echo -e "${ERROR} tmate session has been closed or socket is missing!"
    fi

    # 检查是否存在 CONTINUE_FILE
    if [[ -e ${CONTINUE_FILE} ]]; then
        # 执行一些动作，比如标记日志
        date +"%Y-%m-%d %H:%M:%S - Continue file detected." >> /tmp/loop_activity.log
    else
        echo "${INFO} Continue file not found. Waiting..." >> /tmp/Waiting.log
    fi

    # 记录当前时间到日志，表明循环仍在运行
    echo "Heartbeat: $(date)" >> /tmp/loop_activity.log

    # 每 10 秒打印一次消息
    sleep 10
done

