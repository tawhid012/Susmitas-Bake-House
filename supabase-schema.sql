-- SUPABASE DATABASE SCHEMA FOR SUSMITA'S BAKE HOUSE
-- Copy and paste this entire script into your Supabase SQL Editor and click "Run"

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Categories Table
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    image TEXT,
    description TEXT,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Products Table
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    short_description TEXT,
    ingredients TEXT,
    flavor_options JSONB DEFAULT '[]'::jsonb,
    weight_options JSONB DEFAULT '[]'::jsonb,
    base_price INTEGER NOT NULL,
    image_url TEXT,
    featured BOOLEAN DEFAULT false,
    bestseller BOOLEAN DEFAULT false,
    active BOOLEAN DEFAULT true,
    seo_title TEXT,
    seo_description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Orders Table
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number TEXT UNIQUE NOT NULL,
    customer_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT NOT NULL,
    delivery_date DATE NOT NULL,
    delivery_time TEXT NOT NULL,
    order_status TEXT DEFAULT 'Pending',
    notes TEXT,
    total_amount INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Order Items Table
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE SET NULL,
    product_name TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    flavor TEXT,
    weight TEXT,
    cake_message TEXT,
    price INTEGER NOT NULL,
    type TEXT DEFAULT 'standard'
);

-- Row Level Security (RLS) Policies
-- Allow public read access to categories and products
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone." ON categories FOR SELECT USING (true);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public products are viewable by everyone." ON products FOR SELECT USING (true);

-- Allow public to INSERT orders (for checkout)
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can insert orders" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view orders" ON orders FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can update orders" ON orders FOR UPDATE USING (auth.role() = 'authenticated');

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can insert order items" ON order_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can view order items" ON order_items FOR SELECT USING (auth.role() = 'authenticated');

-- Insert some dummy data to get started
INSERT INTO categories (name, slug) VALUES 
('Birthday Cakes', 'birthday-cakes'),
('Bento Cakes', 'bento-cakes'),
('Cupcakes', 'cupcakes');

INSERT INTO products (name, slug, short_description, base_price, bestseller, image_url) VALUES 
('Belgian Chocolate Truffle', 'belgian-chocolate-truffle', 'Dark Chocolate • Eggless option', 850, true, 'sig_truffle_1780105863136.png'),
('Elegant Floral Vanilla', 'elegant-floral-vanilla', 'Vanilla • Fresh Fruit Filling', 750, false, 'sig_floral_1780105847644.png');
