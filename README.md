# SSH Login Alert - Telegram Notification

This script sends a detailed notification to a Telegram chat whenever someone logs into your Linux server via SSH. Works on **Ubuntu / Debian / CentOS / any Linux with PAM**.

---

## 🔥 Features
- Detect SSH logins instantly  
- Full login details:
  - Username  
  - IP Address  
  - GeoIP: City, Country, ISP  
  - Server Hostname  
  - OS Version  
  - CPU Model & CPU Usage  
  - RAM Usage  
  - Disk Usage  
  - Uptime  
  - Active SSH Sessions  
- Very lightweight — runs only during login  
- Zero performance impact  
- No background services required  

---

## 📦 Installation

### 1️⃣ Clone repository
```bash
git clone https://github.com/nghianguyen98/ssh-security-monitor
cd ssh-security-monitor
```

### 2️⃣ Make script executable
```bash
chmod +x ssh-login-alert.sh
```

### 3️⃣ Move script to system path
```bash
sudo cp ssh-login-alert.sh /usr/local/bin/
```

---

## ⚙️ Configure Telegram Bot

1. Create bot using **@BotFather**
2. Get your bot token `BOT_TOKEN`
3. Add bot to your Telegram chat/group
4. Get your `CHAT_ID`  
   - Use `https://api.telegram.org/bot<BOT_TOKEN>/getUpdates`
5. Edit script:
```bash
BOT_TOKEN="PUT_YOUR_TOKEN_HERE"
CHAT_ID="PUT_YOUR_CHAT_ID_HERE"
```

---

## 🔧 Enable PAM Trigger

Edit **/etc/pam.d/sshd**:

```bash
sudo nano /etc/pam.d/sshd
```

Add at bottom:

```bash
session optional pam_exec.so seteuid /usr/local/bin/ssh-login-alert.sh
```

Restart SSH:

```bash
sudo systemctl restart ssh
```

---

## 🧪 Test

From another machine:

```bash
ssh user@SERVER_IP
```

You should instantly receive your Telegram alert.

---

## 🧹 Uninstall

Remove PAM hook:

```bash
sudo sed -i '/ssh-login-alert.sh/d' /etc/pam.d/sshd
```

Remove script:

```bash
sudo rm /usr/local/bin/ssh-login-alert.sh
```

