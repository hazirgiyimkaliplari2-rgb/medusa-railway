# Medusa Railway Deployment Kılavuzu

## 🚀 Railway'e Deploy Etme Adımları

### 1. Ön Hazırlık
- Railway hesabınıza giriş yapın: https://railway.app
- GitHub hesabınızı Railway'e bağlayın

### 2. Projeyi GitHub'a Yükleme
```bash
cd medusa-railway
git init
git add .
git commit -m "Initial Medusa setup for Railway"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/medusa-railway.git
git push -u origin main
```

### 3. Railway'de Yeni Proje Oluşturma

#### A. Railway Dashboard'dan:
1. "New Project" butonuna tıklayın
2. "Deploy from GitHub repo" seçeneğini seçin
3. `medusa-railway` reponuzu seçin

#### B. Railway CLI ile:
```bash
# Railway CLI kurulum
npm install -g @railway/cli

# Login
railway login

# Proje oluştur
railway init

# Deploy
railway up
```

### 4. PostgreSQL Database Ekleme
Railway Dashboard'da:
1. Projenize gidin
2. "New Service" → "Database" → "PostgreSQL" seçin
3. PostgreSQL otomatik olarak eklenecek

### 5. Environment Variables Ayarlama

Railway Dashboard → Variables sekmesinde aşağıdaki değişkenleri ekleyin:

```env
# Otomatik oluşturulur
DATABASE_URL=(Railway PostgreSQL URL'i otomatik gelir)

# Manuel eklemeniz gerekenler:
JWT_SECRET=your-super-secret-jwt-token-here
COOKIE_SECRET=your-super-secret-cookie-token-here
STORE_URL=https://your-store.railway.app
BACKEND_URL=https://your-medusa-backend.railway.app
ADMIN_URL=https://your-medusa-backend.railway.app/admin
AUTH_URL=https://your-medusa-backend.railway.app/auth

# Port (Railway otomatik ayarlar)
PORT=9000

# Node Environment
NODE_ENV=production
```

### 6. Redis Ekleme (Opsiyonel)
Eğer cache için Redis kullanmak isterseniz:
1. "New Service" → "Database" → "Redis"
2. `REDIS_URL` otomatik olarak environment'a eklenecek

### 7. Domain Ayarlama
1. Service Settings → Domains
2. "Generate Domain" veya kendi domain'inizi ekleyin
3. Domain oluştuktan sonra `BACKEND_URL` ve diğer URL'leri güncelleyin

### 8. Database Migration ve Seed
Railway Shell'de veya local'de:
```bash
# Migrations
railway run yarn medusa migrations run

# Seed data (opsiyonel)
railway run yarn seed
```

### 9. Deployment Kontrol
- Railway Dashboard'da deployment loglarını kontrol edin
- Service sağlıklı çalışıyor mu kontrol edin
- Domain üzerinden API'ye erişim test edin: `https://your-domain.railway.app/health`

## 🔧 Önemli Notlar

### Database Bağlantısı
- Railway otomatik olarak `DATABASE_URL` sağlar
- PostgreSQL kullanılır
- Connection pooling için `pg-pool` kullanabilirsiniz

### Environment Variables
- Tüm secret'lar güçlü ve unique olmalı
- Production'da `NODE_ENV=production` olmalı
- URL'ler HTTPS kullanmalı

### Performance
- Railway otomatik scaling yapar
- Memory ve CPU limitleri ayarlanabilir
- Minimum 512MB RAM önerilir

### Monitoring
- Railway Dashboard'da metrics görüntülenebilir
- Logs realtime takip edilebilir
- Health checks eklenebilir

## 🚨 Troubleshooting

### Build Hatası
```bash
# Package.json'da engine versiyonu kontrol edin
"engines": {
  "node": ">=20"
}
```

### Database Bağlantı Hatası
- `DATABASE_URL` doğru ayarlandığından emin olun
- PostgreSQL service'in çalıştığını kontrol edin

### Port Hatası
- Railway otomatik port atar, `process.env.PORT` kullanın
- Hardcoded port kullanmayın

## 📝 Deploy Sonrası Yapılacaklar

1. Admin kullanıcı oluştur
2. API key'leri generate et
3. Webhook'ları konfigüre et
4. Payment provider'ları ekle
5. Email service'i konfigüre et

## 🔗 Faydalı Linkler

- [Railway Docs](https://docs.railway.app)
- [Medusa Docs](https://docs.medusajs.com)
- [Medusa Deployment Guide](https://docs.medusajs.com/deployments/server/deploying-on-railway)