#!/usr/bin/env node

/**
 * Script to create an admin user for Medusa
 * Usage: node scripts/create-admin.js
 */

const { execSync } = require('child_process');

// Admin credentials - change these for production!
const ADMIN_EMAIL = process.env.ADMIN_EMAIL || 'admin@medusa.com';
const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD || 'supersecret123';

console.log('Creating admin user...');
console.log(`Email: ${ADMIN_EMAIL}`);

try {
  // Create admin user using Medusa CLI
  const command = `npx medusa user --email ${ADMIN_EMAIL} --password ${ADMIN_PASSWORD}`;
  
  execSync(command, { 
    stdio: 'inherit',
    env: { ...process.env }
  });
  
  console.log('\n✅ Admin user created successfully!');
  console.log(`\n📧 Email: ${ADMIN_EMAIL}`);
  console.log('🔑 Password: [hidden]');
  console.log('\n🌐 Access admin panel at: /app');
  
} catch (error) {
  if (error.message.includes('already exists')) {
    console.log('\n⚠️  Admin user already exists with this email');
  } else {
    console.error('\n❌ Failed to create admin user:', error.message);
    process.exit(1);
  }
}