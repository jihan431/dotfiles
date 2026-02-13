# Telegram-like Chat Application

Aplikasi chat real-time dengan fitur lengkap yang mirip Telegram, dibangun dengan Node.js, Socket.IO, dan MongoDB.

## 🚀 Fitur Utama

### ✅ Fitur yang Sudah Diimplementasikan

1. **Real-time Messaging**
   - ✅ Pengiriman dan penerimaan pesan secara real-time dengan Socket.IO
   - ✅ Support emoji picker dengan berbagai kategori
   - ✅ Emoji search functionality
   - ✅ Message history loading
   - ✅ Message timestamps

2. **Status Online/Offline**
   - ✅ Indikator status online real-time untuk setiap user
   - ✅ Badge status di avatar user (green/gray indicator)
   - ✅ Update otomatis saat user connect/disconnect
   - ✅ Last seen timestamp

3. **Typing Indicator**
   - ✅ Notifikasi "sedang mengetik..." dengan animasi
   - ✅ Animated dots visual feedback
   - ✅ Real-time sync antar user

4. **Read Receipts**
   - ✅ Single check mark (✓) - pesan terkirim
   - ✅ Double check mark (✓✓) - pesan tersampaikan
   - ✅ Update status otomatis

5. **Voice & Video Calls**
   - ✅ WebRTC peer-to-peer connection dengan STUN server
   - ✅ Voice call dengan audio
   - ✅ Video call dengan kamera
   - ✅ Call controls (mute, video on/off, end call)
   - ✅ Call duration timer
   - ✅ Call ringtone notification

6. **Responsive Design**
   - ✅ Fully optimized untuk desktop, tablet, dan mobile
   - ✅ Sidebar overlay untuk semua devices
   - ✅ Unified fullscreen layout (single column)
   - ✅ Back button navigation untuk mobile
   - ✅ Touch-friendly interface
   - ✅ Smooth animations dan transitions
   - ✅ Media breakpoints: 1024px (login), 768px (tablet), 480px (mobile)

7. **UI/UX Enhancements**
   - ✅ Design modern mirip Telegram
   - ✅ Gradient header (primary + secondary colors)
   - ✅ Message bubbles dengan tail dan styling
   - ✅ Smooth scrolling
   - ✅ Emoji picker dengan UI modern
   - ✅ Color scheme: Primary #667eea, Secondary #764ba2
   - ✅ Status badges (online/offline indicators)

8. **Authentication**
   - ✅ Register dengan username, nama lengkap, dan email
   - ✅ Login dengan authentication
   - ✅ Session management dengan localStorage
   - ✅ Auto-redirect ke login jika belum authenticate
   - ✅ Logout functionality

## 📋 Persyaratan Sistem

- Node.js (v14 atau lebih baru)
- MongoDB (v4.4 atau lebih baru)
- Browser modern dengan support WebRTC

## 🛠️ Instalasi

### Prerequisites
- Node.js v14 atau lebih baru
- MongoDB v4.4 atau lebih baru
- Browser modern dengan support WebRTC (Chrome, Firefox, Safari, Edge)

### Langkah-langkah Instalasi

1. **Clone atau copy files ke direktori project**
```bash
cd /home/lyon/vcvc
```

2. **Install dependencies**
```bash
npm install
```

3. **Pastikan MongoDB sudah running**
```bash
# Windows
net start MongoDB

# Linux (Ubuntu/Debian)
sudo systemctl start mongod

# Linux (Arch)
sudo systemctl start mongodb

# macOS dengan Homebrew
brew services start mongodb-community

# Atau jalankan mongod langsung
mongod
```

4. **Jalankan server**
```bash
npm start
```
Server akan berjalan di `http://localhost:3000`

5. **Buka browser dan akses**
```
http://localhost:3000
```
Gunakan browser yang mendukung WebRTC untuk fitur voice/video calls.

## 📱 Cara Penggunaan

### Registrasi & Login
1. Buka aplikasi di browser
2. Pilih tab "Register" untuk membuat akun baru
3. Isi username, nama lengkap, dan email
4. Atau pilih tab "Login" jika sudah punya akun

### Mengirim Pesan
1. Pilih kontak dari sidebar
2. Ketik pesan di input box
3. Tekan Enter atau klik tombol kirim
4. Lihat status pesan (terkirim/tersampaikan/dibaca)

### Mengirim File
1. Klik icon attachment (📎)
2. Pilih file dari komputer
3. Preview file akan muncul
4. Klik tombol kirim atau cancel untuk membatalkan

### Menggunakan Emoji
1. Klik icon emoji (😊)
2. Pilih kategori emoji
3. Klik emoji untuk memasukkan ke pesan
4. Atau gunakan search untuk mencari emoji

### Voice/Video Call
1. Pilih kontak yang ingin dihubungi
2. Klik icon telepon untuk voice call
3. Atau klik icon video untuk video call
4. Tunggu kontak menerima panggilan
5. Gunakan controls untuk mute/unmute atau end call

