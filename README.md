# Edcynamodya - Auto Cooking & Collecting Bot

Edcynamodya adalah skrip otomasi untuk game grow a garden di Roblox yang membantu pemain memasak waffle dan mengumpulkan hasil kebun secara otomatis. Dengan antarmuka minimalis dan performa ringan, skrip ini cocok untuk sesi farming panjang tanpa membebani sistem.

## Fitur Utama

- 🧇 **Auto Cooking**: Masak waffle secara otomatis dengan resep default
- 🌱 **Auto Collect**: Kumpulkan hasil kebun dan submit otomatis
- ⚙️ **Adjustable Delay**: Atur delay antara 0.1-3 detik
- 💾 **Config Save**: Penyimpanan pengaturan otomatis
- 📱 **Minimalist UI**: Antarmuka ringan (220x140 piksel)
- ⚡ **Low Resource**: Tanpa aset eksternal untuk performa optimal
- 🖥️ **Console Fallback**: Mode konsol jika UI gagal dimuat

## Instalasi

1. Salin kode di bawah ini
2. Buka game grow a garden di Roblox
3. Jalankan melalui executor (KRNL, Synapse, Fluxus dll):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/username/repo/main/src/init.lua"))()
```

## Penggunaan

### Melalui UI
1. **Auto Cook Waffle**: Klik toggle untuk mengaktifkan/menonaktifkan
2. **Auto Collect**: Klik toggle untuk mengaktifkan/menonaktifkan
3. **Delay**: Geser slider untuk mengatur kecepatan

### Melalui Console (Fallback Mode)
Jika UI gagal dimuat, gunakan perintah:
```lua
_G.Toggle(1)  -- Aktifkan/nonaktifkan Auto Cook
_G.Toggle(2)  -- Aktifkan/nonaktifkan Auto Collect
```

Cek Output untuk status saat ini:
```
[Fallback] Gunakan perintah berikut di console:
_G.Toggle(1) - AutoCook Waffle
_G.Toggle(2) - AutoCollect & Submit
Status saat ini:
AutoCook: true
AutoCollect: false
Delay: 0.5 detik
```

## Konfigurasi

Pengaturan otomatis disimpan di:
- Executor: `getgenv().GardenFarmerConfig`
- Variabel:
  ```lua
  {
      AutoCook = true/false,
      AutoCollect = true/false,
      Delay = 0.1-3.0
  }
  ```

## Troubleshooting

- **Remote tidak ditemukan**: 
  - Pastikan Anda di tempat yang benar (kebun/dapur)
  - Tunggu 5-10 detik setelah injeksi
- **UI tidak muncul**:
  - Gunakan mode konsol dengan `_G.Toggle()`
  - Cek Output untuk pesan error
- **Fitur tidak bekerja**:
  - Perbarui game/script
  - Kurangi delay (0.3-0.5 detik optimal)

## Kontribusi

Laporkan issue atau ajukan fitur di [GitHub Repository](https://github.com/username/repo)

## Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE) - bebas digunakan, modifikasi, dan distribusi.

---

**Version**: 2.1 Lite  
**Last Update**: 4 Agustus 2025  
**Compatibility**: Roblox gag v1.5+  
**Tested Executors**: KRNL, Synapse X, Fluxus
