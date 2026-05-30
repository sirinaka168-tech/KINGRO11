# 🚀 RO-King 5.0 — เปิดเซิร์ฟด้วย Docker (เริ่มจากศูนย์)

คู่มือเปิดเซิร์ฟ rAthena แบบ **Docker** — ไม่ต้องลง Visual Studio, ไม่ต้องตั้ง MariaDB เอง
เหมาะกับเล่นในหมู่เพื่อน 5-30 คน

> Docker จะ build + รัน login/char/map + ฐานข้อมูล ให้อัตโนมัติในคำสั่งไม่กี่บรรทัด

---

## 📋 สิ่งที่ต้องมี

| อย่าง | ลิงก์ | หมายเหตุ |
|---|---|---|
| **Docker Desktop** | https://www.docker.com/products/docker-desktop/ | ตัวหลัก (จะลง WSL2 ให้เอง) |
| **rAthena source** | https://github.com/rathena/rathena | โหลด ZIP หรือ `git clone` |
| **kRO Client + NEMO** | (ดู [Part 6 ใน SETUP_GUIDE.md](../SETUP_GUIDE.md)) | สำหรับเข้าเล่น |

ใช้เวลาครั้งแรกประมาณ **30-60 นาที** (ส่วนใหญ่รอ compile)

---

## ① ติดตั้ง Docker Desktop

1. โหลด + ติดตั้ง **Docker Desktop** จากลิงก์ด้านบน
2. รีสตาร์ทเครื่องถ้ามันขอ (จะลง WSL2 ให้)
3. เปิด Docker Desktop ทิ้งไว้ → รอจนมุมล่างซ้ายเป็น **สีเขียว "Engine running"**

> ❗ ทุกครั้งที่จะเปิดเซิร์ฟ ต้องเปิด Docker Desktop ค้างไว้ก่อนเสมอ

---

## ② โหลด rAthena

**วิธีง่าย (ZIP):**
1. ไปที่ https://github.com/rathena/rathena
2. ปุ่มเขียว **Code → Download ZIP**
3. แตกไฟล์ไปไว้ที่ เช่น `C:\rathena`

**หรือใช้ git:**
```bash
git clone https://github.com/rathena/rathena.git C:\rathena
```

> ต่อจากนี้จะเรียกโฟลเดอร์นี้ว่า **`<rathena>`** (เช่น `C:\rathena`)

---

## ③ ตั้งค่าให้เป็น RO-King 5.0

### 3.1 เปิดโหมด Pre-Renewal (Episode 5.0)
เปิดไฟล์ **`<rathena>\src\config\renewal.hpp`** ด้วย Notepad
หา 7 บรรทัดนี้แล้ว **ใส่ `//` หน้าบรรทัด** (ปิดมันทั้งหมด):

```cpp
//#define RENEWAL
//#define RENEWAL_CAST
//#define RENEWAL_DROP
//#define RENEWAL_EXP
//#define RENEWAL_LVDMG
//#define RENEWAL_ASPD
//#define RENEWAL_STAT
```
เซฟไฟล์ → ตอนนี้เซิร์ฟเป็น **Pre-Renewal 99/50** แล้ว

### 3.2 ใส่ค่า Rate x50
ก๊อปไฟล์ **`conf-import\battle_conf.txt`** (อยู่ข้างคู่มือนี้)
ไปวางที่ **`<rathena>\conf\import\battle_conf.txt`**
> EXP x50 · Drop x50 · Card x5 · MVP Card x1