### Mobile Usage
1. Klik tombol back (←) di header untuk membuka sidebar
2. Pilih kontak dari sidebar
3. Sidebar akan otomatis tertutup saat chat dibuka
4. Semua fitur tetap berfungsi di mobile
5. Responsive design otomatis menyesuaikan layout untuk mobile (480px dan dibawah)

### Desktop Usage
1. Sidebar selalu terlihat di sisi kiri
2. Chat area menempati sisa ruang layar
3. Semua fitur dapat diakses dengan mudah
4. Layout responsif untuk desktop dan tablet (1024px ke atas)

## 🎨 Fitur UI/UX

- **Modern Gradient Theme**: 
  - Primary color: #667eea
  - Secondary color: #764ba2
  - Gradient applied to chat headers
- **Message Bubbles**: 
  - Sent messages: Light blue/green background
  - Received messages: White background
  - Messages with timestamps dan read receipts
- **Smooth Animations**: 
  - Fade in effects
  - Slide transitions
  - Pulse effects untuk status indicators
  - Animated typing indicators (animated dots)
- **Status Indicators**: 
  - Online/offline badges dengan color coding
  - Last seen information
- **Responsive Layout**: 
  - Optimal di semua ukuran layar
  - Sidebar overlay untuk mobile
  - Fullscreen single-column chat layout
  - Fixed header dan sticky input area

## 🔧 Konfigurasi

### MongoDB Connection
Edit di `server.js`:
```javascript
mongoose.connect('mongodb://localhost:27017/chatapp');
```

### Server Port
Edit di `server.js`:
```javascript
const PORT = process.env.PORT || 3000;
```

### File Upload Size Limit
Edit di `server.js`:
```javascript
maxHttpBufferSize: 10e6 // 10MB
```

## 📊 Database Schema

### Users Collection
```javascript
{
  _id: ObjectId,
  username: String (unique),
  nama: String,
  email: String (unique),
  createdAt: Date,
  lastSeen: Date,
  status: String ('online' | 'offline')
}
```

### Messages Collection
```javascript
{
  _id: ObjectId,
  from: String,
  to: String,
  message: String,
  timestamp: Date,
  delivered: Boolean,
  read: Boolean,
  file: {
    name: String,
    size: Number,
    type: String,
    data: String (base64)
  }
}
```

### Groups Collection (Siap diimplementasikan)
```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  members: [String],
  admin: String,
  createdAt: Date,
  avatar: String
}
```

## 🚀 Fitur Mendatang (Roadmap)

- [ ] File attachment (gambar, dokumen, video)
- [ ] File preview dalam chat
- [ ] Message reactions (❤️, 👍, dll)
- [ ] Voice message recording
- [ ] Message forwarding
- [ ] Message delete/edit
- [ ] User blocking
- [ ] Message search
- [ ] Dark mode
- [ ] Push notifications
- [ ] Desktop notifications
- [ ] Message encryption
- [ ] Profile customization
- [ ] Group Chat Support (Create, join group, member management)
- [ ] Group messaging
- [ ] Group admin controls
- [ ] Media gallery view

## 🐛 Troubleshooting

### MongoDB Connection Error
- Pastikan MongoDB service sudah running
- Check connection string di server.js
- Pastikan port 27017 tidak digunakan aplikasi lain

### WebRTC Call Issues
- Pastikan browser mendukung WebRTC
- Allow camera/microphone permissions
- Check firewall settings
- Gunakan HTTPS untuk production

### File Upload Gagal
- Check file size limit (default 10MB)
- Pastikan format file didukung
- Check browser console untuk error

## 📝 Catatan Penting

1. **WebRTC**: 
   - Saat ini menggunakan Google STUN server (stun.l.google.com:19302)
   - Untuk production, tambahkan TURN server untuk koneksi yang lebih stabil
   - Test koneksi di berbagai jaringan (WiFi, mobile hotspot)

2. **File Storage**: 
   - Saat ini file disimpan sebagai base64 di database
   - Untuk production, gunakan cloud storage (AWS S3, Cloudinary, dll)
   - Limit file size default: 10MB

3. **Security**: 
   - Implementasikan authentication yang lebih robust (JWT, password hashing)
   - Gunakan HTTPS untuk production
   - Sanitize input dari user
   - Validate file uploads

4. **Performance & Scalability**: 
   - Gunakan Redis untuk session management
   - Implement message queue untuk aplikasi skala besar
   - Database indexing untuk query optimization
   - Connection pooling untuk MongoDB

## 📄 License

MIT License - Bebas digunakan untuk project pribadi atau komersial

## 👨‍💻 Support

Jika ada pertanyaan atau issue, silakan buat issue di repository atau hubungi developer.

---

**Happy Chatting! 💬**