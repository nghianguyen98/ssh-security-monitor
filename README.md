# SSH Login Alert – Telegram Notification

This script sends a detailed notification to a Telegram chat whenever someone logs into your Linux server via SSH.  
Works on **Ubuntu / Debian / CentOS  / any Linux with PAM**.

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
- No background daemon  
- Zero performance impact  

---

## 📦 Installation

### 1. Clone repository
```bash
git clone https://github.com/nghianguyen98/ssh-security-monitor
cd ssh-security-monitor
```

---

### 2. Configure Telegram API keys

Before installing, edit the script and set your keys:

```bash
nano ssh-login-alert.sh
```

Find:

```bash
BOT_TOKEN="PUT_YOUR_TOKEN_HERE"
CHAT_ID="PUT_YOUR_CHAT_ID_HERE"
```

Replace with:

- `BOT_TOKEN` — from **@BotFather**
- `CHAT_ID` — from:

```
https://api.telegram.org/bot<BOT_TOKEN>/getUpdates
```

Save file.

---

### 3. Make script executable
```bash
chmod +x ssh-login-alert.sh
```

---

### 4. Move script to system path
```bash
sudo cp ssh-login-alert.sh /usr/local/bin/
```

---

### 5. Enable PAM Trigger

Add PAM hook
```bash
sudo sh -c "echo 'session optional pam_exec.so seteuid /usr/local/bin/ssh-login-alert.sh' >> /etc/pam.d/sshd"
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

You should instantly receive a Telegram alert.

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

---

## 📜 License
MIT License
