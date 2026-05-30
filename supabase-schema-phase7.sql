-- SUPABASE DATABASE SCHEMA EXTENSION FOR PHASE 7
-- Copy and paste this script into your Supabase SQL Editor and click "Run"
-- This adds the new tables for the advanced CMS

-- 5. Homepage Sections Table
CREATE TABLE homepage_sections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    section_key TEXT UNIQUE NOT NULL, -- e.g., 'hero', 'offers_banner', 'trust_indicators'
    content JSONB NOT NULL,
    active BOOLEAN DEFAULT true,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. FAQ Table
CREATE TABLE faqs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    display_order INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true
);

-- 7. Delivery Areas Table
CREATE TABLE delivery_areas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    area_name TEXT NOT NULL,
    delivery_available BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0
);

-- 8. Testimonials Table
CREATE TABLE testimonials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_name TEXT NOT NULL,
    review TEXT NOT NULL,
    rating INTEGER DEFAULT 5,
    image_url TEXT,
    featured BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. Gallery Table
CREATE TABLE gallery_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT,
    image_url TEXT NOT NULL,
    category TEXT,
    featured BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Row Level Security (RLS) Policies
-- Allow public read access
ALTER TABLE homepage_sections ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read homepage_sections." ON homepage_sections FOR SELECT USING (true);
CREATE POLICY "Admin write homepage_sections." ON homepage_sections FOR ALL USING (auth.role() = 'authenticated');

ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read faqs." ON faqs FOR SELECT USING (true);
CREATE POLICY "Admin write faqs." ON faqs FOR ALL USING (auth.role() = 'authenticated');

ALTER TABLE delivery_areas ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read delivery_areas." ON delivery_areas FOR SELECT USING (true);
CREATE POLICY "Admin write delivery_areas." ON delivery_areas FOR ALL USING (auth.role() = 'authenticated');

ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read testimonials." ON testimonials FOR SELECT USING (true);
CREATE POLICY "Admin write testimonials." ON testimonials FOR ALL USING (auth.role() = 'authenticated');

ALTER TABLE gallery_images ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read gallery_images." ON gallery_images FOR SELECT USING (true);
CREATE POLICY "Admin write gallery_images." ON gallery_images FOR ALL USING (auth.role() = 'authenticated');

-- Insert Initial Homepage Data
INSERT INTO homepage_sections (section_key, content) VALUES 
('hero', '{"headline": "Order Fresh!", "subheadline": "Premium bakes delivered in Hailakandi.", "image_url": "sig_truffle_1780105863136.png"}'::jsonb),
('offers_banner', '{"text": "Free Delivery on orders above ₹1000!", "link": "products.html", "active": true}'::jsonb),
('trust_indicators', '{"orders_completed": "500+", "happy_customers": "300+", "years_experience": "2"}'::jsonb)
ON CONFLICT (section_key) DO NOTHING;