### 3.3 ใส่สคริปต์ RO-King
ก๊อป **ไฟล์ทั้งหมดในโฟลเดอร์ `rathena-root\`** (ไฟล์ `.bat` + `account-gm.sql`)
ไปวางที่ **โฟลเดอร์รากของ `<rathena>`** (ที่เดียวกับโฟลเดอร์ `tools`, `conf`, `src`)

### 3.4 ตั้งชื่อเซิร์ฟ
เปิด **`<rathena>\tools\docker\asset\char_conf.txt`** เพิ่มบรรทัด:
```
server_name: RO-King 5.0
```

---

## ④ Compile (ครั้งแรกครั้งเดียว)

ในโฟลเดอร์ `<rathena>` → **ดับเบิลคลิก `1-compile.bat`**

- ใช้เวลา ~10-20 นาที (รอได้เลย)
- เสร็จแล้วไม่มี error สีแดง = สำเร็จ ✅

---

## ⑤ เปิดเซิร์ฟ

**ดับเบิลคลิก `2-start.bat`**
- ครั้งแรกจะ import ฐานข้อมูลให้อัตโนมัติ (รอ ~1 นาที)
- เช็คว่าเซิร์ฟพร้อม: ดับเบิลคลิก **`logs.bat`** → เห็นข้อความ
  **`Server is ready and waiting for connections`** = พร้อม! 🎉

---

## ⑥ สร้างไอดี GM (admin)

**ดับเบิลคลิก `make-gm.bat`** (ทำครั้งเดียว หลังเปิดเซิร์ฟครั้งแรก)
```
Login : kingadmin
Pass  : ChangeMe_123   ← เปลี่ยนรหัสหลังล็อกอินครั้งแรก!
```

> เพื่อน ๆ สมัครเองได้ในหน้าล็อกอินของ client: พิมพ์ชื่อ + รหัส แล้วลงท้ายชื่อด้วย
> `_M` (ชาย) หรือ `_F` (หญิง) เช่น `friend1_M` ระบบจะสร้างบัญชีให้อัตโนมัติ

---

## ⑦ Client (สำหรับคุณ + เพื่อน)

Docker นี้ตั้ง **packetver = 20211103** → ต้องใช้ **kRO client เวอร์ชัน 2021-11-03**
แล้ว patch ด้วย NEMO ให้ชี้มาที่ IP เซิร์ฟของคุณ

📖 ขั้นตอนทำ client + NEMO อยู่ใน **[SETUP_GUIDE.md → Part 6](../SETUP_GUIDE.md)** แล้ว
ใน `clientinfo.xml` ตั้ง:
```xml
<address>IP_ของเซิร์ฟคุณ</address>
<port>6900</port>
```

---

## ⑧ ให้เพื่อนเข้าจากภายนอก

ค่าเริ่มต้นเล่นได้แค่ในเครื่องตัวเอง (127.0.0.1) ต้องบอก IP จริงให้ client เพื่อน

### ทางง่าย: Hamachi (5-10 คน)
1. ลง **Hamachi** (https://vpn.net) ทั้งคุณและเพื่อน → เข้า network เดียวกัน
2. ดู IP Hamachi ของคุณ (เช่น `25.x.x.x`)
3. แก้ 2 ไฟล์นี้ ใส่ IP Hamachi ของคุณ:
   - `<rathena>\tools\docker\asset\char_conf.txt` →
     ```
     char_ip: 25.x.x.x
     ```
   - `<rathena>\tools\docker\asset\map_conf.txt` →
     ```
     map_ip: 25.x.x.x
     ```
   > ⚠️ อย่าแก้ `login_ip: login` กับ `char_ip: char` (ในไฟล์ map) — สองอันนั้นให้คงเดิม
4. `stop.bat` → `2-start.bat` ใหม่
5. เพื่อนตั้ง `clientinfo.xml` ใช้ IP Hamachi ของคุณ

### ทางเปิดเน็ตบ้าน: Port Forward
เปิด port **6900, 6121, 5121** ที่ router → ชี้มาที่เครื่องคุณ → เพื่อนใช้ Public IP ของคุณ
(วิธีใส่ IP เหมือน Hamachi แต่ใช้ Public IP / DDNS แทน)

---

## 🔁 ใช้งานประจำวัน

| อยากทำ | ดับเบิลคลิก |
|---|---|
| เปิดเซิร์ฟ | `2-start.bat` |
| ปิดเซิร์ฟ | `stop.bat` |
| ดู log | `logs.bat` |
| ล้าง DB เริ่มใหม่ | `reset-db.bat` |

> ตัวละคร/ของ ถูกเซฟไว้ในฐานข้อมูล (persist) ปิด-เปิดไม่หาย

---

## 🛠️ แก้ปัญหาที่เจอบ่อย

| อาการ | วิธีแก้ |
|---|---|
| `.bat` เด้งปิดทันที / error Docker | เปิด **Docker Desktop** ให้ขึ้น Engine running ก่อน |
| compile error | เช็คว่าแก้ `renewal.hpp` ครบ 7 บรรทัด + เซฟแล้ว, ลอง `1-compile.bat` ใหม่ |
| port 3306 ติด | มี MariaDB/MySQL อื่นเปิดอยู่ในเครื่อง → ปิดก่อน |
| char list ว่าง / เข้าเกมไม่ได้ | ดู `logs.bat` ว่ามี error ไหม, เช็ค `char_ip`/`map_ip` ตรงกับ IP ที่ client ใช้ |
| เพื่อนต่อไม่ได้ | เช็ค Hamachi เชื่อมกัน, firewall ปิด, แก้ `char_ip`/`map_ip` แล้ว restart |
| EXP ไม่ x50 | เช็คว่าวาง `battle_conf.txt` ใน `conf/import/` ถูก แล้ว restart |

---

## 📁 ไฟล์ในชุดนี้

```
server/
├─ START_HERE.md            ← คู่มือนี้
├─ conf-import/
│   └─ battle_conf.txt       → ก๊อปไป <rathena>/conf/import/
└─ rathena-root/             → ก๊อปทั้งหมดไป <rathena>/ (รากโฟลเดอร์)
    ├─ 1-compile.bat          (compile ครั้งแรก)
    ├─ 2-start.bat            (เปิดเซิร์ฟ)
    ├─ stop.bat              (ปิดเซิร์ฟ)
    ├─ logs.bat              (ดู log)
    ├─ make-gm.bat           (สร้างไอดี GM)
    ├─ reset-db.bat          (ล้าง DB)
    └─ account-gm.sql        (ข้อมูลไอดี GM)
```

---

ติดตรงไหนบอกได้เลย — เอา error จาก `logs.bat` มาให้ดูได้ครับ 🐲
