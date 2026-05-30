# RO-King 5.0 — คู่มือ Setup Server

คู่มือเปิดเซิร์ฟ Ragnarok Online Episode 5.0 ด้วย **rAthena** สำหรับเล่นกับเพื่อน 5-30 คน

> ⚡ **เริ่มจากศูนย์? แนะนำวิธี Docker (ง่ายกว่ามาก)** — ไม่ต้องลง Visual Studio / ตั้ง DB เอง
> 👉 ดู **[server/START_HERE.md](server/START_HERE.md)**
> คู่มือด้านล่างนี้เป็นวิธี **compile เองด้วย Visual Studio** (ทางเลือกขั้นสูง)

---

## ภาพรวม

**Stack ที่ใช้:**
- **Server emulator:** rAthena (open source — github.com/rathena/rathena)
- **Database:** MariaDB / MySQL (ฟรี)
- **Client:** kRO + custom patcher
- **Hosting:** VPS / คอมที่บ้าน + Hamachi

**เวลา setup โดยประมาณ:**
- ครั้งแรก (ลง software + compile): **2-4 ชั่วโมง**
- ตั้งค่า rate / config: **1 ชั่วโมง**
- ทำ client patcher: **30 นาที**
- รวม: **~1 วัน** ครั้งเดียวจบ

---

## Part 1 — เตรียม Software (Windows)

### 1.1 Visual Studio 2022 Community
- ดาวน์โหลด: https://visualstudio.microsoft.com/
- ตอนติดตั้ง เลือก **"Desktop development with C++"**
- เปิดติดตั้ง **MSVC v143**, **Windows 10/11 SDK**

### 1.2 Git for Windows
- ดาวน์โหลด: https://git-scm.com/

### 1.3 MariaDB 10.11+
- ดาวน์โหลด: https://mariadb.org/download/
- ตอนติดตั้งตั้ง root password (จดไว้!)
- เปิด port `3306`

**(ทางลัด)** ใช้ **Laragon** แทน — ลง MariaDB + Apache ในตัวเดียว
- ดาวน์โหลด: https://laragon.org/download/

---

## Part 2 — Clone และ Compile rAthena

```bash
git clone https://github.com/rathena/rathena.git
cd rathena
```

**สำคัญ:** Episode 5.0 = Pre-Renewal mode
แก้ไฟล์ `src/config/renewal.hpp`:
```cpp
// คอมเมนต์บรรทัดนี้ออกเพื่อใช้ Pre-Renewal
//#define RENEWAL
```

**Compile:**
1. เปิด `rAthena.sln` ด้วย Visual Studio 2022
2. เลือก **Release × x64**
3. Build → Build Solution (Ctrl+Shift+B)
4. รอ ~5 นาที จะได้ไฟล์:
   - `login-server.exe`
   - `char-server.exe`
   - `map-server.exe`

---

## Part 3 — ตั้งค่า Database

### 3.1 สร้าง Database
เปิด HeidiSQL / phpMyAdmin → สร้าง database ชื่อ `ragnarok`

### 3.2 Import schema (Pre-Renewal)
```sql
-- ใน HeidiSQL
USE ragnarok;
SOURCE sql-files/main.sql;
SOURCE sql-files/logs.sql;
SOURCE sql-files/item_db.sql;
SOURCE sql-files/item_db2.sql;
SOURCE sql-files/mob_db.sql;
SOURCE sql-files/mob_db2.sql;
```

### 3.3 สร้างบัญชี Master (GM)
```sql
INSERT INTO `login` (`userid`, `user_pass`, `sex`, `email`, `group_id`)
VALUES ('s1', 'p1', 'M', 'admin@kingro.local', 99);
```
> Login: `s1` / Pass: `p1` — เปลี่ยนหลังเปิดเซิร์ฟแล้ว!

---

## Part 4 — Config rAthena

### 4.1 เชื่อม Database
แก้ `conf/inter_athena.conf`:
```
sql.db_hostname: 127.0.0.1
sql.db_port: 3306
sql.db_username: ragnarok
sql.db_password: <รหัส MariaDB>
sql.db_database: ragnarok
```
(ทำซ้ำกับไฟล์ `conf/import-tmpl/inter_athena.conf`)

### 4.2 ตั้งชื่อเซิร์ฟ
แก้ `conf/char_athena.conf`:
```
server_name: RO-King 5.0
```

### 4.3 ตั้ง Rate (Mid-Rate x50)
แก้ `conf/battle/exp.conf`:
```
base_exp_rate: 5000      # 5000 = x50 (100 = x1)
job_exp_rate: 5000
quest_exp_rate: 5000
```

แก้ `conf/battle/drops.conf`:
```
item_rate_common: 5000        # x50 ของทั่วไป
item_rate_equip: 5000
item_rate_card: 500           # x5 การ์ดทั่วไป
item_rate_card_boss: 100      # x1 MVP card (คงเดิม)
```

