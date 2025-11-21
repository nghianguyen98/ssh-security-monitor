# ====== TELEGRAM CONFIG ======
BOT_TOKEN="PUT_YOUR_BOT_TOKEN"
CHAT_ID="PUT_YOUR_CHAT_ID"

# ====== BASIC SSH INFO ======
USER=$PAM_USER
IP=$(echo $SSH_CONNECTION | awk '{print $1}')
HOST=$(hostname)
DATE=$(date '+%Y-%m-%d %H:%M:%S')
OS=$(lsb_release -ds 2>/dev/null || echo "Unknown OS")

# ====== SYSTEM INFO ======
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | cut -d':' -f2 | sed 's/^ //')
MEM_FREE=$(free -h | awk '/Mem:/ {print $7}')
MEM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
SESSIONS=$(who | wc -l)
UPTIME=$(uptime -p | sed 's/up //')

# ====== GEOIP LOOKUP ======
if [[ "$IP" =~ ^10\. || "$IP" =~ ^192\.168\. || "$IP" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]; then
    CITY="Local Network"
    COUNTRY=""
    ORG="LAN"
else
    GEO=$(curl -s https://ipinfo.io/$IP/json)
    CITY=$(echo "$GEO" | grep '"city"' | cut -d'"' -f4)
    COUNTRY=$(echo "$GEO" | grep '"country"' | cut -d'"' -f4)
    ORG=$(echo "$GEO" | grep '"org"' | cut -d'"' -f4)
    [ -z "$CITY" ] && CITY="Unknown"
    [ -z "$COUNTRY" ] && COUNTRY="Unknown"
    [ -z "$ORG" ] && ORG="Unknown ISP"
fi

# ====== MESSAGE TEMPLATE ======
MESSAGE="🟢 SSH Login Alert

👤 *User:* *$USER*
🌐 *IP:* $IP
🌍 *Location:* $CITY $COUNTRY
🏢 *ISP:* $ORG
🔑 *Auth:* SSH Login
🖥 *Server:* *$HOST*
📀 *OS:* $OS
🕒 *Time:* $DATE
━━━━━━━━━━━━━━━━━━
📊 *System Information*

• 🧠 *CPU:* $CPU_MODEL
• ⚙️ *CPU Usage:* $CPU_USAGE
• 💾 *RAM:* $MEM_FREE free / $MEM_TOTAL total
• 🗄️ *Disk (/):* $DISK_FREE free / $DISK_TOTAL total
• ⏱️ *Uptime:* $UPTIME
• 👥 *Active SSH Sessions:* $SESSIONS
━━━━━━━━━━━━━━━━━━
❗ *If this was not you, please investigate immediately.*
"

# ====== SEND TO TELEGRAM ======
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
     -d chat_id="$CHAT_ID" \
     -d text="$MESSAGE" \
     -d parse_mode="Markdown"