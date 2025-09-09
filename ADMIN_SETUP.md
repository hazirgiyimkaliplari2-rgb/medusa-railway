# Medusa Admin Panel Setup

## Admin Panel Access

The Medusa admin panel is automatically built and deployed with your application.

### URLs

- **Local Development**: http://localhost:9000/app
- **Production (Railway)**: https://your-app.railway.app/app

## Default Admin Credentials

For testing purposes, an admin user has been created:

- **Email**: admin@medusa.com
- **Password**: supersecret123

⚠️ **IMPORTANT**: Change these credentials in production!

## Creating Admin Users

### Method 1: Using NPM Script
```bash
# Local
npm run create:admin

# On Railway
railway run npm run create:admin
```

### Method 2: Using Medusa CLI
```bash
# Local
npx medusa user --email your-email@domain.com --password your-password

# On Railway  
railway run npx medusa user --email your-email@domain.com --password your-password
```

### Method 3: Environment Variables
Set these before running the create:admin script:
```bash
export ADMIN_EMAIL=admin@yourdomain.com
export ADMIN_PASSWORD=your-secure-password
npm run create:admin
```

## Admin Panel Features

Once logged in to the admin panel, you can:

1. **Products Management**
   - Add, edit, and delete products
   - Manage product variants and inventory
   - Set pricing and discounts

2. **Orders Management**
   - View and process orders
   - Handle returns and exchanges
   - Track fulfillment status

3. **Customer Management**
   - View customer profiles
   - Manage customer groups
   - Track order history

4. **Settings**
   - Configure regions and currencies
   - Set up payment providers
   - Manage shipping options
   - Configure tax rates

## Customizing the Admin Panel

The admin panel can be customized by adding files to the `src/admin/` directory:

### Adding Custom Pages
Create a new file in `src/admin/routes/`:
```typescript
// src/admin/routes/custom-page.tsx
import { defineRouteConfig } from "@medusajs/admin-sdk"
import { Container, Heading } from "@medusajs/ui"

const CustomPage = () => {
  return (
    <Container>
      <Heading>Custom Admin Page</Heading>
    </Container>
  )
}

export const config = defineRouteConfig({
  label: "Custom Page",
})

export default CustomPage
```

### Adding Widgets
Create widgets in `src/admin/widgets/`:
```typescript
// src/admin/widgets/product-widget.tsx
import { defineWidgetConfig } from "@medusajs/admin-sdk"
import { Container } from "@medusajs/ui"

const ProductWidget = () => {
  return (
    <Container>
      <p>Custom product widget</p>
    </Container>
  )
}

export const config = defineWidgetConfig({
  zone: "product.details.after",
})

export default ProductWidget
```

## Environment Variables for Admin

Add these to your Railway environment:

```env
# Admin Panel Configuration
ADMIN_CORS=https://your-app.railway.app
BACKEND_URL=https://your-app.railway.app
ADMIN_URL=https://your-app.railway.app/app

# Security (use strong values in production)
JWT_SECRET=your-super-secret-jwt-key
COOKIE_SECRET=your-super-secret-cookie-key
```

## Troubleshooting

### Admin panel not loading
1. Ensure the build includes admin: `yarn build`
2. Check that port 9000 is exposed
3. Verify ADMIN_CORS environment variable

### Can't log in
1. Ensure database migrations are run: `medusa db:migrate`
2. Create a new admin user: `npx medusa user --email admin@test.com --password test123`
3. Check JWT_SECRET and COOKIE_SECRET are set

### Styling issues
1. Clear browser cache
2. Rebuild admin: `medusa build --admin-only`
3. Check for custom CSS conflicts in `src/admin/`

## Security Best Practices

1. **Change default credentials immediately**
2. **Use strong JWT and Cookie secrets**
3. **Configure ADMIN_CORS to specific domains**
4. **Enable 2FA when available**
5. **Regularly update Medusa dependencies**
6. **Monitor admin access logs**

## Support

For more information, visit:
- [Medusa Documentation](https://docs.medusajs.com)
- [Admin Customization Guide](https://docs.medusajs.com/admin)
- [Railway Deployment Guide](https://docs.railway.app)