### 4.4 ตั้ง Max Level (99/50 Classic)
แก้ `db/pre-re/exp.txt`:
- Max Base = 99
- Max Job 2nd = 50

**(default ของ Pre-Renewal ตั้งไว้แล้ว ไม่ต้องแก้)**

---

## Part 5 — รัน Server

เปิด 3 หน้าต่าง Command Prompt ในโฟลเดอร์ rAthena:

```bash
# หน้าต่าง 1
login-server.exe

# หน้าต่าง 2
char-server.exe

# หน้าต่าง 3
map-server.exe
```

ถ้าเห็น `Server is ready and waiting for connections` = สำเร็จ!

> **ทางลัด:** สร้าง `runserver.bat` ที่รันทั้ง 3 พร้อมกัน

---

## Part 6 — Client (สำหรับผู้เล่น)

### 6.1 ดาวน์โหลด kRO
- ใช้ kRO version ที่ตรงกับ Pre-Renewal Episode 5.x
- หาได้จาก: rAthena forum / RO Renewal Archive

### 6.2 ใช้ NEMO Patcher
- ดาวน์โหลด: https://gitlab.com/4144/nemo
- Patch client ให้ชี้ไปที่ IP server ของคุณ:
  - `Always Call SelectKoreaClientInfo`
  - `Disable Hallucination Wavy Screen`
  - `Read Data Folder First`
  - `Custom Window Title` → "RO-King 5.0"

### 6.3 แก้ `clientinfo.xml`
```xml
<address>YOUR_SERVER_IP</address>
<port>6900</port>
<version>55</version>
<langtype>1</langtype>
```

---

## Part 7 — เปิดให้เพื่อนเข้า

### ทางเลือก A: Hamachi (ง่ายสุด, 5-10 คน)
1. ดาวน์โหลด Hamachi: https://vpn.net/
2. คุณเปิด Network ใหม่ → แชร์ network ID + pass
3. เพื่อนติดตั้ง Hamachi → เข้า network
4. ใน client ตั้ง IP เป็น IP Hamachi ของคุณ (เช่น `25.x.x.x`)

### ทางเลือก B: Port Forward (เหมาะกับเน็ตบ้าน)
- เปิด port `6900`, `6121`, `5121` บน router
- เพื่อนใช้ Public IP ของคุณ
- เช็ค IP: https://whatismyip.com

### ทางเลือก C: VPS (เปิด 24/7)
- **Contabo VPS XS** (4 vCPU, 8GB RAM, 50GB SSD) — ~150 บาท/เดือน
- **DigitalOcean** Droplet 2GB — ~$12/เดือน
- เซิร์ฟอยู่ใน DC ตลอด เพื่อนเข้าได้ตลอด

---

## Part 8 — Checklist ก่อนเปิด CBT

- [ ] Server รัน 3 process ครบ ไม่ error
- [ ] Login ด้วย account ทดสอบได้
- [ ] สร้างตัวละครได้
- [ ] เข้า Prontera ได้
- [ ] EXP rate × ตามที่ตั้ง
- [ ] Drop rate × ตามที่ตั้ง
- [ ] @command ใช้งานได้ (`@go`, `@warp`, `@item`)
- [ ] WoE schedule ทำงาน
- [ ] MVP spawn ตามเวลา
- [ ] เพื่อน 1 คน connect จากภายนอกได้

---

## Resources

- **rAthena Wiki:** https://github.com/rathena/rathena/wiki
- **rAthena Forum:** https://rathena.org/board/
- **Pre-Renewal DB:** https://www.divine-pride.net/
- **iRO Wiki Classic:** https://classic.irowiki.org/
- **NEMO Patcher:** https://gitlab.com/4144/nemo

---

## Troubleshooting

| ปัญหา | วิธีแก้ |
|---|---|
| **Login server start ไม่ขึ้น** | เช็ค port 6900 ไม่ติด, MariaDB เปิดอยู่ |
| **Connect ผ่าน Hamachi ไม่ได้** | เช็ค firewall ปิด, IP ใน clientinfo.xml ตรง Hamachi |
| **Login สำเร็จแต่ Char list ว่าง** | char-server ไม่ได้รัน หรือ connect database fail |
| **Map error เข้าด่านไม่ได้** | map-server ไม่ได้รัน หรือ map cache เสีย — รัน `mapcache.exe` |
| **EXP ไม่ × ตามที่ตั้ง** | restart map-server หลังแก้ config |

---

## Next Steps

1. ✅ เปิดเว็บนี้ ([index.html](index.html))
2. ⏳ Setup server ตามคู่มือ
3. ⏳ ลง MariaDB → Compile rAthena → ตั้งค่า
4. ⏳ Patch client → ทดสอบ
5. ⏳ ชวนเพื่อน 1 คน CBT
6. ⏳ เปิด Discord + Vercel เว็บ
7. ⏳ Launch จริง!
